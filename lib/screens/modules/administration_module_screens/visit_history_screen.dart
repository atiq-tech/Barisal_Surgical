import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../models/administration_module_models/product_list_model.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/utils.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  Color getColor(Set<WidgetState> states) {return Colors.blue.shade100;}
  Color getColors(Set<WidgetState> states) {return Colors.white;}
  Color getColorsbyAll(Set<WidgetState> states) {return Colors.blue.shade100;}

  String? firstPickedDate;
  var backEndFirstDate;
  var backEndSecondtDate;

  var toDay = DateTime.now();
  void _firstSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $firstPickedDate");
      });
    }
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $firstPickedDate");
      });
    }
  }

  String? secondPickedDate;
  void _secondSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndSecondtDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $secondPickedDate");
      });
    }else{
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondtDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $secondPickedDate");
      });
    }
  }
  String? employeeId = "";
  String? userEmployeeId = "";
  String userName = "";
  String userType = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
  }
  bool isCustomerListClicked = false;
  bool isEmployeeListClicked = false;
  String _searchType = 'All';
  String customerId = '';

  final List<String> _searchTypeList = [
    'All',
    'By Customer',
    'By Employee'
  ];
  String? _selectCustomerId;
  var data;

  @override
  void initState() {
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context);
    // Provider.of<EmployeeProvider>(context,listen: false).getEmployee();
    // Provider.of<VisitsProvider>(context, listen: false).visitslist=[];
    // ///Get customers
    // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("", "", "");
    // TODO: implement initState
    super.initState();
  }
  var customerController = TextEditingController();
  final _employeeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allEmployeeData = Provider.of<ProductListProvider>(context).productsList;
    // final allEmployeeData = Provider.of<EmployeeProvider>(context).allEmployeeList;
    ///Get customers
    // final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerCode != "").toList();
    // print("allCustomerData====${allCustomerData.length}");
    ///get Visits

    // final allGetVisitsData = Provider.of<VisitsProvider>(context).visitslist;
    // print("Get allGetVisitsData length=====> ${allGetVisitsData.length} ");
    return Scaffold(
      appBar: CustomAppBar(title: "Visit History"),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 8.0.h),
            child: Container(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w,bottom: 4.0.h),
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(10.0.r),
                border: Border.all(color: Colors.teal, width: 1.0.w),
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
                      Expanded(flex: 4,child: Text("Search Type :",style:AllTextStyle.textFieldHeadStyle)),
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          decoration: ContDecoration.contDecoration,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: _searchType,
                              onChanged: (newValue) {
                                setState(() {
                                  _searchType = newValue!;
                                  _selectCustomerId='';
                                  if (_searchType == "By Customer") {
                                    isCustomerListClicked = true;
                                    isEmployeeListClicked = false;
                                  }
                                  else if (_searchType == "By Employee") {
                                    isEmployeeListClicked = true;
                                    isCustomerListClicked = false;
                                  }
                                  else {
                                    customerController.text = '';
                                    _employeeController.text = '';
                                    isCustomerListClicked = false;
                                    isEmployeeListClicked = false;
                                  }
                                });
                              },
                              items: _searchTypeList.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location, style: TextStyle(fontSize: 13.sp)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isCustomerListClicked == true ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 4, child: Text("Customer     : ",style:AllTextStyle.textFieldHeadStyle)),
                          Expanded(
                            flex: 8,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5.w),
                              height: 25.0.h,
                              decoration: ContDecoration.contDecoration,
                              child: TypeAheadField<ProductListModel>(
                                controller: customerController,
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                      isDense: true,
                                      hintText: 'Select Customer',
                                      hintStyle: TextStyle(fontSize: 13.sp),
                                      suffixIcon: _selectCustomerId == '' || _selectCustomerId == 'null' || _selectCustomerId == null || controller.text == '' ? null
                                          : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            customerController.clear();
                                            controller.clear();
                                            _selectCustomerId = null;
                                          });
                                        },
                                        child: Padding(padding: EdgeInsets.all(5.r), child: Icon(Icons.close, size: 16.r)),
                                      ),
                                      suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                      enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) async {
                                  return Future.delayed(const Duration(seconds: 1), () {
                                    return allEmployeeData.where((element) =>
                                        element.displayText!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                  });
                                },
                                itemBuilder: (context, ProductListModel suggestion) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                    child: Text(suggestion.displayText!,
                                      style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                                onSelected: (ProductListModel suggestion) {
                                  setState(() {
                                    customerController.text = suggestion.displayText!;
                                    _selectCustomerId = suggestion.productSlNo.toString();
                                  });
                                },
                              ),
                              // child: TypeAheadFormField(
                              //   textFieldConfiguration:
                              //   TextFieldConfiguration(
                              //     onChanged: (value){
                              //       if (value == '') {
                              //         _selectedCustomer = '';
                              //       }
                              //     },
                              //     style: const TextStyle(fontSize: 13),
                              //     controller: customerController,
                              //     decoration: InputDecoration(
                              //         contentPadding: const EdgeInsets.only(bottom: 10,left: 5.0),
                              //         hintText: 'Select Customer',
                              //         suffixIcon: _selectedCustomer  == "null"
                              //             || _selectedCustomer  == ""
                              //             || customerController.text == ""
                              //             || _selectedCustomer == null ? null
                              //             : GestureDetector(
                              //           onTap: () {
                              //             setState(() {
                              //               customerController.text = '';
                              //             });
                              //           },
                              //           child: const Padding(
                              //             padding: EdgeInsets.only(left: 6,right: 6),
                              //             child: Icon(Icons.close,size: 16,),
                              //           ),
                              //         ),
                              //         suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                              //         filled: true,
                              //         fillColor: Colors.white,
                              //         border: InputBorder.none,
                              //         focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                              //         enabledBorder: TextFieldInputBorder.focusEnabledBorder
                              //     ),
                              //   ),
                              //   suggestionsCallback: (pattern) {
                              //     return allCustomerData
                              //         .where((element) => element.customerName!
                              //         .toLowerCase()
                              //         .contains(pattern
                              //         .toString()
                              //         .toLowerCase()))
                              //         .take(allCustomerData.length)
                              //         .toList();
                              //   },
                              //   itemBuilder: (context, suggestion) {
                              //     return SizedBox(
                              //       child: Padding(
                              //         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              //         child: Text("${suggestion.customerName} ${suggestion.customerCode != "" ? " - ${suggestion.customerCode}" : ""} ${suggestion.customerMobile != "" ? " - ${suggestion.customerMobile}" : ""}",
                              //           style: const TextStyle(fontSize: 12),
                              //           maxLines: 1,overflow: TextOverflow.ellipsis,),
                              //       ),
                              //     );
                              //   },
                              //   transitionBuilder: (context, suggestionsBox, controller) {
                              //     return suggestionsBox;
                              //   },
                              //   onSuggestionSelected: (CustomerListModel suggestion) {
                              //     setState(() {
                              //       customerController.text = "${suggestion.customerName} ${suggestion.customerCode != "" ? " - ${suggestion.customerCode}" : ""} ${suggestion.customerMobile != "" ? " - ${suggestion.customerMobile}" : ""}";
                              //       _selectedCustomer = suggestion.customerSlNo.toString();
                              //     });
                              //   },
                              //   onSaved: (value) {},
                              // ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                      : Container(),
                  isEmployeeListClicked == true ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 4, child: Text("Employee     : ",style:AllTextStyle.textFieldHeadStyle)),
                          userName == "Admin"? Expanded(
                            flex: 8,
                            child: Container(
                              height: 25.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              margin: EdgeInsets.only(bottom: 5.0.h),
                              decoration: ContDecoration.contDecoration,
                              child: TypeAheadField<ProductListModel>(
                                controller: _employeeController,
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                      isDense: true,
                                      hintText: 'Select Employee',
                                      hintStyle: TextStyle(fontSize: 13.sp),
                                      suffixIcon: employeeId == '' || employeeId == 'null' || employeeId == null || controller.text == '' ? null
                                          : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _employeeController.clear();
                                            controller.clear();
                                            employeeId = null;
                                          });
                                        },
                                        child: Padding(padding: EdgeInsets.all(5.r), child: Icon(Icons.close, size: 16.r)),
                                      ),
                                      suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                      enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) async {
                                  return Future.delayed(const Duration(seconds: 1), () {
                                    return allEmployeeData.where((element) =>
                                        element.displayText!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                  });
                                },
                                itemBuilder: (context, ProductListModel suggestion) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                    child: Text(suggestion.displayText!,
                                      style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                                onSelected: (ProductListModel suggestion) {
                                  setState(() {
                                    _employeeController.text = suggestion.displayText!;
                                    employeeId = suggestion.productSlNo.toString();
                                  });
                                },
                              ),
                            ),
                          ):Expanded(
                            flex: 8,
                            child: Container(
                                height: 25.0.h,
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.only(top: 5.0.h,left: 4.0.w),
                                margin: EdgeInsets.only(bottom: 5.0.h),
                                decoration: ContDecoration.contDecoration,
                                child: Text(userName,style: AllTextStyle.textValueStyle)
                            ),
                          ),
                        ],
                      )
                    ],
                  ): Container(),
                  SizedBox(
                    height: 25.0.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 25.0.h,
                            padding: EdgeInsets.all(5.r),
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                  filled: true,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(left: 25.w),
                                    child: Icon(Icons.calendar_month, color: Color.fromARGB(221,22,51,95), size: 16.r),
                                  ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: firstPickedDate ,
                                  hintStyle:  TextStyle(fontSize: 13.sp, color: Colors.grey.shade700,fontWeight: FontWeight.w400),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Text("To",style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w400)),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 25.0.h,
                            padding: EdgeInsets.all(5.r),
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                _secondSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 10.h, left: 5.w),
                                  filled: true,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(left: 25.w),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Color.fromARGB(221, 22, 51, 95),
                                      size: 16.r,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: secondPickedDate,
                                  hintStyle: TextStyle(
                                    fontSize: 13.sp,color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w400,),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        padding: EdgeInsets.all(1.0.r),
                        child: InkWell(
                          onTap: () async {
                            // final connectivityResult = await (Connectivity().checkConnectivity());
                            // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            //   setState(() {
                            //     _searchType == "By Customer" ? data = 'by customer':
                            //     _searchType == "By Employee" ? data = 'by employee':
                            //     _searchType == "All" ? data = 'all' : '';
                            //   });
                            //   VisitsProvider().on();
                            //   Provider.of<VisitsProvider>(context, listen: false).getVisits(
                            //     _selectedCustomer ?? '',
                            //     userType == "m"||userType == "a" ? "$employeeId" : userEmployeeId,
                            //     "$backEndFirstDate",
                            //     "$backEndSecondtDate",
                            //   );
                            // }
                            // else{
                            //   Utils.errorSnackBar(context, "Please check your internet connection");
                            // }
                          },
                          child: Container(
                            height: 28.0.h,
                            width: 100.0.w,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade900,
                              borderRadius: BorderRadius.circular(5.0.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(child: Text("Show Report", style: TextStyle(color: Colors.white))),
                          ),

                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.0.h),
          // VisitsProvider.isVisitsLoading ?
          // const Center(child: CircularProgressIndicator(),)
          //     :allGetVisitsData.isNotEmpty? Expanded(child: Container(
          //   padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.vertical,
          //     child: SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           DataTable(
          //             columnSpacing: 25,
          //             headingRowHeight: 20.0,
          //             dataRowHeight: 20.0,
          //             headingRowColor: data == 'all'? WidgetStateColor.resolveWith((states) => Colors.indigo):WidgetStateColor.resolveWith((states) => Colors.blue.shade900),
          //             showCheckboxColumn: true,
          //             border: TableBorder.all(color: Colors.white, width: 1),
          //             columns: const [
          //               DataColumn(label: Expanded(child: Center(child: Text('Sl',style:AllTextStyle.tableHeadTextStyle)))),
          //               DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
          //               DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
          //               DataColumn(label: Expanded(child: Center(child: Text('Address	Name',style:AllTextStyle.tableHeadTextStyle)))),
          //               DataColumn(label: Expanded(child: Center(child: Text('Name',style:AllTextStyle.tableHeadTextStyle)))),
          //               DataColumn(label: Expanded(child: Center(child: Text('Mobile',style:AllTextStyle.tableHeadTextStyle)))),
          //               DataColumn(label: Expanded(child: Center(child: Text('Note',style:AllTextStyle.tableHeadTextStyle)))),
          //             ],
          //             rows: List.generate(
          //               allGetVisitsData.length,
          //                   (int index) => DataRow(
          //                 color:data == 'all'? index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor):WidgetStateProperty.resolveWith(getColors):index % 2 == 0 ? WidgetStateProperty.resolveWith(getColorsbyAll):WidgetStateProperty.resolveWith(getColors),
          //                 cells: <DataCell>[
          //                   DataCell(Center(child: Text("${index+1}"))),
          //                   DataCell(Center(child: Text(allGetVisitsData[index].customerCode)),),
          //                   DataCell(SizedBox(width: MediaQuery.of(context).size.width/2.4,
          //                     child: Padding(padding: const EdgeInsets.only(left: 0),
          //                       child: Text(allGetVisitsData[index].customerName),
          //                     ),),
          //                   ),
          //                   DataCell(Center(child: Text(allGetVisitsData[index].customerAddress))),
          //                   DataCell(Center(child: Text(allGetVisitsData[index].name))),
          //                   DataCell(Center(child: Text(allGetVisitsData[index].customerMobile))),
          //                   DataCell(Center(child: Text(allGetVisitsData[index].note))),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // ):const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))),
          //
        ],
      ),
    );
  }
}
