import 'dart:typed_data';

import 'package:barishal_surgical/utils/const_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

Future<void> printEcpWiseSalesPdf({
  required BuildContext context,
  required List allEcpWiseSalesReportData,
  required String companyName,
  required String repotHeading,
  required String companyLogothumb,
  required String firstDate,
  required String secondDate,
}) async {
  String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());

  final Uint8List? logoBytes = await fetchImage("$imageBaseUrl$companyLogothumb");

  final pdf = pw.Document();

  allEcpWiseSalesReportData.sort((a, b) {
    int cus = (a.customerName ?? "").compareTo(b.customerName ?? "");
    if (cus != 0) return cus;
    return (a.productName ?? "").compareTo(b.productName ?? "");
  });

  List<List<String>> tableData = [];

  String currentCustomer = "";
  int serial = 0;

  double cusQty = 0;
  double cusAmount = 0;

  double grandQty = 0;
  double grandAmount = 0;

  for (final data in allEcpWiseSalesReportData) {
    double qty = double.tryParse(data.quantity ?? "0") ?? 0;
    double amount = double.tryParse(data.amount ?? "0") ?? 0;

    if (currentCustomer != (data.customerName ?? "")) {
      if (currentCustomer.isNotEmpty) {
        tableData.add([
          '',
          '',
          '',
          'Sub Total For ($currentCustomer)',
          cusQty.toStringAsFixed(0),
          cusAmount.toStringAsFixed(2),
        ]);
      }

      currentCustomer = data.customerName ?? '';
      serial = 0;
      cusQty = 0;
      cusAmount = 0;
    }

    serial++;

    tableData.add([
      serial.toString(),
      data.employeeName ?? "",
      data.customerName ?? "",
      data.productName ?? "",
      qty.toStringAsFixed(0),
      amount.toStringAsFixed(2),
    ]);

    cusQty += qty;
    cusAmount += amount;

    grandQty += qty;
    grandAmount += amount;
  }

  if (currentCustomer.isNotEmpty) {
    tableData.add([
      '',
      '',
      '',
      'Sub Total For ($currentCustomer)',
      cusQty.toStringAsFixed(0),
      cusAmount.toStringAsFixed(2),
    ]);
  }

  tableData.add([
    '',
    '',
    '',
    'Grand Total',
    grandQty.toStringAsFixed(0),
    grandAmount.toStringAsFixed(2),
  ]);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: pw.EdgeInsets.all(2.r),
       header: (context) => pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 5.h),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(currentDateTime,style: pw.TextStyle(fontSize: 8.sp)),
            pw.Text("Customer Payment Report",style: pw.TextStyle(fontSize: 8.sp)),
            pw.Text("",style: pw.TextStyle(fontSize: 8.sp)),
          ],
        ),
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
            "Employee Customer Product Wise Sales Report",
            style: pw.TextStyle(fontSize: 16.sp,fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 5.h),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text("Statement from "),
            pw.Text(firstDate,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(" to "),
            pw.Text(secondDate,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
        pw.SizedBox(height: 8.h),
        pw.Table.fromTextArray(
          border: pw.TableBorder.all(),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          headers: const [
            'SL No',
            'Employee',
            'Customer',
            'Product',
            'Quantity',
            'Amount',
          ],
          data: tableData,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10.sp),
          cellStyle: pw.TextStyle(fontSize: 9.sp),
          cellAlignment: pw.Alignment.center,
        ),
      ],
    ),
  );
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}