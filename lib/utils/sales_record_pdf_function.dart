import 'dart:io';
import 'dart:typed_data';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List?> fetchImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // খুব ছোট হলে ignore (invalid image protection)
      if (bytes.length < 500) return null;

      return bytes;
    }

    return null;
  } catch (e) {
    debugPrint("Image Load Error: $e");
    return null;
  }
}

Future<void> salesRecordPdf({
  required BuildContext context,
  required List allSalesData,
  required double subTotal,
  required double vatTotal,
  required double discountTotal,
  required double transferCost,
  required double totalAmount,
  required double paidTotal,
  required double dueTotal,
  required String companyName,
  required String repotHeading,
  required String companyLogothumb,
  required String firstDate,
  required String secondDate,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("Generating PDF..."),
        ],
      ),
    ),
  );

  try {
    String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());

    final Uint8List? logoBytes = await fetchImage("$imageBaseUrl$companyLogothumb");
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        maxPages: 500,
        margin: pw.EdgeInsets.all(2.r),
        pageFormat: PdfPageFormat.a4.landscape,
        header: (context) => pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 5.h),
        child: pw.Text(currentDateTime,style: pw.TextStyle(fontSize: 8.sp)),
        ),
        build: (context) => [
          pw.Row(
          children: [
            if (logoBytes != null && logoBytes.length > 1000)
            pw.Image(pw.MemoryImage(logoBytes),height: 80.h,width: 80.w,fit: pw.BoxFit.contain),
            pw.SizedBox(width: 75.w),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(companyName,style: pw.TextStyle(fontSize: 16.sp,fontWeight: pw.FontWeight.bold)),
                pw.Text(repotHeading,style: pw.TextStyle(fontSize: 10.sp)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 5.h),
        pw.Divider(height: 3.h,thickness: 1.5, color: PdfColors.grey700),
        pw.Divider(height: 4.h,thickness: 1.5, color: PdfColors.grey500),
        pw.SizedBox(height: 5.h),
          pw.Center(
            child: pw.Text(
              "Sales Record",
              style: pw.TextStyle(
                fontSize: 14.sp,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 5.h),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text("Statement from "),
              pw.Text(
                "$firstDate",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(" to "),
              pw.Text(
                "$secondDate",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 2.h),
          pw.Table.fromTextArray(
          border: pw.TableBorder.all(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
          ),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          headers: [
            "Sl.",
            "Invoice",
            "Date",
            "Customer",
            "Employee",
            "Saved By",
            "Sub Total",
            "Vat",
            "Discount",
            "Transport",
            "Total",
            "Paid",
            "Due",
            "Note",
            "Status",
          ],

          data: [
            // =========================
            // DATA ROWS
            // =========================
            ...List.generate(allSalesData.length, (index) {
              final item = allSalesData[index];

              return [
                "${index + 1}",
                item.saleMasterInvoiceNo ?? "",
                item.saleMasterSaleDate ?? "",
                item.customerNameMaster ?? "",
                item.employeeName ?? "",
                item.addedBy ?? "",
                item.saleMasterSubTotalAmount.toString(),
                item.saleMasterTaxAmount.toString(),
                item.saleMasterTotalDiscountAmount.toString(),
                item.saleMasterFreight.toString(),
                item.saleMasterTotalSaleAmount.toString(),
                item.saleMasterPaidAmount.toString(),
                item.saleMasterDueAmount.toString(),
                item.saleMasterDescription ?? "",
                item.status == "a" ? "Approved" : "Pending",
              ];
            }),

        /* =========================
          FOOTER TOTAL ROW (IMPORTANT)
          ========================= */
            [
              "", "", "", "", "",
              "TOTAL",
              subTotal.toString(),
              vatTotal.toString(),
              discountTotal.toString(),
              transferCost.toString(),
              totalAmount.toString(),
              paidTotal.toString(),
              dueTotal.toString(),
              "",
              "",
            ],
          ],
        )
        ],
      ),
    );

    Navigator.pop(context);

    // SAVE FILE TO DOWNLOADS
    Directory dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final filePath = "${dir.path}/Sales_Report_${DateTime.now().millisecondsSinceEpoch}.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // SHOW PRINT / SHARE UI
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("PDF Saved in Downloads"),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: "OPEN",
          textColor: Colors.white,
          onPressed: () async {
            await OpenFile.open(filePath);
          },
        ),
      ),
    );
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF Error: $e")),
    );
  }
}