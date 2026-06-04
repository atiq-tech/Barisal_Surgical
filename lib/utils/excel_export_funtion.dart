import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> exportSalesExcel({
  required List allOrdersData,
  required double subTotal,
  required double vatTotal,
  required double discountTotal,
  required double transferCost,
  required double totalAmount,
  required double paidTotal,
  required double dueTotal,
}) async {
  var excel = Excel.createExcel();

  // 1. Default 'Sheet1' ke rename kora, jate blank sheet na thake
  String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
  excel.rename(defaultSheet, 'Sales Report');
  Sheet sheet = excel['Sales Report'];

  // Header
  sheet.appendRow([
    TextCellValue('Sl.'),
    TextCellValue('Invoice No'),
    TextCellValue('Date'),
    TextCellValue('Customer Name'),
    TextCellValue('Employee Name'),
    TextCellValue('Saved By'),
    TextCellValue('Sub Total'),
    TextCellValue('Vat'),
    TextCellValue('Discount'),
    TextCellValue('Transport Cost'),
    TextCellValue('Total'),
    TextCellValue('Paid'),
    TextCellValue('Due'),
    TextCellValue('Note'),
    TextCellValue('Status'),
  ]);

  // Data
  for (int i = 0; i < allOrdersData.length; i++) {
    // Try-Catch track korbe jodi double.parse-e kono jhamela hoy
    try {
      sheet.appendRow([
        IntCellValue(i + 1),
        TextCellValue(allOrdersData[i].saleMasterInvoiceNo ?? ''),
        TextCellValue(allOrdersData[i].saleMasterSaleDate ?? ''),
        TextCellValue(allOrdersData[i].customerNameMaster ?? ''),
        TextCellValue(allOrdersData[i].employeeName ?? ''),
        TextCellValue(allOrdersData[i].addedBy ?? ''),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterSubTotalAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterTaxAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterTotalDiscountAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterFreight.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterTotalSaleAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterPaidAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(allOrdersData[i].saleMasterDueAmount.toString()) ?? 0.0),
        TextCellValue(allOrdersData[i].saleMasterDescription ?? ''),
        TextCellValue(allOrdersData[i].status == "a" ? "Approved" : "Pending"),
      ]);
    } catch (e) {
      print("Row cross-check error at index $i: $e");
    }
  }

  // Total Row
  sheet.appendRow([
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue('TOTAL'),
    DoubleCellValue(subTotal),
    DoubleCellValue(vatTotal),
    DoubleCellValue(discountTotal),
    DoubleCellValue(transferCost),
    DoubleCellValue(totalAmount),
    DoubleCellValue(paidTotal),
    DoubleCellValue(dueTotal),
    TextCellValue(''),
    TextCellValue(''),
  ]);

  // Column Width
  for (int col = 0; col <= 14; col++) {
    sheet.setColumnWidth(col, col == 3 ? 30 : (col == 4 ? 25 : 15));
  }

  try {
    // 2. Storage Directory select kora
    Directory? directory;
    if (Platform.isAndroid) {
      // Android-e direct download folder ba external storage-e dile user dekhte pay
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory != null) {
      final filePath = '${directory.path}/Sales_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File(filePath);

      // File e bytes right kora
      final bytes = excel.encode();
      if (bytes != null) {
        await file.writeAsBytes(bytes);
        print("Excel Saved to: $filePath");
        
        // Open File
        final result = await OpenFile.open(filePath);
        print("Open file status: ${result.message}");
      }
    }
  } catch (e) {
    print("Error saving/opening excel: $e");
  }
}










// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';

// Future<void> exportSalesExcel({
//   required List allOrdersData,
//   required double subTotal,
//   required double vatTotal,
//   required double discountTotal,
//   required double transferCost,
//   required double totalAmount,
//   required double paidTotal,
//   required double dueTotal,
// }) async {
//   var excel = Excel.createExcel();

//   Sheet sheet = excel['Sales Report'];

//   // Header
//   sheet.appendRow([
//     TextCellValue('Sl.'),
//     TextCellValue('Invoice No'),
//     TextCellValue('Date'),
//     TextCellValue('Customer Name'),
//     TextCellValue('Employee Name'),
//     TextCellValue('Saved By'),
//     TextCellValue('Sub Total'),
//     TextCellValue('Vat'),
//     TextCellValue('Discount'),
//     TextCellValue('Transport Cost'),
//     TextCellValue('Total'),
//     TextCellValue('Paid'),
//     TextCellValue('Due'),
//     TextCellValue('Note'),
//     TextCellValue('Status'),
//   ]);

//   // Data
//   for (int i = 0; i < allOrdersData.length; i++) {
//     sheet.appendRow([
//       IntCellValue(i + 1),
//       TextCellValue(allOrdersData[i].saleMasterInvoiceNo ?? ''),
//       TextCellValue(allOrdersData[i].saleMasterSaleDate ?? ''),
//       TextCellValue(allOrdersData[i].customerNameMaster ?? ''),
//       TextCellValue(allOrdersData[i].employeeName ?? ''),
//       TextCellValue(allOrdersData[i].addedBy ?? ''),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterSubTotalAmount)),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterTaxAmount)),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterTotalDiscountAmount)),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterFreight)),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterTotalSaleAmount)),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterPaidAmount)),
//       DoubleCellValue(
//           double.parse(allOrdersData[i].saleMasterDueAmount)),
//       TextCellValue(allOrdersData[i].saleMasterDescription ?? ''),
//       TextCellValue(
//           allOrdersData[i].status == "a"
//               ? "Approved"
//               : "Pending"),
//     ]);
//   }

//   // Total Row
//   sheet.appendRow([
//     TextCellValue(''),
//     TextCellValue(''),
//     TextCellValue(''),
//     TextCellValue(''),
//     TextCellValue(''),
//     TextCellValue('TOTAL'),
//     DoubleCellValue(subTotal!),
//     DoubleCellValue(vatTotal!),
//     DoubleCellValue(discountTotal!),
//     DoubleCellValue(transferCost!),
//     DoubleCellValue(totalAmount!),
//     DoubleCellValue(paidTotal!),
//     DoubleCellValue(dueTotal!),
//     TextCellValue(''),
//     TextCellValue(''),
//   ]);

//   // Column Width
//   sheet.setColumnWidth(0, 8);
//   sheet.setColumnWidth(1, 20);
//   sheet.setColumnWidth(2, 15);
//   sheet.setColumnWidth(3, 30);
//   sheet.setColumnWidth(4, 25);
//   sheet.setColumnWidth(5, 20);
//   sheet.setColumnWidth(6, 15);
//   sheet.setColumnWidth(7, 15);
//   sheet.setColumnWidth(8, 15);
//   sheet.setColumnWidth(9, 15);
//   sheet.setColumnWidth(10, 15);
//   sheet.setColumnWidth(11, 15);
//   sheet.setColumnWidth(12, 15);
//   sheet.setColumnWidth(13, 25);
//   sheet.setColumnWidth(14, 15);

//   final directory = await getApplicationDocumentsDirectory();

//   final file = File('${directory.path}/Sales_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');

//   await file.writeAsBytes(excel.encode()!);

//   OpenFile.open(file.path);
// }