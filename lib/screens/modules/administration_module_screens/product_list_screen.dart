import 'dart:io';
import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widget/custom_appbar.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../utils/all_textstyle.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  SharedPreferences? sharedPreferences;
  String searchQuery = "";
  
  Color getColor(Set<WidgetState> states) { return Colors.teal.shade100; }
  Color getColors(Set<WidgetState> states) { return Colors.white; }

   String companyName = "";
  String repotHeading = "";
  String dueStatus = "";
  String invoiceNote = "";
  String headerImg = "";
  String footerImg = "";

   void getCompanyProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get(
        "${baseUrl}get_company_profile",
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );

      if (response.statusCode == 200) {
        var data = response.data is List ? response.data[0] : response.data;

        setState(() {
          companyName = data['Company_Name'] ?? "";
          repotHeading = data['Repot_Heading'] ?? "";
          dueStatus = data['dueStatus'] ?? "";
          invoiceNote = data['InvoiceNote'] ?? "";
        });

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_company_profile-------Company_Name======$companyName");
    print("get_company_profile-------Company_Name======$repotHeading");
    print("get_company_profile-------dueStatus======$dueStatus");
    print("get_company_profile-------invoiceNote======$invoiceNote");
  }

  void getCurrentBranch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get(
        "${baseUrl}get_current_branch",
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );

      if (response.statusCode == 200) {
        var data = response.data is List ? response.data[0] : response.data;

        setState(() {
          headerImg = data['Branch_header'] ?? "";
          footerImg = data['Branch_footer'] ?? "";
        });

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_current_branch-------Branch_header======$headerImg");
    print("get_current_branch-------Branch_footer======$footerImg");
  }


  String myAddress = "Loading...";
  double? myLat, myLong;

  Future<void> _initLocation() async {
    var result = await LocationService.fetchAndUploadLocation();
    if (result != null) {
      setState(() {
        myLat = result['lat'];
        myLong = result['long'];
        myAddress = result['address'];
      });
    }
  }

  @override
  void initState() {
    getCompanyProfile();
    getCurrentBranch();
    _initLocation();
    super.initState();
    ProductListProvider.isProductsListLoading = true;
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context, "");
  }

   // ইমেজ ফেচ করার জন্য উন্নত ফাংশন
Future<Uint8List?> _fetchImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Image Load Failed: Status ${response.statusCode}');
      return null; 
    }
  } catch (e) {
    print('Error fetching image: $e');
    return null;
  }
}

  // --- Actual PDF Print Function (Fully Fixed) ---
  Future<void> _printProductList(List allProductData) async {
    final pdf = pw.Document();
    String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());
    // Load Unicode compatible font from Google Fonts to avoid Helvetica errors
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
      // ইমেজগুলো ফেচ করা
    final Uint8List? netHeader = await _fetchImage("$imageBaseUrl$headerImg");
    //final Uint8List? netFooter = await _fetchImage("$imageBaseUrl$footerImg");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(3),
        build: (pw.Context context) {
          return [
            pw.Text(currentDateTime, style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
            if (netHeader != null) 
            pw.Center(child: pw.Image(pw.MemoryImage(netHeader), height: 80, width: 500)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['SI.', 'Product Id', 'Product Name', 'Category', 'Sale Price', 'Size', 'DAR No', 'HS Code', 'Lot No', 'Expire Date'],
              data: List.generate(allProductData.length, (index) {
                final item = allProductData[index];
                return [
                  '${index + 1}',
                  item.productCode ?? '',
                  item.productName ?? '',
                  item.productCategoryName ?? '',
                  item.productSellingPrice ?? '',
                  item.productSize ?? '',
                  item.productDarNo ?? '',
                  item.productHsCode ?? '',
                  item.productLotNo ?? '',
                  item.productExpireDate ?? '',
                ];
              }),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, font: fontBold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.teal900),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
              cellStyle: pw.TextStyle(fontSize: 9, font: font),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }


 // --- Actual Excel Download Function (Updated) ---
  Future<void> _downloadExcel(List allProductData) async {
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
      final excel = ex.Excel.createExcel();
      final sheet = excel['Product List'];
      excel.setDefaultSheet('Product List');

      // HEADER ROW
      sheet.appendRow([
        ex.TextCellValue('Sl.'),
        ex.TextCellValue('Product Id'),
        ex.TextCellValue('Product Name'),
        ex.TextCellValue('Category'),
        ex.TextCellValue('Sale Price'),
        ex.TextCellValue('Size'),
        ex.TextCellValue('DAR No'),
        ex.TextCellValue('HS Code'),
        ex.TextCellValue('GS Code'),
        ex.TextCellValue('Lot No'),
        ex.TextCellValue('Duty %'),
        ex.TextCellValue('Others Cost'),
        ex.TextCellValue('Manufacture Date'),
        ex.TextCellValue('Expire Date'),
      ]);

      // DATA ROWS
      for (int i = 0; i < allProductData.length; i++) {
        final item = allProductData[i];

        sheet.appendRow([
          ex.IntCellValue(i + 1),
          ex.TextCellValue(item.productCode ?? ''),
          ex.TextCellValue(item.productName ?? ''),
          ex.TextCellValue(item.productCategoryName ?? ''),
          ex.DoubleCellValue(double.tryParse(item.productSellingPrice.toString()) ?? 0.0),
          ex.TextCellValue(item.productSize ?? ''),
          ex.TextCellValue(item.productDarNo ?? ''),
          ex.TextCellValue(item.productHsCode ?? ''),
          ex.TextCellValue(item.productGsCode ?? ''),
          ex.TextCellValue(item.productLotNo ?? ''),
          ex.DoubleCellValue(double.tryParse(item.productDutyPercent.toString()) ?? 0.0),
          ex.DoubleCellValue(double.tryParse(item.productOtherCost.toString()) ?? 0.0),
          ex.TextCellValue(item.productManufactureDate ?? ''),
          ex.TextCellValue(item.productExpireDate ?? ''),
        ]);
      }

      final bytes = excel.encode();

      if (bytes == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Excel generate failed")),
        );
        return;
      }

      // SAVE LOCATION (DOWNLOADS FOLDER)
      Directory directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = "${directory.path}/Product_List_${DateTime.now().millisecondsSinceEpoch}.xlsx";

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      Navigator.pop(context); // Close loading dialog

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
      Navigator.pop(context); // Close loading dialog if error occurs

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Export Error: $e")),
      );

      print("Export Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final allProductData = Provider.of<ProductListProvider>(context).productsList
        .where((element) => element.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
        element.productCode.toLowerCase().contains(searchQuery.toLowerCase()) ||
        element.productCategoryName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        
    return Scaffold(
      appBar: CustomAppBar(title: "Product List"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Search Field
          Padding(
            padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 10.0.w),
            child: SizedBox(
              height: 35.0.h,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0.h),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, size: 18.0.r),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide(color: Colors.teal, width: 2.0.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide(color: Colors.teal.shade900, width: 2.0.w),
                  ),
                ),
              ),
            ),
          ),

          // Action Buttons (Print & Excel)
          allProductData.isEmpty ? SizedBox(height: 0.w) :  Padding(
            padding: EdgeInsets.only(top: 5.0.h, left: 10.0.w, right: 5.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                      _printProductList(allProductData);
                  },
                  child: Card(
                    elevation: 5,
                    color: const Color.fromARGB(255, 47, 11, 92),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.0.h),
                      child: Row(
                        children: [
                          Icon(Icons.print, size: 16.0.r, color: Colors.white),
                          Text("Print",style: TextStyle(color: Colors.white, fontSize: 14.0.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                      _downloadExcel(allProductData);
                  },
                  child: Card(
                    elevation: 5,    
                    color: Colors.green.shade700,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.0.h),
                      child: Row(
                        children: [
                          Icon(Icons.download, size: 16.0.r, color: Colors.white),
                          Text("Excel",style: TextStyle(color: Colors.white, fontSize: 14.0.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          ProductListProvider.isProductsListLoading == true
              ? Expanded(child: _buildShimmerEffect(allProductData.length)) 
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(left: 10.r, right: 10.r, top: 5.r, bottom: 5.r),
                  child: DataTable(
                    columnSpacing: 25.w,
                    headingRowHeight: 20.0.h,
                    dataRowHeight: 20.0.h,
                    headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
                    showCheckboxColumn: true,
                    border: TableBorder.all(color: Colors.blueGrey.shade100, width: 2.w),
                    columns: [
                      DataColumn(label: Expanded(child: Center(child: Text('SI.', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('Category', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Sale Price', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Size', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('DAR No', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('HS Code', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('GS Code', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Lot No', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Duty %', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Others Cost', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Manufacture Date', style: AllTextStyle.tableHeadTextStyle)))),
                      DataColumn(label: Expanded(child: Center(child: Text('Expire Date', style: AllTextStyle.tableHeadTextStyle)))),
                    ],
                    rows: List.generate(
                      allProductData.length,
                      (int index) => DataRow(
                        color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
                        cells: <DataCell>[
                          DataCell(Center(child: Text("${index + 1}"))),
                          DataCell(Center(child: Text(allProductData[index].productCode))),
                          DataCell(Align(alignment: Alignment.centerLeft, child: Text(allProductData[index].productName))),
                          DataCell(Align(alignment: Alignment.centerLeft, child: Text(allProductData[index].productCategoryName))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productSellingPrice))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productSize))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productDarNo ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productHsCode ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productGsCode ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productLotNo ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productDutyPercent ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productOtherCost ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productManufactureDate ?? ""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productExpireDate ?? ""))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0.h),
        ],
      ),
    );
  }

    Widget _buildShimmerEffect(int length) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: ListView.builder(
        itemCount: length+1,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 15.h,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
          );
        },
      ),
    );
  }
}


































// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({super.key});

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   SharedPreferences? sharedPreferences;
//   String searchQuery = "";
//   Color getColor(Set<WidgetState> states) {return Colors.teal.shade100;}
//   Color getColors(Set<WidgetState> states) {return Colors.white;}

//   String myAddress = "Loading...";
//     double? myLat, myLong;
//     Future<void> _initLocation() async {
//     var result = await LocationService.fetchAndUploadLocation();
//     if (result != null) {
//       setState(() {
//         myLat = result['lat'];
//         myLong = result['long'];
//         myAddress = result['address'];
//       });
//     }
//   }

//   @override
//   void initState() {
//     _initLocation();
//     super.initState();
//     ProductListProvider.isProductsListLoading = true;
//     Provider.of<ProductListProvider>(context, listen: false).getProductList(context,"");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final allProductData = Provider.of<ProductListProvider>(context).productsList
//         .where((element) => element.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
//         element.productCode.toLowerCase().contains(searchQuery.toLowerCase()) ||
//         element.productCategoryName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//     return Scaffold(
//       appBar: CustomAppBar(title: "Product List"),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 10.0.h,left: 10.0.w,right: 10.0.w),
//             child: SizedBox(
//               height: 35.0.h,
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(vertical:8.0.h),
//                   hintText: 'Search',
//                   prefixIcon: Icon(Icons.search,size: 18.0.r),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(100.r),
//                     borderSide: BorderSide(color: Colors.teal, width: 2.0.w),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(100.r),
//                     borderSide: BorderSide(color: Colors.teal.shade900, width: 2.0.w),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           ProductListProvider.isProductsListLoading == true
//               ? Expanded(child: _buildShimmerEffect(allProductData.length)) : Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   padding: EdgeInsets.all(10.r),
//                   child: DataTable(
//                     columnSpacing: 25.w,
//                     headingRowHeight: 20.0.h,
//                     dataRowHeight: 20.0.h,
//                     headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
//                     showCheckboxColumn: true,
//                     border: TableBorder.all(color: Colors.blueGrey.shade100, width: 2.w),
//                     columns: [
//                       DataColumn(label: Expanded(child: Center(child: Text('SI.', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('Category', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Sale Price', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Size', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('DAR No', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('HS Code', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('GS Code', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Lot No', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Duty %', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Others Cost', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Manufacture Date', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Expire Date', style: AllTextStyle.tableHeadTextStyle)))),
//                     ],
//                     rows: List.generate(
//                       allProductData.length,
//                           (int index) => DataRow(
//                         color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
//                         cells: <DataCell>[
//                           DataCell(Center(child: Text("${index + 1}"))),
//                           DataCell(Center(child: Text(allProductData[index].productCode))),
//                           DataCell(Align(alignment: Alignment.centerLeft, child: Text(allProductData[index].productName))),
//                           DataCell(Align(alignment: Alignment.centerLeft, child: Text(allProductData[index].productCategoryName))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productSellingPrice))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productSize))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productDarNo??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productHsCode ??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productGsCode??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productLotNo??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productDutyPercent??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productOtherCost??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productManufactureDate??""))),
//                           DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productExpireDate??""))),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20.0.h),
//         ],
//       ),
//     );
//   }
//   Widget _buildShimmerEffect(int length) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.0.h),
//       child: ListView.builder(
//         itemCount: length+1,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//             child: Shimmer.fromColors(
//               baseColor: Colors.grey.shade300,
//               highlightColor: Colors.grey.shade100,
//               child: Container(
//                 height: 15.h,
//                 decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(2.r)),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
