// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// Future<void> exportOrdersExcel({
//   required BuildContext context,
//   required List allOrdersData,
//   required double subTotal,
//   required double vatTotal,
//   required double discountTotal,
//   required double transferCost,
//   required double totalAmount,
//   required double paidTotal,
//   required double dueTotal,
// }) async {

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => const AlertDialog(
//       content: Row(
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(width: 20),
//           Text("Preparing Excel..."),
//         ],
//       ),
//     ),
//   );

//   try {
//     // ================= CREATE EXCEL =================
//     final excel = Excel.createExcel();
//     final sheet = excel['Order Report'];

//     sheet.appendRow([
//       TextCellValue('Sl.'),
//       TextCellValue('Invoice No'),
//       TextCellValue('Date'),
//       TextCellValue('Customer'),
//       TextCellValue('Employee'),
//       TextCellValue('Sub Total'),
//       TextCellValue('Vat'),
//       TextCellValue('Discount'),
//       TextCellValue('Transport'),
//       TextCellValue('Total'),
//       TextCellValue('Paid'),
//       TextCellValue('Due'),
//       TextCellValue('Note'),
//       TextCellValue('Status'),
//     ]);

//     for (int i = 0; i < allOrdersData.length; i++) {
//       final item = allOrdersData[i];

//       sheet.appendRow([
//         IntCellValue(i + 1),
//         TextCellValue(item.saleMasterInvoiceNo?.toString() ?? ''),
//         TextCellValue(item.saleMasterSaleDate?.toString() ?? ''),
//         TextCellValue(item.customerNameMaster?.toString() ?? ''),
//         TextCellValue(item.employeeName?.toString() ?? ''),
//         DoubleCellValue(double.tryParse(item.saleMasterSubTotalAmount.toString()) ?? 0),
//         DoubleCellValue(double.tryParse(item.saleMasterTaxAmount.toString()) ?? 0),
//         DoubleCellValue(double.tryParse(item.saleMasterTotalDiscountAmount.toString()) ?? 0),
//         DoubleCellValue(double.tryParse(item.saleMasterFreight.toString()) ?? 0),
//         DoubleCellValue(double.tryParse(item.saleMasterTotalSaleAmount.toString()) ?? 0),
//         DoubleCellValue(double.tryParse(item.saleMasterPaidAmount.toString()) ?? 0),
//         DoubleCellValue(double.tryParse(item.saleMasterDueAmount.toString()) ?? 0),
//         TextCellValue(item.saleMasterDescription ?? ''),
//         TextCellValue(item.status == "a" ? "Approved" : "Pending"),
        
//       ]);
//     }
//     // TOTAL ROW
//     sheet.appendRow([
//       TextCellValue(''),
//       TextCellValue(''),
//       TextCellValue(''),
//       TextCellValue(''),
//       TextCellValue(''),
//       TextCellValue('TOTAL'),
//       DoubleCellValue(subTotal),
//       DoubleCellValue(vatTotal),
//       DoubleCellValue(discountTotal),
//       DoubleCellValue(transferCost),
//       DoubleCellValue(totalAmount),
//       DoubleCellValue(paidTotal),
//       DoubleCellValue(dueTotal),
//       TextCellValue(''),
//       TextCellValue(''),
//     ]);

//     final bytes = excel.encode();
//     if (bytes == null) throw "Excel encode failed";

//     Navigator.pop(context);
//     // ================= SAVE TO APP STORAGE =================
//     final dir = await getApplicationDocumentsDirectory();
//     final fileName = "Order_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx";
//     final file = File('${dir.path}/$fileName');
//     await file.writeAsBytes(bytes);

//     // ================= SHARE FILE =================
//     await Share.shareXFiles([XFile(file.path)],text: "Here is your Order Excel Report");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         backgroundColor: Colors.green,
//         content: Text("File created & ready to share"),
//       ),
//     );

//   } catch (e) {
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(backgroundColor: Colors.red,content: Text("Export Error: $e")),
//     );
//     debugPrint("Export Error => $e");
//   }
// }








// =========================
// ✅ DELETED UNUSED EXCEL EXPORT FUNCTION
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> exportOrdersExcel({
  required BuildContext context,
  required List allOrdersData,
  required double subTotal,
  required double vatTotal,
  required double discountTotal,
  required double transferCost,
  required double totalAmount,
  required double paidTotal,
  required double dueTotal,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("Exporting Excel..."),
        ],
      ),
    ),
  );

  try {
    final excel = Excel.createExcel();
    final sheet = excel['Order Report'];

    // HEADER
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

    // DATA
    for (int i = 0; i < allOrdersData.length; i++) {
      final item = allOrdersData[i];

      sheet.appendRow([
        IntCellValue(i + 1),
        TextCellValue(item.saleMasterInvoiceNo ?? ''),
        TextCellValue(item.saleMasterSaleDate ?? ''),
        TextCellValue(item.customerNameMaster ?? ''),
        TextCellValue(item.employeeName ?? ''),
        TextCellValue(item.addedBy ?? ''),
        DoubleCellValue(double.tryParse(item.saleMasterSubTotalAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(item.saleMasterTaxAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(item.saleMasterTotalDiscountAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(item.saleMasterFreight.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(item.saleMasterTotalSaleAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(item.saleMasterPaidAmount.toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(item.saleMasterDueAmount.toString()) ?? 0.0),
        TextCellValue(item.saleMasterDescription ?? ''),
        TextCellValue(item.status == "a" ? "Approved" : "Pending"),
      ]);
    }

    // TOTAL ROW
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

    final bytes = excel.encode();

    if (bytes == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Excel generate failed")),
      );
      return;
    }

    // =========================
    // ✅ UPDATED SAVE LOCATION (DOWNLOADS FOLDER)
    // =========================
    Directory directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = "${directory.path}/Order_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx";

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Excel Export Successful (Saved in Downloads)"),
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

    await OpenFile.open(filePath);

    print("Saved at: $filePath");
  } catch (e) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Export Error: $e")),
    );

    print("Export Error => $e");
  }
}
