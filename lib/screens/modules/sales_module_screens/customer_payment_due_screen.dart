import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/users_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_details_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../providers/administration_module_providers/categories_provider.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../utils/utils.dart';

class CustomerPaymentDueScreen extends StatefulWidget {
  const CustomerPaymentDueScreen({super.key});
  @override
  State<CustomerPaymentDueScreen> createState() => _CustomerPaymentDueScreenState();
}

class _CustomerPaymentDueScreenState extends State<CustomerPaymentDueScreen> {
  var customerController = TextEditingController();
  var employeeController = TextEditingController();
  String? _selectCustomerId;
  String? _selectEmployeeId;

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

   emtyMethod() {
    setState(() {
      // customerController.text= "";
      // employeeController.text="";
      // _selectCustomerId = "";
      // _selectEmployeeId = "";
    });
  }
    //main dropdowns logic
  bool isAllTypeClicked = true;
  bool isEmployeeWiseClicked = false;
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Employee'
  ];
  void _searchTypeDropdown(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromLTRB(
      button.localToGlobal(Offset.zero, ancestor: overlay).dx + button.size.width,
      button.localToGlobal(Offset.zero, ancestor: overlay).dy+ 100.h,
      overlay.size.width - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dx,
      overlay.size.height - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dy,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.teal.shade900,
      items: _searchTypes.asMap().entries.map((entry) {
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
              if (index != _searchTypes.length - 1)
                Divider(height: 1.h, thickness: 0.8, color: Colors.grey.shade400),
            ],
          ),
        );
      }).toList(),
    );

    if (selectedValue != null) {
      setState(() {
        _selectedSearchTypes = selectedValue.toString();
        _selectedSearchTypes == "All"
            ? isAllTypeClicked = true
            : isAllTypeClicked = false;

        _selectedSearchTypes == "By Employee"
            ? isEmployeeWiseClicked = true
            : isEmployeeWiseClicked = false;

        emtyMethod();
      });
    }
  }


  bool isAllPaymentClicked = true;
  bool isPaidClicked = false;
  bool isDueClicked = false;
  String? _selectedPaymentTypes = 'All';
  final List<String> _paymentTypes = [
    'All',
    'Paid',
    'Due'
  ];

  void _paymentTypeDropdown(BuildContext context) async {
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
      items: _paymentTypes.asMap().entries.map((entry) {
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
              if (index != _paymentTypes.length - 1)
                Divider(height: 1.h, thickness: 0.8, color: Colors.grey.shade400),
            ],
          ),
        );
      }).toList(),
    );

    if (selectedValue != null) {
      setState(() {
        _selectedPaymentTypes = selectedValue.toString();
        // Boolean flags update
        isAllPaymentClicked = (_selectedPaymentTypes == "All");
        isPaidClicked = (_selectedPaymentTypes == "Paid");
        isDueClicked = (_selectedPaymentTypes == "Due");
        
        // Apnar proyojoniyo method call korun
        emtyMethod(); 
      });
    }
  }

  @override
  void initState() {
    _initLocation();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context);
    Provider.of<CategoriesProvider>(context, listen: false).getCategoriesList(context);
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"","");
    Provider.of<UsersProvider>(context,listen: false).getUsers(context);
    Provider.of<OrdersProvider>(context, listen: false).getOrders(context,"","","",backEndFirstDate,backEndSecondtDate);
    Provider.of<OrdersRecordProvider>(context,listen: false).getOrdersRecord(context,"", "", "", "", "");
    Provider.of<OrdersDetailsProvider>(context,listen: false).getOrdersDetails(context,"", "", "", "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     ///get Customer
     final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo !=0).toList();
    /// Get Employee
     final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
    return Scaffold(
      appBar: CustomAppBar(title: "Customer Payment Due"),
      body: Container(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 8.0.h,bottom: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w,top: 4.0.h, bottom: 4.0.h),
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
                    children: [
                      Expanded(flex: 2, child: Text("Search Type", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () => _searchTypeDropdown(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            height: 25.0.h,
                            decoration: ContDecoration.contDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedSearchTypes ?? 'Please select a type',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                Icon(Icons.arrow_drop_down,color: Colors.grey.shade700),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                 isEmployeeWiseClicked == true ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Employee", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: TypeAheadField<EmployeesModel>(
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
                            },
                          ),
                        ),
                      ),
                    ],
                  ):SizedBox(),
                employeeController.text.isEmpty ? SizedBox() : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 4,
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
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Text("Payment Type", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () => _paymentTypeDropdown(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            height: 25.0.h,
                            decoration: ContDecoration.contDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedPaymentTypes ?? 'Please select a type',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                Icon(Icons.arrow_drop_down,color: Colors.grey.shade700),
                              ],
                            ),
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
          ],
        ),
      ),
    );
  }
}
