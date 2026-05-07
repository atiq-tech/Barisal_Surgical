import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/providers/sales_module_providers/emp_wise_cus_pay_due_provider.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
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

  bool isAllTypeClicked = true;
  bool isEmployeeWiseClicked = false;
  bool _isSearchDropdownOpen = false;
  String searchStatus = "";
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = ['All', 'By Employee'];

  final LayerLink _searchLayerLink = LayerLink();
  OverlayEntry? _searchOverlayEntry;
  final GlobalKey _searchKey = GlobalKey();
  Size _searchDropdownSize = Size.zero;

  void _getSearchDropdownSize() {
    final RenderBox? renderBox = _searchKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _searchDropdownSize = renderBox.size;
    }
  }

  void _toggleSearchDropdown() {
    if (_isSearchDropdownOpen) {
      _removeSearchDropdown();
    } else {
      _getSearchDropdownSize();
      _showSearchDropdown();
    }
  }

  void _showSearchDropdown() {
    _searchOverlayEntry = _createSearchOverlayEntry();
    Overlay.of(context).insert(_searchOverlayEntry!);
    setState(() {
      _isSearchDropdownOpen = true;
    });
  }

  void _removeSearchDropdown() {
    _searchOverlayEntry?.remove();
    _searchOverlayEntry = null;
    setState(() {
      _isSearchDropdownOpen = false;
    });
  }

  OverlayEntry _createSearchOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeSearchDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: _searchDropdownSize.width,
              child: CompositedTransformFollower(
                link: _searchLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, _searchDropdownSize.height + 5), // বাটনের নিচে সামান্য গ্যাপ
                child: Material(
                  elevation: 9.0,
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _searchTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final type = entry.value;
                      return InkWell(
                        onTap: () {
                          _onSearchTypeSelected(type);
                          _removeSearchDropdown();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              child: Text(
                                type,style: TextStyle(fontSize: 12.sp)
                              ),
                            ),
                            if (index != _searchTypes.length - 1)
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

  void _onSearchTypeSelected(String selectedValue) {
    setState(() {
      _selectedSearchTypes = selectedValue;
      isAllTypeClicked = (selectedValue == "All");
      isEmployeeWiseClicked = (selectedValue == "By Employee");
      if (selectedValue == "All") {
        searchStatus = ""; 
      } else if (selectedValue == "By Employee") {
        searchStatus = "employee";
      }
      emtyMethod(); // আপনার প্র্য়োজনীয় মেথড কল
    });
  }


  bool isAllPaymentClicked = true;
  bool isPaidClicked = false;
  bool isDueClicked = false;
  bool _isPaymentDropdownOpen = false;
  String paymentStatus = "";
  String? _selectedPaymentTypes = 'All';
  final List<String> _paymentTypes = ['All', 'Paid', 'Due'];

  final LayerLink _paymentLayerLink = LayerLink();
  OverlayEntry? _paymentOverlayEntry;
  final GlobalKey _paymentKey = GlobalKey();
  Size _paymentDropdownSize = Size.zero;

  // ড্রপডাউনের সাইজ ক্যালকুলেট করার জন্য
  void _getPaymentDropdownSize() {
    final RenderBox renderBox = _paymentKey.currentContext?.findRenderObject() as RenderBox;
    _paymentDropdownSize = renderBox.size;
  }

  void _togglePaymentDropdown() {
    if (_isPaymentDropdownOpen) {
      _removePaymentDropdown();
    } else {
      _getPaymentDropdownSize(); // ওপেন করার সময় সাইজ আপডেট করে নেওয়া ভালো
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
                offset: Offset(0.0, _paymentDropdownSize.height + 5), // বাটনের ঠিক নিচে দেখাবে
                child: Material(
                  elevation: 9.0,
                  color: Colors.teal.shade50, // আপনার আগের কালার থিম অনুযায়ী
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
                              child: Text(
                                type,style: TextStyle(fontSize: 12.sp), // আপনার কাস্টম স্টাইল
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
      isPaidClicked = selectedValue == "Paid";
      isDueClicked = selectedValue == "Due";
      if (selectedValue == "All") {
        paymentStatus = ""; 
      } else if (selectedValue == "Paid") {
        paymentStatus = "paid";
      } else if (selectedValue == "Due") {
        paymentStatus = "due";
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
    /// Get Employee
     final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
     final allEmpWiseCusPayDueData = Provider.of<EmpWiseCusPayDueProvider>(context).empWiseCusPayDuelist;

allEmpWiseCusPayDueData.sort((a, b) {
  int emp = (a.employeeName ?? "").compareTo(b.employeeName ?? "");
  if (emp != 0) return emp;

  int cus = (a.customerName ?? "").compareTo(b.customerName ?? "");
  if (cus != 0) return cus;

  return (a.invoiceNo ?? "").compareTo(b.invoiceNo ?? "");
});

List<DataRow> _buildRows() {
  List<DataRow> rows = [];

  /// 🔥 GRAND TOTALS
  double grandInvoiceAmount = 0;
  double grandDiscount = 0;
  double grandVat = 0;
  double grandTrCost = 0;
  double grandReturnedAmount = 0;
  double grandNetPayable = 0;
  double grandPaidAmount = 0;
  double grandInvoiceDue = 0;
  double grandPreviousDue = 0;
  double grandTotalDue = 0;

  String currentEmployee = "";
  String currentCustomer = "";

  /// 🔥 SERIAL (NEW)
  int serial = 0;

  /// Employee totals
  double empInvoiceAmount = 0, empDiscount = 0, empVat = 0, empTrCost = 0;
  double empReturned = 0, empNetPayable = 0, empPaid = 0;
  double empInvoiceDue = 0, empPreviousDue = 0, empTotalDue = 0;

  /// Customer totals
  double cusInvoiceAmount = 0, cusDiscount = 0, cusVat = 0, cusTrCost = 0;
  double cusReturned = 0, cusNetPayable = 0, cusPaid = 0;
  double cusInvoiceDue = 0, cusPreviousDue = 0, cusTotalDue = 0;

  for (int i = 0; i < allEmpWiseCusPayDueData.length; i++) {
    var data = allEmpWiseCusPayDueData[i];

    /// ================= EMPLOYEE CHANGE =================
    if (currentEmployee != (data.employeeName ?? "")) {

      if (currentCustomer.isNotEmpty) {
        rows.add(_customerSubtotalRow(
          currentCustomer,
          cusInvoiceAmount,
          cusDiscount,
          cusVat,
          cusTrCost,
          cusReturned,
          cusNetPayable,
          cusPaid,
          cusInvoiceDue,
          cusPreviousDue,
          cusTotalDue,
        ));
      }

      if (currentEmployee.isNotEmpty) {
        rows.add(_employeeSubtotalRow(
          currentEmployee,
          empInvoiceAmount,
          empDiscount,
          empVat,
          empTrCost,
          empReturned,
          empNetPayable,
          empPaid,
          empInvoiceDue,
          empPreviousDue,
          empTotalDue,
        ));
      }

      currentEmployee = data.employeeName ?? "";
      currentCustomer = "";

      empInvoiceAmount = empDiscount = empVat = empTrCost = 0;
      empReturned = empNetPayable = empPaid = 0;
      empInvoiceDue = empPreviousDue = empTotalDue = 0;

      /// 🔴 SERIAL reset optional (not needed but safe)
      serial = 0;

      rows.add(
        DataRow(
          color: WidgetStateProperty.all(Colors.grey.shade300),
          cells: [
            const DataCell(Text("")),
            const DataCell(Text("")),
            const DataCell(Text("")),
            const DataCell(Text("")),
            DataCell(Text(
              "Employee Name : $currentEmployee",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            )),
            ...List.generate(10, (_) => const DataCell(Text(""))),
          ],
        ),
      );
    }

    /// ================= CUSTOMER CHANGE =================
    if (currentCustomer != (data.customerName ?? "")) {

      if (currentCustomer.isNotEmpty) {
        rows.add(_customerSubtotalRow(
          currentCustomer,
          cusInvoiceAmount,
          cusDiscount,
          cusVat,
          cusTrCost,
          cusReturned,
          cusNetPayable,
          cusPaid,
          cusInvoiceDue,
          cusPreviousDue,
          cusTotalDue,
        ));
      }

      currentCustomer = data.customerName ?? "";

      /// 🔥 SERIAL RESET HERE (IMPORTANT)
      serial = 0;

      cusInvoiceAmount = cusDiscount = cusVat = cusTrCost = 0;
      cusReturned = cusNetPayable = cusPaid = 0;
      cusInvoiceDue = cusPreviousDue = cusTotalDue = 0;
    }

    /// 🔥 SERIAL INCREMENT
    serial++;

    /// ================= NORMAL ROW =================
    rows.add(
      DataRow(
        color: i % 2 == 0
            ? WidgetStateProperty.all(Colors.grey.shade100)
            : WidgetStateProperty.all(Colors.white),
        cells: [
          DataCell(Text("$serial")), // 🔥 FIXED
          DataCell(Text(data.date ?? "")),
          DataCell(Text(data.invoiceNo ?? "")),
          DataCell(Text(data.comment ?? "")),
          DataCell(Text(data.customerName ?? "")),
          DataCell(Text(data.subTotal ?? "0")),
          DataCell(Text(data.discount ?? "0")),
          DataCell(Text(data.vat ?? "0")),
          DataCell(Text(data.transport ?? "0")),
          DataCell(Text(data.returned ?? "0")),
          DataCell(Text(data.bill ?? "0")),
          DataCell(Text(data.paid ?? "0")),
          DataCell(Text(data.invoiceDue ?? "0")),
          DataCell(Text(data.previousDue ?? "0")),
          DataCell(Text(data.due ?? "0")),
        ],
      ),
    );

    /// ================= TOTAL ADD =================
    double sub = double.tryParse(data.subTotal ?? "0") ?? 0;
    double dis = double.tryParse(data.discount ?? "0") ?? 0;
    double vat = double.tryParse(data.vat ?? "0") ?? 0;
    double tr = double.tryParse(data.transport ?? "0") ?? 0;
    double ret = double.tryParse(data.returned ?? "0") ?? 0;
    double net = double.tryParse(data.bill ?? "0") ?? 0;
    double paid = double.tryParse(data.paid ?? "0") ?? 0;
    double invDue = double.tryParse(data.invoiceDue ?? "0") ?? 0;
    double prev = double.tryParse(data.previousDue ?? "0") ?? 0;
    double due = double.tryParse(data.due ?? "0") ?? 0;

    cusInvoiceAmount += sub;
    cusDiscount += dis;
    cusVat += vat;
    cusTrCost += tr;
    cusReturned += ret;
    cusNetPayable += net;
    cusPaid += paid;
    cusInvoiceDue += invDue;
    cusPreviousDue += prev;
    cusTotalDue += due;

    empInvoiceAmount += sub;
    empDiscount += dis;
    empVat += vat;
    empTrCost += tr;
    empReturned += ret;
    empNetPayable += net;
    empPaid += paid;
    empInvoiceDue += invDue;
    empPreviousDue += prev;
    empTotalDue += due;

    grandInvoiceAmount += sub;
    grandDiscount += dis;
    grandVat += vat;
    grandTrCost += tr;
    grandReturnedAmount += ret;
    grandNetPayable += net;
    grandPaidAmount += paid;
    grandInvoiceDue += invDue;
    grandPreviousDue += prev;
    grandTotalDue += due;
  }

  /// LAST CUSTOMER
  if (currentCustomer.isNotEmpty) {
    rows.add(_customerSubtotalRow(
      currentCustomer,
      cusInvoiceAmount,
      cusDiscount,
      cusVat,
      cusTrCost,
      cusReturned,
      cusNetPayable,
      cusPaid,
      cusInvoiceDue,
      cusPreviousDue,
      cusTotalDue,
    ));
  }

  /// LAST EMPLOYEE
  if (currentEmployee.isNotEmpty) {
    rows.add(_employeeSubtotalRow(
      currentEmployee,
      empInvoiceAmount,
      empDiscount,
      empVat,
      empTrCost,
      empReturned,
      empNetPayable,
      empPaid,
      empInvoiceDue,
      empPreviousDue,
      empTotalDue,
    ));
  }

  /// ✅ GRAND TOTAL ROW
  rows.add(
    DataRow(
      color: WidgetStateProperty.all(Colors.green.shade700),
      cells: [
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text(
          "GRAND TOTAL",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        
    DataCell(Text(
          grandInvoiceAmount.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandDiscount.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandVat.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandTrCost.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandReturnedAmount.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),

         DataCell(Text(
          grandNetPayable.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandPaidAmount.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandInvoiceDue.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),

        DataCell(Text(
          grandPreviousDue.toStringAsFixed(2),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          grandTotalDue.toStringAsFixed(3),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ],
    ),
  );
    return rows;
}

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
                        child: CompositedTransformTarget(
                          link: _searchLayerLink,
                          child: InkWell(
                            key: _searchKey,
                            onTap: _toggleSearchDropdown,
                            child: Container(
                              height: 25.0.h,
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey, width: 0.5.w),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedSearchTypes ?? 'Select',
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
                            searchStatus,
                            paymentStatus,
                            backEndFirstDate,
                            backEndSecondtDate
                          );
                          print("customerIdToPass====${_selectCustomerId??""}");
                          print("employeeIdToPass====$employeeIdToPass");
                          print("searchStatus====$searchStatus");
                          print("paymentStatus====$paymentStatus");
                          print("backEndFirstDate====$backEndFirstDate");
                          print("backEndSecondtDate====$backEndSecondtDate");
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
            EmpWiseCusPayDueProvider.isEmpWiseCusPayDueLoading ?
            const Center(child: CircularProgressIndicator(),)
           : allEmpWiseCusPayDueData.isNotEmpty? Expanded(
  child: Container(
    padding: EdgeInsets.only(bottom: 10.h),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= TABLE =================
            DataTable(
              headingRowHeight: 25.h,
              dataRowHeight: 22.h,
              headingRowColor: WidgetStateProperty.all(AppColors.appColor),
              border: TableBorder.all(color: Colors.black54, width: 1.w),

              columns: [
                DataColumn(label: Text('SL No',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Invoice Date',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Invoice No',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Comments',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Invoice Amount',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Discount',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Vat',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Transport Cost',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Return Amount',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Net Payable',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Paid Amount',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Invoice Due',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Previous Due',style: AllTextStyle.tableHeadTextStyle)),
                DataColumn(label: Text('Total Due',style: AllTextStyle.tableHeadTextStyle)),
              ],

              rows: _buildRows(),
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
  DataRow _employeeSubtotalRow(
  String name,
  double invoice,
  double discount,
  double vat,
  double trCost,
  double returned,
  double net,
  double paid,
  double invoiceDue,
  double prevDue,
  double totalDue,
) {
  return DataRow(
    color: WidgetStateProperty.all(Colors.grey.shade400),
    cells: [

      /// 1-4 empty
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(Text("")),

      /// label
      DataCell(Text(
        "Sub Total for $name:",
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),

      /// values
      DataCell(Text(invoice.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(discount.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(vat.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(trCost.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(returned.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(net.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(paid.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(invoiceDue.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(prevDue.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
      DataCell(Text(totalDue.toStringAsFixed(2),style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
    ],
  );
}

DataRow _customerSubtotalRow(
  String name,
  double invoice,
  double discount,
  double vat,
  double trCost,
  double returned,
  double net,
  double paid,
  double invoiceDue,
  double prevDue,
  double totalDue,
) {
  return DataRow(
    color: WidgetStateProperty.all(Colors.grey.shade300),
    cells: [
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(Text("")),

      DataCell(Text(
        "Sub Total ($name):",
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),

      DataCell(Text(invoice.toStringAsFixed(2))),
      DataCell(Text(discount.toStringAsFixed(2))),
      DataCell(Text(vat.toStringAsFixed(2))),
      DataCell(Text(trCost.toStringAsFixed(2))),
      DataCell(Text(returned.toStringAsFixed(2))),
      DataCell(Text(net.toStringAsFixed(2))),
      DataCell(Text(paid.toStringAsFixed(2))),
      DataCell(Text(invoiceDue.toStringAsFixed(2))),
      DataCell(Text(prevDue.toStringAsFixed(2))),
      DataCell(Text(totalDue.toStringAsFixed(2))),
    ],
  );
}
}
