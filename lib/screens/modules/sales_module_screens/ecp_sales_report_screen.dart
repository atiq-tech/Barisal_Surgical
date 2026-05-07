import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/product_list_model.dart';
import 'package:barishal_surgical/providers/sales_module_providers/ecp_wise_sale_report_provider.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../models/administration_module_models/customer_list_model.dart';
import '../../../models/administration_module_models/employees_model.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../utils/utils.dart';

class ECPSalesReportScreen extends StatefulWidget {
  const ECPSalesReportScreen({super.key});
  @override
  State<ECPSalesReportScreen> createState() => _ECPSalesReportScreenState();
}

class _ECPSalesReportScreenState extends State<ECPSalesReportScreen> {
  Color getColor(Set<MaterialState> states) {
    return Colors.blue.shade100;
  }
  Color getColors(Set<MaterialState> states) {
    return Colors.white;
  }
  Color getColorWithDetails(Set<MaterialState> states) {
    return Colors.purple.shade100;
  }
  Color getColorTotal(Set<MaterialState> states) {
    return Colors.blue.shade900;
  }
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
      });
    }
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
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
      });
    }else{
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondtDate = Utils.formatBackEndDate(toDay);
      });
    }
  }

  // dropdown value
  String? _selectCustomerId;
  String? _selectEmployeeId;
  String? _selectProductId;

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

  String userName = "";
  String? userEmployeeID = "";
  String? userEmployeeName = "";
  String? userType = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences?.getString('userName') ?? "";
      userEmployeeID = sharedPreferences?.getString('employeeId') ?? "";
      userEmployeeName = sharedPreferences?.getString('employeeName') ?? "";
      userType = sharedPreferences?.getString('userType') ?? "";
    });
    print("userType======$userType");
    _loadCustomerData();
  }

  void _loadCustomerData() {
    String employeeIdToPass = (userType == "a" || userType == "m") ? "" : (userEmployeeID ?? "");
    CustomerListProvider.isCustomerListloading = true;
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(
      context, 
      "", 
      employeeIdToPass
    );
  }

  @override
  void initState() {
    _initLocation();
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context,"");
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<EcpWiseSaleReportProvider>(context,listen: false).ecpWiseSalesReportlist = [];
    super.initState();
  }

  var customerController = TextEditingController();
  var employeeController = TextEditingController();
  var productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///get Customer
     final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo !=0).toList();
    /// Get Employee
     final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
    /// Get Product
     final allProductData = Provider.of<ProductListProvider>(context).productsList;
    /// Get Product
     final allEcpWiseSalesReportData = Provider.of<EcpWiseSaleReportProvider>(context).ecpWiseSalesReportlist;
     allEcpWiseSalesReportData.sort((a, b) {
      int cus = (a.customerName ?? "").compareTo(b.customerName ?? "");
      if (cus != 0) return cus;
      return (a.productName ?? "").compareTo(b.productName ?? "");
    });

    List<DataRow> _buildSalesRows() {
    List<DataRow> rows = [];
    String currentCustomer = "";

    int serial = 0;
    double cusQty = 0;
    double cusAmount = 0;
    double grandQty = 0;
    double grandAmount = 0;

    for (int i = 0; i < allEcpWiseSalesReportData.length; i++) {
      var data = allEcpWiseSalesReportData[i];
      double qty = double.tryParse(data.quantity ?? "0") ?? 0;
      double amt = double.tryParse(data.amount ?? "0") ?? 0;

      /// 🔴 Customer Change
      if (currentCustomer != (data.customerName ?? "")) {
        /// last customer subtotal
        if (currentCustomer.isNotEmpty) {
          rows.add(_customerSubtotalRow(currentCustomer, cusQty, cusAmount));
        }
        currentCustomer = data.customerName ?? "";
        /// reset
        serial = 0;
        cusQty = 0;
        cusAmount = 0;
      }
      /// serial
      serial++;
      /// 🔹 normal row
      rows.add(
        DataRow(
          cells: [
            DataCell(Center(child: Text("$serial"))),
            DataCell(Center(child: Text(data.employeeName ?? ""))),
            DataCell(Center(child: Text(data.customerName ?? ""))),
            DataCell(Center(child: Text(data.productName ?? ""))),
            DataCell(Center(child: Text(data.quantity ?? ""))),
            DataCell(Center(child: Text(data.amount ?? ""))),
          ],
        ),
      );
      /// totals
      cusQty += qty;
      cusAmount += amt;
      grandQty += qty;
      grandAmount += amt;
    }

    /// last customer subtotal
    if (currentCustomer.isNotEmpty) {
      rows.add(_customerSubtotalRow(currentCustomer, cusQty, cusAmount));
    }
    /// 🔥 GRAND TOTAL
    rows.add(
      DataRow(
        color: WidgetStateProperty.all(AppColors.appColor),
        cells: [
          const DataCell(Text("")),
          const DataCell(Text("")),
          const DataCell(Text("")),
          DataCell(Center(child: Text("Grand Total",style: AllTextStyle.tableHeadTextStyle))),
          DataCell(Center(child: Text(grandQty.toStringAsFixed(0),style: AllTextStyle.tableHeadTextStyle))),
          DataCell(Center(child: Text(grandAmount.toStringAsFixed(2),style: AllTextStyle.tableHeadTextStyle))),
        ],
      ),
    );
    return rows;
  }

    return Scaffold(
      appBar: CustomAppBar(title: " ECP Sales Report"),
      body: Container(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 8.0.h,bottom: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w,bottom: 4.0.h),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10.0.r),
                border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.6), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [             
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Employee", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: userType == "a" || userType == "m"
                            ? TypeAheadField<EmployeesModel>(
                                controller: employeeController,
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                              decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                isDense: true,
                                hintText: 'Select Employee',
                                hintStyle: TextStyle(fontSize: 13.sp),
                                suffixIcon: _selectEmployeeId == '' || _selectEmployeeId == 'null' || _selectEmployeeId == null || controller.text == '' ? null
                                    : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      employeeController.clear();
                                      controller.clear();
                                      _selectEmployeeId = null;
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
                              return allGetEmployeesData.where((element) =>
                                  element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                            });
                          },
                          itemBuilder: (context, EmployeesModel suggestion) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                              child: Text(suggestion.displayName!,
                                style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          onSelected: (EmployeesModel suggestion) {
                            setState(() {
                              employeeController.text = suggestion.displayName!;
                              _selectEmployeeId = suggestion.employeeSlNo.toString();
                            });
                            Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(
                              context, 
                              "", 
                              "$_selectEmployeeId"
                            );
                          },
                        ):Container(
                          height: 25.h,
                          decoration:ContDecoration.contDecoration,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                            child: Text("$userEmployeeName",style: AllTextStyle.dateFormatStyle),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                employeeController.text.isEmpty ? SizedBox() : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: TypeAheadField<CustomerListModel>(
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
                                return allCustomerData.where((element) =>
                                    element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                              });
                            },
                            itemBuilder: (context, CustomerListModel suggestion) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                child: Text(suggestion.displayName!,
                                  style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            onSelected: (CustomerListModel suggestion) {
                              setState(() {
                                customerController.text = suggestion.displayName!;
                                _selectCustomerId = suggestion.customerSlNo.toString();
                              });
                               Provider.of<ProductListProvider>(context, listen: false).getProductList(
                                context, 
                                _selectCustomerId??"", 
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  customerController.text.isEmpty ? SizedBox() : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Product",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: TypeAheadField<ProductListModel>(
                            controller: productController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                  isDense: true,
                                  hintText: 'Select Product',
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  suffixIcon: _selectProductId == '' || _selectProductId == 'null' || _selectProductId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        productController.clear();
                                        controller.clear();
                                        _selectProductId = null;
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
                                return allProductData.where((element) =>
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
                                productController.text = suggestion.displayText!;
                                _selectProductId = suggestion.productSlNo.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 5.w, top: 5.h, bottom: 5.h),
                            height: 25.0.h,
                            padding: EdgeInsets.all(5.0.r),
                            decoration:ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {_firstSelectedDate();}),
                              child: TextFormField(
                                style: AllTextStyle.dateFormatStyle,
                                enabled: false,
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r),
                                    ),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: firstPickedDate ,
                                    hintStyle: AllTextStyle.dateFormatStyle
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
                        const Text("To"),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
                            height: 25.0.h,
                            padding: EdgeInsets.all(5.0.r),
                            decoration:ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {_secondSelectedDate();
                              }),
                              child: TextFormField(
                                style: AllTextStyle.dateFormatStyle,
                                enabled: false,
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r),
                                    ),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: secondPickedDate,
                                    hintStyle: AllTextStyle.dateFormatStyle
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
                  /// Date Picker
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(1.0.r),
                      child: InkWell(
                        onTap: () async {
                          String employeeIdToPass = (userType == "a" || userType == "m") ? "$_selectEmployeeId" : (userEmployeeID ?? "");
                          EcpWiseSaleReportProvider().on();
                          Provider.of<EcpWiseSaleReportProvider>(context,listen: false).
                          getEcpWiseSalesReport(context,
                            employeeIdToPass=="null" ? "" : employeeIdToPass,
                            _selectCustomerId??"",
                            _selectProductId??"",
                            backEndFirstDate,
                            backEndSecondtDate
                         );
                        },
                        child: Container(
                          height: 28.0.h,
                          width: 102.0.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 4, 113, 185),
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
                          child: Center(child: Text("Show Report", style:AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            EcpWiseSaleReportProvider.isEcpWiseSalesReportLoading ?
            const Center(child: CircularProgressIndicator(),)
           :allEcpWiseSalesReportData.isNotEmpty? Expanded(child: Container(
           padding: EdgeInsets.only(bottom: 10.h),
             child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child: SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     DataTable(
                       headingRowHeight: 20.h,
                       // ignore: deprecated_member_use
                       dataRowHeight: 20.h,
                       headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                       showCheckboxColumn: true,
                       border: TableBorder.all(color: Colors.white30, width: 1.w),
                       columns: [
                         DataColumn(label: Expanded(child: Center(child: Text('SL No',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Employee',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Customer',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Product',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Amount',style:AllTextStyle.tableHeadTextStyle)))),
                        ],

                       rows: _buildSalesRows(),

                     ),
                     SizedBox(height: 100.h)
                   ],
                 ),
               ),
             ),
           ),
          ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))), 
         
          ],
        ),
      ),
    );
  }
  DataRow _customerSubtotalRow(String name, double qty, double amount) {
  return DataRow(
    color: WidgetStateProperty.all(Colors.blue.shade100),
    cells: [
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(Text("")),
      DataCell(Center(
        child: Text(
          "Sub Total For ($name) :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
      DataCell(Center(child: Text(qty.toStringAsFixed(0),style: TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Center(child: Text(amount.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold)))),
    ],
  );
}
}
