import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Color getColor(Set<WidgetState> states) {return Colors.teal.shade100;}
  Color getColors(Set<WidgetState> states) {return Colors.white;}

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
    _initLocation();
    super.initState();
    ProductListProvider.isProductsListLoading = true;
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context);
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
          Padding(
            padding: EdgeInsets.only(top: 10.0.h,left: 10.0.w,right: 10.0.w),
            child: SizedBox(
              height: 35.0.h,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical:8.0.h),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search,size: 18.0.r),
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
          ProductListProvider.isProductsListLoading == true
              ? Expanded(child: _buildShimmerEffect(allProductData.length)) : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.all(10.r),
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
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productDarNo??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productHsCode ??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productGsCode??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productLotNo??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productDutyPercent??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productOtherCost??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productManufactureDate??""))),
                          DataCell(Align(alignment: Alignment.centerRight, child: Text(allProductData[index].productExpireDate??""))),
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
