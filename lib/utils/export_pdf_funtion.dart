import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportSalesPdf({
  required BuildContext context,
  required List allOrdersData,
  required double subTotal,
  required double vatTotal,
  required double discountTotal,
  required double transferCost,
  required double totalAmount,
  required double paidTotal,
  required double dueTotal,
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
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(1),
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "Order Record",
              style: pw.TextStyle(
                fontSize: 14.sp,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 5.h),
          pw.Divider(height: 1.h, thickness: 1.h),
          pw.SizedBox(height: 2.h),
          pw.Divider(height: 1.h,thickness: 1.h),
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
            ...List.generate(allOrdersData.length, (index) {
              final item = allOrdersData[index];

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

    final filePath = "${dir.path}/Order_Report_${DateTime.now().millisecondsSinceEpoch}.pdf";

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