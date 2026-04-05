import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widget/custom_appbar.dart';
import '../../../providers/administration_module_providers/categories_provider.dart';
import '../../../utils/all_textstyle.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  SharedPreferences? sharedPreferences;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    CategoriesProvider.isCategoriesListLoading = true;
    Provider.of<CategoriesProvider>(context, listen: false).getCategoriesList(context);
  }

  @override
  Widget build(BuildContext context) {
    final allCategoriesData = Provider.of<CategoriesProvider>(context).categoriesList
        .where((element) => element.productCategoryName.toLowerCase().contains(searchQuery.toLowerCase()) ||
        element.productCategoryDescription.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: CustomAppBar(title: "Category List"),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: SizedBox(
              height: 35.h,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, size: 18.r),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide(color: Colors.teal, width: 2.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide(color: Colors.teal.shade900, width: 2.w),
                  ),
                ),
              ),
            ),
          ),
          CategoriesProvider.isCategoriesListLoading
              ? Expanded(child: _buildShimmerEffect(allCategoriesData.length))
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 20.0.h,
                  dataRowHeight: 20.0.h,
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
                  border: TableBorder.all(color: Colors.blueGrey.shade100, width: 1.w),
                  columns: [
                    DataColumn(label: Center(child: Text('SI.', style: AllTextStyle.tableHeadTextStyle))),
                    DataColumn(label: Center(child: Text('Category Name', style: AllTextStyle.tableHeadTextStyle))),
                    DataColumn(label: Align(alignment: Alignment.centerLeft, child: Text('Description', style: AllTextStyle.tableHeadTextStyle))),
                  ],
                  rows: List.generate(
                    allCategoriesData.length,
                        (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith((states) => index % 2 == 0 ? Colors.teal.shade100 : Colors.white),
                      cells: <DataCell>[
                        DataCell(Center(child: Text("${index + 1}"))),
                        DataCell(Center(child: Text(allCategoriesData[index].productCategoryName))),
                        DataCell(Align(alignment: Alignment.centerLeft, child: Text(allCategoriesData[index].productCategoryDescription))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildShimmerEffect(int length) {
    return ListView.builder(
      itemCount: length+1,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
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
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../common_widget/custom_appbar.dart';
// import '../../../providers/administration_module_providers/categories_provider.dart';
// import '../../../providers/administration_module_providers/products_list_provider.dart';
// import '../../../utils/all_textstyle.dart';
//
// class CategoryListScreen extends StatefulWidget {
//   const CategoryListScreen({super.key});
//
//   @override
//   State<CategoryListScreen> createState() => _CategoryListScreenState();
// }
//
// class _CategoryListScreenState extends State<CategoryListScreen> {
//   SharedPreferences? sharedPreferences;
//   String searchQuery = "";
//   Color getColor(Set<WidgetState> states) {return Colors.teal.shade100;}
//   Color getColors(Set<WidgetState> states) {return Colors.white;}
//
//   @override
//   void initState() {
//     super.initState();
//     CategoriesProvider.isCategoriesListLoading = true;
//     Provider.of<CategoriesProvider>(context, listen: false).getCategoriesList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final allCategoriesData = Provider.of<CategoriesProvider>(context).categoriesList
//         .where((element) => element.productCategoryName.toLowerCase().contains(searchQuery.toLowerCase()) ||
//         element.productCategoryDescription.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//
//     return Scaffold(
//       appBar: CustomAppBar(title: "Category List"),
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
//           CategoriesProvider.isCategoriesListLoading == true
//               ? Padding(
//             padding: EdgeInsets.symmetric(vertical: 20.h),
//             child: Center(child: CircularProgressIndicator()),
//           )
//               : Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   padding: EdgeInsets.all(10.r),
//                   child: DataTable(
//                    // columnSpacing: 25.w,
//                     headingRowHeight: 20.0.h,
//                     dataRowHeight: 20.0.h,
//                     headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
//                     showCheckboxColumn: true,
//                     border: TableBorder.all(color: Colors.blueGrey.shade100, width: 1.w),
//                     columns: [
//                       DataColumn(label: Expanded(child: Center(child: Text('SI.', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Center(child: Text('Category Name', style: AllTextStyle.tableHeadTextStyle)))),
//                       DataColumn(label: Expanded(child: Align(alignment: Alignment.centerLeft,child: Text('Description', style: AllTextStyle.tableHeadTextStyle)))),
//                     ],
//                     rows: List.generate(
//                       allCategoriesData.length,
//                           (int index) => DataRow(
//                         color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
//                         cells: <DataCell>[
//                           DataCell(Center(child: Text("${index + 1}"))),
//                           DataCell(Center(child: Text(allCategoriesData[index].productCategoryName))),
//                           DataCell(Align(alignment: Alignment.centerLeft, child: Text(allCategoriesData[index].productCategoryDescription))),
//                         ],
//                       ),
//                     ),
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