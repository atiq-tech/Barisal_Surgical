import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/sales_module_providers/total_stock_provider.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});
  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  Color getColor(Set<WidgetState> states) => Colors.teal.shade100;
  Color getColors(Set<WidgetState> states) => Colors.white;
  double? totalQty;
  double? totalStock;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
      TotalStockProvider.isTotalStockLoading = true;
      Provider.of<TotalStockProvider>(context, listen: false).getTotalStock(context);
  }
  @override
  Widget build(BuildContext context) {
    final totalStockProvider = Provider.of<TotalStockProvider>(context);
    final allTotalStockData = totalStockProvider.totalStockList.where((element) =>
    (element.productName ?? "").toLowerCase().contains(searchQuery.toLowerCase()) ||
        (element.productCode ?? "").toLowerCase().contains(searchQuery.toLowerCase())).toList();

    totalQty = allTotalStockData.fold(0.0, (prev, element) => prev! + double.parse(element.currentQuantity!));
    totalStock = allTotalStockData.fold(0.0, (prev, element) => prev! + double.parse(element.stockValue!));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appColor,
        title: const Text("Stock List",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
            );
          },
        ),
      ),
      body: Column(
        children: [
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
          TotalStockProvider.isTotalStockLoading ? Expanded(child: _buildShimmerEffect(allTotalStockData.length))
         : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        columnSpacing: 10,
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
                        showCheckboxColumn: false,
                        border: TableBorder.all(color: Colors.grey.shade400, width: 1.w),
                        columns: [
                          DataColumn(label: Expanded(child: Center(child: Text('SL.', style: AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label: Expanded(child: Center(child: Text('Current Stock', style: AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label: Expanded(child: Center(child: Text('Stock Value', style: AllTextStyle.tableHeadTextStyle)))),
                        ],
                        rows: [
                          ...List.generate(
                            allTotalStockData.length,
                              (int index) => DataRow(
                              color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
                              cells: <DataCell>[
                                DataCell(Center(child: Text("${index+1}"))),
                                DataCell(Center(child: Text(allTotalStockData[index].productCode.toString()))),
                                DataCell(Align(alignment: Alignment.centerLeft,child: Text(allTotalStockData[index].productName ?? ""))),
                                DataCell(Center(child: Text("${allTotalStockData[index].quantityText}"))),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text(double.parse(allTotalStockData[index].stockValue ?? "0").toStringAsFixed(2)))),
                              ],
                            ),
                          ),
                          // Footer row
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(SizedBox()),
                              const DataCell(SizedBox()),
                              const DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)))),
                              DataCell(Center(child: Text(totalQty!.toStringAsFixed(2),style: const TextStyle(fontWeight: FontWeight.bold)))),
                              DataCell(Align(alignment: Alignment.center, child: Text(totalStock!.toStringAsFixed(2),style: const TextStyle(fontWeight: FontWeight.bold)))),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 100.h)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildShimmerEffect(int length) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.w),
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


/// before simmer
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../../common_widget/custom_appbar.dart';
// import '../../../providers/sales_module_providers/total_stock_provider.dart';
// import '../../../utils/all_textstyle.dart';
//
// class StockListScreen extends StatefulWidget {
//   const StockListScreen({super.key});
//
//   @override
//   State<StockListScreen> createState() => _StockListScreenState();
// }
//
// class _StockListScreenState extends State<StockListScreen> {
//   Color getColor(Set<WidgetState> states) => Colors.teal.shade100;
//   Color getColors(Set<WidgetState> states) => Colors.white;
//
//   double? totalQty;
//   double? totalStock;
//   String searchQuery = "";
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TotalStockProvider>(context, listen: false).getTotalStock();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final totalStockProvider = Provider.of<TotalStockProvider>(context);
//
//     final allTotalStockData = totalStockProvider.totalStockList
//         .where((element) =>
//     (element.productName ?? "").toLowerCase().contains(searchQuery.toLowerCase()) ||
//         (element.productCode ?? "").toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//     // final allTotalStockData = totalStockProvider.totalStockList
//     //     .where((element) =>
//     // (element.productName ?? "").toLowerCase().contains(searchQuery.toLowerCase()) ||
//     //     (element.productCode ?? "").toLowerCase().contains(searchQuery.toLowerCase()))
//     //     .where((element) => double.tryParse(element.stockValue ?? "0") != 0)
//     //     .toList();
//     totalQty = allTotalStockData.fold(0.0, (prev, element) => prev! + double.parse(element.currentQuantity!));
//     totalStock = allTotalStockData.fold(0.0, (prev, element) => prev! + double.parse(element.stockValue!));
//     return Scaffold(
//       appBar: CustomAppBar(title: "Stock List"),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 10.0.w),
//             child: SizedBox(
//               height: 35.0.h,
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(vertical: 8.0.h),
//                   hintText: 'Search',
//                   prefixIcon: Icon(Icons.search, size: 18.0.r),
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
//           allTotalStockData.isNotEmpty?
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   padding: EdgeInsets.all(10.r),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       DataTable(
//                         columnSpacing: 10,
//                         headingRowHeight: 20.0,
//                         dataRowHeight: 20.0,
//                         headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
//                         showCheckboxColumn: false,
//                         border: TableBorder.all(color: Colors.grey.shade400, width: 1.w),
//                         columns: [
//                           DataColumn(label: Expanded(child: Center(child: Text('SL.', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Current Stock', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Stock Value', style: AllTextStyle.tableHeadTextStyle)))),
//                         ],
//                         rows: [
//                           ...List.generate(
//                             allTotalStockData.length,
//                               (int index) => DataRow(
//                               color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
//                               cells: <DataCell>[
//                                 DataCell(Center(child: Text("${index+1}"))),
//                                 DataCell(Center(child: Text(allTotalStockData[index].productCode.toString() ?? ""))),
//                                 DataCell(Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(allTotalStockData[index].productName ?? ""))),
//                                 DataCell(Center(
//                                     child: Text(
//                                         "${allTotalStockData[index].quantityText}"))),
//                                 DataCell(Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Text(double.parse(allTotalStockData[index].stockValue ?? "0")
//                                         .toStringAsFixed(2)))),
//                               ],
//                             ),
//                           ),
//                           // Footer row
//                           DataRow(
//                             cells: <DataCell>[
//                               const DataCell(SizedBox()),
//                               const DataCell(SizedBox()),
//                               const DataCell(Align(alignment: Alignment.centerRight,
//                               child: Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)))),
//                               DataCell(Center(
//                                   child: Text(totalQty!.toStringAsFixed(2),
//                                       style: const TextStyle(fontWeight: FontWeight.bold)))),
//                               DataCell(Align(alignment: Alignment.center,
//                                 child: Text(totalStock!.toStringAsFixed(2),
//                                     style: const TextStyle(fontWeight: FontWeight.bold)))),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//               :const CircularProgressIndicator(color: Colors.indigo),
//         ],
//       ),
//     );
//   }
// }




///====main code
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../common_widget/custom_appbar.dart';
// import '../provider/all_current_stock_provider.dart';
// import '../provider/total_stock_provider.dart';
// import '../utils/all_textstyle.dart';
//
// class StockListScreen extends StatefulWidget {
//   const StockListScreen({super.key});
//
//   @override
//   State<StockListScreen> createState() => _StockListScreenState();
// }
//
// class _StockListScreenState extends State<StockListScreen> {
//   Color getColor(Set<WidgetState> states) {return Colors.green.shade100;}
//   Color getColors(Set<WidgetState> states) {return Colors.white;}
//   double? totalQty;
//   double? totalStock;
//   String searchQuery = "";
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Provider.of<CurrentStockProvider>(context, listen: false).getCurrentStock(context,"");
//       Provider.of<AllCurrentStockProvider>(context, listen: false).getAllCurrentStock();
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // final currentStockProvider = Provider.of<CurrentStockProvider>(context);
//     //
//     //
//     // final allCurrentStockData = currentStockProvider.currentStockList
//     //     .where((element) =>
//     // element.productName!.toLowerCase().contains(searchQuery.toLowerCase()) ||
//     //     element.productCode!.toLowerCase().contains(searchQuery.toLowerCase()))
//     //     .where((element) => element.stockValue != "0")
//     //     .toList();
//     //
//     // // মোট পরিমাণ ও স্টক গণনা
//     // totalQty = allCurrentStockData.fold(0.0, (prev, element) => prev! + double.parse(element.currentQuantity!));
//     // totalStock = allCurrentStockData.fold(0.0, (prev, element) => prev! + double.parse(element.stockValue!));
//     final currentStockProvider = Provider.of<AllCurrentStockProvider>(context);
//
//
//     final allCurrentStockData = currentStockProvider.allCurrentStockList
//         .where((element) =>
//     element.productName!.toLowerCase().contains(searchQuery.toLowerCase()) ||
//         element.productCode!.toLowerCase().contains(searchQuery.toLowerCase()))
//         .where((element) => element.stockValue != "0.0")
//         .toList();
//
//     totalQty = allCurrentStockData.fold(0.0, (prev, element) => prev! + double.parse(element.currentQuantity!));
//     totalStock = allCurrentStockData.fold(0.0, (prev, element) => prev! + double.parse(element.stockValue!));
//
//     return Scaffold(
//       appBar: CustomAppBar(title: "Stock List"),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0,bottom: 5.0),
//             child: SizedBox(
//               height: 40.0,
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.symmetric(vertical:8.0),
//                   hintText: 'Search',
//                   prefixIcon: const Icon(Icons.search,size: 18.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           AllCurrentStockProvider.isAAllCurrentStockLoading ? Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Center(child: CircularProgressIndicator(color: Colors.green.shade500)),
//           )
//               : Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       DataTable(
//                         columnSpacing: 10,
//                         headingRowHeight: 20.0,
//                         dataRowHeight: 20.0,
//                         headingRowColor: WidgetStateColor.resolveWith((states) => Colors.green.shade900),
//                         showCheckboxColumn: false,
//                         border: TableBorder.all(color: Colors.grey.shade400, width: 1),
//                         columns: const [
//                           DataColumn(label: Expanded(child: Center(child: Text('SL.', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Product Id', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Product Name', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Current Quantity', style: AllTextStyle.tableHeadTextStyle)))),
//                           DataColumn(label: Expanded(child: Center(child: Text('Current Stock', style: AllTextStyle.tableHeadTextStyle)))),
//                         ],
//                         rows: [
//                           ...List.generate(
//                             allCurrentStockData.length,
//                                 (int index) => DataRow(
//                               color: index % 2 == 0
//                                   ? WidgetStateProperty.resolveWith(getColor)
//                                   : WidgetStateProperty.resolveWith(getColors),
//                               cells: <DataCell>[
//                                 DataCell(Center(child: Text("${index + 1}"))),
//                                 DataCell(Center(child: Text(allCurrentStockData[index].productCode.toString() ??""))),
//                                 DataCell(Align(alignment: Alignment.centerLeft, child: Text(currentStockProvider.allCurrentStockList[index].productName ??""))),
//                                 DataCell(Center(child: Text("${allCurrentStockData[index].currentQuantity} ${currentStockProvider.allCurrentStockList[index].unitName ??""}"))),
//                                 DataCell(Align(alignment: Alignment.centerRight, child: Text(double.parse(currentStockProvider.allCurrentStockList[index].stockValue ??"").toStringAsFixed(2)))),
//                               ],
//                             ),
//
//                           ),
//                           // Footer row
//                           DataRow(
//                             cells: <DataCell>[
//                               const DataCell(SizedBox()),
//                               const DataCell(SizedBox()),
//                               const DataCell(Align(alignment: Alignment.centerRight,child: Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)))),
//                               DataCell(Center(child: Text(totalQty!.toStringAsFixed(2),style: const TextStyle(fontWeight: FontWeight.bold)))),
//                               DataCell(Align(alignment: Alignment.centerRight,
//                                 child: Text(totalStock!.toStringAsFixed(2),style: const TextStyle(fontWeight: FontWeight.bold)),
//                               )),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }