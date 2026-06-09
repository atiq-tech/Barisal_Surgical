import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> exportEcpWiseSalesExcel({
  required BuildContext context,
  required List allEcpWiseSalesReportData,
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
    final sheet = excel['ECP Wise Sales'];

    // Header
  sheet.appendRow([
    TextCellValue('SL No'),
    TextCellValue('Employee'),
    TextCellValue('Customer'),
    TextCellValue('Product'),
    TextCellValue('Quantity'),
    TextCellValue('Amount'),
  ]);

  allEcpWiseSalesReportData.sort((a, b) {
    int cus = (a.customerName ?? "").compareTo(b.customerName ?? "");
    if (cus != 0) return cus;
    return (a.productName ?? "").compareTo(b.productName ?? "");
  });

  String currentCustomer = "";

  int serial = 0;
  double cusQty = 0;
  double cusAmount = 0;

  double grandQty = 0;
  double grandAmount = 0;

  for (int i = 0; i < allEcpWiseSalesReportData.length; i++) {
    final data = allEcpWiseSalesReportData[i];

    double qty = double.tryParse(data.quantity ?? "0") ?? 0;
    double amount = double.tryParse(data.amount ?? "0") ?? 0;

    // Customer Change
    if (currentCustomer != (data.customerName ?? "")) {
      if (currentCustomer.isNotEmpty) {
        sheet.appendRow([
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue('Sub Total For ($currentCustomer)'),
          DoubleCellValue(cusQty),
          DoubleCellValue(cusAmount),
        ]);
      }

      currentCustomer = data.customerName ?? "";

      serial = 0;
      cusQty = 0;
      cusAmount = 0;
    }

    serial++;

    // Normal Row
    sheet.appendRow([
      IntCellValue(serial),
      TextCellValue(data.employeeName ?? ""),
      TextCellValue(data.customerName ?? ""),
      TextCellValue(data.productName ?? ""),
      DoubleCellValue(qty),
      DoubleCellValue(amount),
    ]);

    cusQty += qty;
    cusAmount += amount;

    grandQty += qty;
    grandAmount += amount;
  }

  // Last Customer Sub Total
  if (currentCustomer.isNotEmpty) {
    sheet.appendRow([
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('Sub Total For ($currentCustomer)'),
      DoubleCellValue(cusQty),
      DoubleCellValue(cusAmount),
    ]);
  }

  // Grand Total
  sheet.appendRow([
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue('Grand Total'),
    DoubleCellValue(grandQty),
    DoubleCellValue(grandAmount),
  ]);

  // Auto Width
  for (int column = 0; column < 6; column++) {
    sheet.setColumnWidth(column, 25);
  }
    final bytes = excel.encode();

    if (bytes == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Excel generate failed")),
      );
      return;
    }

    Directory directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath =
        "${directory.path}/ECP_Wise_Sales_${DateTime.now().millisecondsSinceEpoch}.xlsx";

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










// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';

// Future<void> exportEcpWiseSalesExcel({
//   required BuildContext context,
//   required List allEcpWiseSalesReportData,
// }) async {
//   final excel = Excel.createExcel();
//   final sheet = excel['ECP Wise Sales'];

//   // Header
//   sheet.appendRow([
//     TextCellValue('SL No'),
//     TextCellValue('Employee'),
//     TextCellValue('Customer'),
//     TextCellValue('Product'),
//     TextCellValue('Quantity'),
//     TextCellValue('Amount'),
//   ]);

//   allEcpWiseSalesReportData.sort((a, b) {
//     int cus = (a.customerName ?? "").compareTo(b.customerName ?? "");
//     if (cus != 0) return cus;
//     return (a.productName ?? "").compareTo(b.productName ?? "");
//   });

//   String currentCustomer = "";

//   int serial = 0;
//   double cusQty = 0;
//   double cusAmount = 0;

//   double grandQty = 0;
//   double grandAmount = 0;

//   for (int i = 0; i < allEcpWiseSalesReportData.length; i++) {
//     final data = allEcpWiseSalesReportData[i];

//     double qty = double.tryParse(data.quantity ?? "0") ?? 0;
//     double amount = double.tryParse(data.amount ?? "0") ?? 0;

//     // Customer Change
//     if (currentCustomer != (data.customerName ?? "")) {
//       if (currentCustomer.isNotEmpty) {
//         sheet.appendRow([
//           TextCellValue(''),
//           TextCellValue(''),
//           TextCellValue(''),
//           TextCellValue('Sub Total For ($currentCustomer)'),
//           DoubleCellValue(cusQty),
//           DoubleCellValue(cusAmount),
//         ]);
//       }

//       currentCustomer = data.customerName ?? "";

//       serial = 0;
//       cusQty = 0;
//       cusAmount = 0;
//     }

//     serial++;

//     // Normal Row
//     sheet.appendRow([
//       IntCellValue(serial),
//       TextCellValue(data.employeeName ?? ""),
//       TextCellValue(data.customerName ?? ""),
//       TextCellValue(data.productName ?? ""),
//       DoubleCellValue(qty),
//       DoubleCellValue(amount),
//     ]);

//     cusQty += qty;
//     cusAmount += amount;

//     grandQty += qty;
//     grandAmount += amount;
//   }

//   // Last Customer Sub Total
//   if (currentCustomer.isNotEmpty) {
//     sheet.appendRow([
//       TextCellValue(''),
//       TextCellValue(''),
//       TextCellValue(''),
//       TextCellValue('Sub Total For ($currentCustomer)'),
//       DoubleCellValue(cusQty),
//       DoubleCellValue(cusAmount),
//     ]);
//   }

//   // Grand Total
//   sheet.appendRow([
//     TextCellValue(''),
//     TextCellValue(''),
//     TextCellValue(''),
//     TextCellValue('Grand Total'),
//     DoubleCellValue(grandQty),
//     DoubleCellValue(grandAmount),
//   ]);

//   // Auto Width
//   for (int column = 0; column < 6; column++) {
//     sheet.setColumnWidth(column, 25);
//   }

//    final bytes = excel.encode();

//     if (bytes == null) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Excel generate failed")),
//       );
//       return;
//     }

//     // =========================
//     // ✅ UPDATED SAVE LOCATION (DOWNLOADS FOLDER)
//     // =========================
//     Directory directory;

//     if (Platform.isAndroid) {
//       directory = Directory('/storage/emulated/0/Download');

//       if (!await directory.exists()) {
//         await directory.create(recursive: true);
//       }
//     } else {
//       directory = await getApplicationDocumentsDirectory();
//     }

//     final filePath = "${directory.path}/ECP_Wise_Sales_${DateTime.now().millisecondsSinceEpoch}.xlsx";

//     final file = File(filePath);
//     await file.writeAsBytes(bytes, flush: true);

//     Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text("Excel Export Successful (Saved in Downloads)"),
//         backgroundColor: Colors.green,
//         action: SnackBarAction(
//           label: "OPEN",
//           textColor: Colors.white,
//           onPressed: () async {
//             await OpenFile.open(filePath);
//           },
//         ),
//       ),
//     );

//     await OpenFile.open(filePath);

//     print("Saved at: $filePath");
//   } catch (e) {
//     Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Export Error: $e")),
//     );

//     print("Export Error => $e");
//   }