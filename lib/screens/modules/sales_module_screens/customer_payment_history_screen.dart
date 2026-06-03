import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/providers/sales_module_providers/emp_wise_cus_pay_due_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../utils/utils.dart';

class CustomerPaymentHistoryScreen extends StatefulWidget {
  const CustomerPaymentHistoryScreen({super.key});
  @override
  State<CustomerPaymentHistoryScreen> createState() => _CustomerPaymentHistoryScreenState();
}

class _CustomerPaymentHistoryScreenState extends State<CustomerPaymentHistoryScreen> {
  var customerController = TextEditingController();
  var employeeController = TextEditingController();
  String? _selectCustomerId;
  String? _selectEmployeeId;

  Color getColor(Set<MaterialState> states) {return Colors.blue.shade100;}
  Color getColors(Set<MaterialState> states) {return Colors.white;}

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

  bool isAllPaymentClicked = true;
  bool isPaidClicked = false;
  bool isReceivedClicked = false;
  bool _isPaymentDropdownOpen = false;
  String paymentStatus = "";
  String? _selectedPaymentTypes = 'All';
  final List<String> _paymentTypes = ['All', 'Received', 'Paid'];

  final LayerLink _paymentLayerLink = LayerLink();
  OverlayEntry? _paymentOverlayEntry;
  final GlobalKey _paymentKey = GlobalKey();
  Size _paymentDropdownSize = Size.zero;

  void _getPaymentDropdownSize() {
    final RenderBox renderBox = _paymentKey.currentContext?.findRenderObject() as RenderBox;
    _paymentDropdownSize = renderBox.size;
  }

  void _togglePaymentDropdown() {
    if (_isPaymentDropdownOpen) {
      _removePaymentDropdown();
    } else {
      _getPaymentDropdownSize(); 
      _showPaymentDropdown();
    }
  }

  void _showPaymentDropdown() {
    _paymentOverlayEntry = _createPaymentOverlayEntry();
    Overlay.of(context).insert(_paymentOverlayEntry!);
    setState(() {
      _isPaymentDropdownOpen = true;
    });
  }

  void _removePaymentDropdown() {
    _paymentOverlayEntry?.remove();
    _paymentOverlayEntry = null;
    setState(() {
      _isPaymentDropdownOpen = false;
    });
  }

  OverlayEntry _createPaymentOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removePaymentDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: _paymentDropdownSize.width,
              child: CompositedTransformFollower(
                link: _paymentLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, _paymentDropdownSize.height + 5), 
                child: Material(
                  elevation: 9.0,
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(5.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _paymentTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final type = entry.value;
                      return InkWell(
                        onTap: () {
                          _onSelectedPayment(type);
                          _removePaymentDropdown();
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              child: Text(type,style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            if (index != _paymentTypes.length - 1)
                              Divider(height: 1.h, thickness: 0.8, color: Colors.grey.shade400),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectedPayment(String selectedValue) {
    setState(() {
      _selectedPaymentTypes = selectedValue;
      isAllPaymentClicked = selectedValue == "All";
      isReceivedClicked = selectedValue == "Received";
      isPaidClicked = selectedValue == "Paid";
      if (selectedValue == "All") {
        paymentStatus = ""; 
      } else if (selectedValue == "Received") {
        paymentStatus = "received";
      } else if (selectedValue == "Paid") {
        paymentStatus = "paid";
      }
      emtyMethod(); 
    });
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
    _initializeData();
    _initLocation();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<EmpWiseCusPayDueProvider>(context,listen: false).empWiseCusPayDuelist = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     ///get Customer
     final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo !=0).toList();
    return Scaffold(
      appBar: CustomAppBar(title: "Customer Payment History"),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 25.0.h,
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
                        child: CompositedTransformTarget(
                          link: _paymentLayerLink,
                          child: InkWell(
                            key: _paymentKey, 
                            onTap: _togglePaymentDropdown,
                            child: Container(
                              height: 25.0.h,
                              padding: EdgeInsets.symmetric(horizontal: 6.w) ,
                              decoration: BoxDecoration(
                              color: Colors.white,
                                border: Border.all(color: Colors.grey, width: 0.5.w),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Text(_selectedPaymentTypes ?? 'Select'),
                                  // Icon(Icons.arrow_drop_down),
                                  Text(
                                    _selectedPaymentTypes ?? 'Select',
                                    style: AllTextStyle.dateFormatStyle,
                                  ),
                                  SizedBox(width: 5.w),
                                  Icon(Icons.arrow_drop_down, color: Colors.black54, size: 18.r),
                                ],
                              ),
                            ),
                          ),
                        )
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
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 0.w),
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
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 0.w),
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
                          EmpWiseCusPayDueProvider().on();
                          String employeeIdToPass = (userType == "a" || userType == "m") ? "$_selectEmployeeId" : (userEmployeeID ?? "");
                          await Provider.of<EmpWiseCusPayDueProvider>(context, listen: false).getEmpWiseCusPayDue(
                            context,
                            _selectCustomerId??"",
                            employeeIdToPass=="null" ? "" : employeeIdToPass,
                            "",
                            paymentStatus,
                            backEndFirstDate,
                            backEndSecondtDate
                          );
                          print("customerIdToPass====${_selectCustomerId??""}");
                          print("employeeIdToPass====$employeeIdToPass");
                          print("paymentStatus====$paymentStatus");
                          print("backEndFirstDate====$backEndFirstDate");
                          print("backEndSecondtDate====$backEndSecondtDate");
                        },
                        child: Container(
                          height: 28.0.h,
                          width: 80.0.w,
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
                          child: Center(child: Text("Search", style:AllTextStyle.saveButtonTextStyle)),
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
