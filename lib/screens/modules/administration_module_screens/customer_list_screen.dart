import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widget/custom_appbar.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../utils/all_textstyle.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  Color getColor(Set<MaterialState> states) {
    return Colors.blue.shade100;
  }
  Color getColors(Set<MaterialState> states) {
    return Colors.white;
  }
  Color getColorsRecieved(Set<MaterialState> states) {
    return Colors.purple.shade100;
  }
  Color getColorDealer(Set<MaterialState> states) {
    return Colors.blueGrey.shade200;
  }
  Color getColorsPaid(Set<MaterialState> states) {
    return Colors.teal.shade100;
  }
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userType = "${sharedPreferences?.getString('userType')}";
    userEmployee = "${sharedPreferences?.getString('employeeId')}";
    print("profile hoome userType====  $userType");
    print("userEmployee====  $userEmployee");
  }
  String? userType = "";
  String? userEmployee = "";
  bool isAllTypeClicked = true;
  bool isRetailListClicked = false;
  bool isWholesaleListClicked = false;
  bool isDealerListClicked = false;
  String? _searchType = "All";
  String data = "all";
  final List<String> _searchTypeList = [
    'All',
    'Retail',
    'Wholesale',
    'Dealer',
  ];

  void _customerListDropdown(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      button.localToGlobal(Offset.zero, ancestor: overlay).dx + button.size.width,
      button.localToGlobal(Offset.zero, ancestor: overlay).dy + 160.h,
      overlay.size.width - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dx,
      overlay.size.height - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dy,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.teal.shade900,
      items: _searchTypeList.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        return PopupMenuItem<String>(
          value: type,
          height: 22.0.h,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0.w),
                child: Text(type, style: AllTextStyle.saveButtonTextStyle),
              ),
              if (index != _searchTypeList.length - 1)
                Divider(height: 1.h, thickness: 0.8.h, color: Colors.grey.shade400),
            ],
          ),
        );
      }).toList(),
    );

    if (selectedValue != null) {
      setState(() {
        _searchType = selectedValue;
        _searchType == "All"
            ? isAllTypeClicked = true
            : isAllTypeClicked = false;
        _searchType == "Retail"
            ? isRetailListClicked = true
            : isRetailListClicked = false;
        _searchType == "Wholesale"
            ? isWholesaleListClicked = true
            : isWholesaleListClicked = false;
        _searchType == "Dealer"
            ? isDealerListClicked = true
            : isDealerListClicked = false;
      });
    }
  }

  @override
  void initState() {
    _initializeData();
    // TODO: implement initState
    super.initState();
    Provider.of<CustomerListProvider>(context, listen: false).customerList = [];
  }

  @override
  Widget build(BuildContext context) {
    final allCustomersData= Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo!=0).toList();
    // final allEmployeeWiseCustomerData = Provider.of<EmployeeWiseCustomerListProvider>(context).employeeWiseCustomerList.where((element) => element.customerName!=null).toList();
    // print("allCustomerTypeData====${allCustomerTypeData.length}");
    // final allEmployeeData= Provider.of<AllEmployeeProvider>(context).employeeList;
    // final allAreaData = Provider.of<DistrictProvider>(context, listen: false).allDistrictList;
    return Scaffold(
        appBar: CustomAppBar(title: "Customer List"),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 8.0.h),
              child: Container(
                padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w,bottom: 4.0.h),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(10.0.r),
                  border: Border.all(color: Colors.teal.shade900, width: 1.0.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 4, child: Text("Search Type",style:AllTextStyle.textFieldHeadStyle)),
                        Expanded(flex: 1, child: Text(":",style:AllTextStyle.textFieldHeadStyle)),
                        Expanded(
                          flex: 11,
                          child: GestureDetector(
                            onTap: () => _customerListDropdown(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              margin: EdgeInsets.only(top:4.h,bottom: 3.h),
                              height: 25.0.h,
                              decoration: ContDecoration.contDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_searchType ?? 'Please select a type',style: TextStyle(fontSize: 13.sp)),
                                  Icon(Icons.arrow_drop_down,color: Colors.grey.shade700),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          padding: EdgeInsets.all(1.0.r),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _searchType == "All" ? data = 'all':
                                _searchType == "Retail" ? data = 'retail':
                                _searchType == "Wholesale" ? data = 'wholesale' :
                                _searchType == "Dealer" ? data = 'dealer' : data = '';
                              });
                              if(data == 'all') {
                                setState(() {
                                  CustomerListProvider().on();
                                });
                                Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"");
                              }else if(data == 'retail'){
                                setState(() {
                                  CustomerListProvider().on();
                                });
                                Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"retail");
                              }else if(data == 'wholesale'){
                                setState(() {
                                  CustomerListProvider().on();
                                });
                                Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"wholesale");
                              }
                              else if(data == 'dealer'){
                                setState(() {
                                  CustomerListProvider().on();
                                });
                                Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"dealer");
                              }
                            },
                            child: Container(
                                height: 28.0.h,
                                width: 110.0.w,
                                decoration: BoxDecoration(color:Colors.blue.shade900,borderRadius: BorderRadius.circular(5.0.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child:Center(child: Text("Show Report",style:AllTextStyle.saveButtonTextStyle))),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(data == "all")
              CustomerListProvider.isCustomerListloading == true
                  ? Expanded(child: _buildShimmerEffect(allCustomersData.length)) : allCustomersData.isNotEmpty ? Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DataTable(
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900), showCheckboxColumn: true,
                        border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                        columns: [
                          DataColumn(label:Expanded(child:Center(child:Text('SI.',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Address',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Contact No',style:AllTextStyle.tableHeadTextStyle)))),
                        ],
                        rows: List.generate(
                          allCustomersData.length,
                              (int index) => DataRow(
                            color: index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorsPaid):MaterialStateProperty.resolveWith(getColors),
                            cells: <DataCell>[
                              DataCell(Center(child:Text("${index + 1}"))),
                              DataCell(Center(child:Text("${allCustomersData[index].customerCode}"))),
                              DataCell(SizedBox(width:MediaQuery.of(context).size.width/1.5,child:Center(child:Text("${allCustomersData[index].customerName}")))),
                              DataCell(SizedBox(width:MediaQuery.of(context).size.width/1,child:Center(child:Text("${allCustomersData[index].customerAddress}")))),
                              DataCell(Center(child:Text("${allCustomersData[index].customerMobile}"))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ):Center(child: Padding(padding: const EdgeInsets.all(10),child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle)))
            else if(data == 'retail')
              CustomerListProvider.isCustomerListloading == true
                  ? Expanded(child: _buildShimmerEffect(allCustomersData.length)) : allCustomersData.isNotEmpty ? Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DataTable(
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade900), showCheckboxColumn: true,
                        border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                        columns: [
                          DataColumn(label:Expanded(child:Center(child:Text('SI.',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Address',style:AllTextStyle.tableHeadTextStyle)))),
                          DataColumn(label:Expanded(child:Center(child:Text('Contact No',style:AllTextStyle.tableHeadTextStyle)))),
                        ],
                        rows: List.generate(
                          allCustomersData.length,
                              (int index) => DataRow(
                            color: index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
                            cells: <DataCell>[
                              DataCell(Center(child:Text("${index + 1}"))),
                              DataCell(Center(child:Text("${allCustomersData[index].customerCode}"))),
                              DataCell(SizedBox(width:MediaQuery.of(context).size.width/1.5,child:Center(child:Text("${allCustomersData[index].customerName}")))),
                              DataCell(SizedBox(width:MediaQuery.of(context).size.width/1,child:Center(child:Text("${allCustomersData[index].customerAddress}")))),
                              DataCell(Center(child:Text("${allCustomersData[index].customerMobile}"))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ):Center(child: Padding(padding: const EdgeInsets.all(10),child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle)))
            else if(data == 'wholesale')
                CustomerListProvider.isCustomerListloading == true
                    ? Expanded(child: _buildShimmerEffect(allCustomersData.length)) : allCustomersData.isNotEmpty ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: DataTable(
                          headingRowHeight: 20.0,
                          dataRowHeight: 20.0,
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.purple.shade900), showCheckboxColumn: true,
                          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                          columns: [
                            DataColumn(label:Expanded(child:Center(child:Text('SI.',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label:Expanded(child:Center(child:Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label:Expanded(child:Center(child:Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label:Expanded(child:Center(child:Text('Address',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label:Expanded(child:Center(child:Text('Contact No',style:AllTextStyle.tableHeadTextStyle)))),
                          ],
                          rows: List.generate(
                            allCustomersData.length,
                                (int index) => DataRow(
                              color: index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorsRecieved):MaterialStateProperty.resolveWith(getColors),
                              cells: <DataCell>[
                                DataCell(Center(child:Text("${index + 1}"))),
                                DataCell(Center(child:Text("${allCustomersData[index].customerCode}"))),
                                DataCell(SizedBox(width:MediaQuery.of(context).size.width/1.5,child:Center(child:Text("${allCustomersData[index].customerName}")))),
                                DataCell(SizedBox(width:MediaQuery.of(context).size.width/1,child:Center(child:Text("${allCustomersData[index].customerAddress}")))),
                                DataCell(Center(child:Text("${allCustomersData[index].customerMobile}"))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):Center(child: Padding(padding: const EdgeInsets.all(10),child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle)))
              else if(data == 'dealer')
                  CustomerListProvider.isCustomerListloading == true ?
                 Expanded(child: _buildShimmerEffect(allCustomersData.length,)) : allCustomersData.isNotEmpty ? Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade800), showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                            columns: [
                              DataColumn(label:Expanded(child:Center(child:Text('SI.',style:AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label:Expanded(child:Center(child:Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label:Expanded(child:Center(child:Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label:Expanded(child:Center(child:Text('Address',style:AllTextStyle.tableHeadTextStyle)))),
                              DataColumn(label:Expanded(child:Center(child:Text('Contact No',style:AllTextStyle.tableHeadTextStyle)))),
                            ],
                            rows: List.generate(
                              allCustomersData.length,
                                  (int index) => DataRow(
                                color: index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorDealer):MaterialStateProperty.resolveWith(getColors),
                                cells: <DataCell>[
                                  DataCell(Center(child:Text("${index + 1}"))),
                                  DataCell(Center(child:Text("${allCustomersData[index].customerCode}"))),
                                  DataCell(SizedBox(width:MediaQuery.of(context).size.width/1.5,child:Center(child:Text("${allCustomersData[index].customerName}")))),
                                  DataCell(SizedBox(width:MediaQuery.of(context).size.width/1,child:Center(child:Text("${allCustomersData[index].customerAddress}")))),
                                  DataCell(Center(child:Text("${allCustomersData[index].customerMobile}"))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ):Center(child: Padding(padding: const EdgeInsets.all(10),child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle)))
          ],
        ));
  }
  Widget _buildShimmerEffect(int length) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        itemCount: length+1,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 15.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}