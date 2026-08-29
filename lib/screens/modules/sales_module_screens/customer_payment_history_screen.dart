import 'dart:typed_data';

import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_payments_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/emp_wise_cus_pay_due_provider.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CustomerPaymentHistoryScreen extends StatefulWidget {
  const CustomerPaymentHistoryScreen({super.key});
  @override
  State<CustomerPaymentHistoryScreen> createState() => _CustomerPaymentHistoryScreenState();
}

class _CustomerPaymentHistoryScreenState extends State<CustomerPaymentHistoryScreen> {
  var customerController = TextEditingController();
  var employeeController = TextEditingController();
  String? _selectCustomerId;
  //String? _selectEmployeeId;

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
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
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
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
  }

  @override
  void initState() {
    getCompanyProfile();
    getCurrentBranch();
    _initializeData();
    _initLocation();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<EmpWiseCusPayDueProvider>(context,listen: false).empWiseCusPayDuelist = [];
    Provider.of<CustomerPaymentsProvider>(context, listen: false).getCustomerPayments(context,"","","",backEndFirstDate,backEndFirstDate);
    super.initState();
  }

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

  Future<void> _printCustomerPaymentData(List allCustomerPaymentData, double totalAmount) async {
    final pdf = pw.Document();
    String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final Uint8List? netHeader = await _fetchImage("$imageBaseUrl$headerImg");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(2.r), 
        build: (pw.Context context) {
          return [
            pw.Text(currentDateTime, style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic, font: font)),
            pw.SizedBox(height: 5),
            
            if (netHeader != null) 
            pw.Center(child: pw.Image(pw.MemoryImage(netHeader), height: 80, width: 500)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Tr. Id', 'Invoice No', 'Date', 'Customer', 'Tr. Type', 'Payment by', 'Description', 'Amount'],
              data: [
                ...List.generate(allCustomerPaymentData.length, (index) {
                  final item = allCustomerPaymentData[index];
                  return [
                    item.cPaymentInvoice ?? '',
                    item.saleMasterInvoiceNo ?? '',
                    item.cPaymentDate ?? '',
                    item.customerName ?? '',
                    item.transactionType ?? '',
                    item.paymentBy ?? '',
                    item.cPaymentNotes ?? '',
                    item.cPaymentAmount ?? '0',
                  ];
                }),
                [
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  'Total',
                  totalAmount.toStringAsFixed(3),
                ]
              ],
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
  
  @override
  Widget build(BuildContext context) {
    ///get Customer
    final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo !=0).toList();
    final allCustomerPaymentData = Provider.of<CustomerPaymentsProvider>(context).customerPaymentsList;
    final totalAmount = allCustomerPaymentData.fold<double>(0.0, (sum, item) => sum + (double.tryParse(item.cPaymentAmount ?? "0") ?? 0.0));

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
                              return allCustomerData.where((element) =>
                                    element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
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
                          CustomerPaymentsProvider().on();
                          //String employeeIdToPass = (userType == "a" || userType == "m") ? "$_selectEmployeeId" : (userEmployeeID ?? "");
                          await Provider.of<CustomerPaymentsProvider>(context, listen: false).getCustomerPayments(
                            context,
                            _selectCustomerId??"",
                            paymentStatus,
                            "",
                            backEndFirstDate,
                            backEndSecondtDate
                          );
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
            // Action Buttons (Print & Excel)
            allCustomerPaymentData.isEmpty ? SizedBox(height: 0.w) : Padding(
              padding: EdgeInsets.only(top: 5.0.h, left: 10.0.w, right: 5.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                        _printCustomerPaymentData(allCustomerPaymentData, totalAmount);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
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
                ],
              ),
            ), 
            SizedBox(height: 3.h),
            Expanded(
              flex: 3,
              child: CustomerPaymentsProvider.isCustomerPaymentsLoading
              ? const Center(child: CircularProgressIndicator())
              : allCustomerPaymentData.isNotEmpty
              ? Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.31,
                  width: double.infinity,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.only(left: 5.w,right: 5.w,bottom: 10.h),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                headingRowHeight: 20.h,
                                // ignore: deprecated_member_use
                                dataRowHeight: 20.h,
                                headingRowColor:WidgetStateColor.resolveWith((states) => AppColors.appColor),
                                showCheckboxColumn: true,
                                border: TableBorder.all(color: Colors.black54,width: 1.w),
                                columns: [
                                  DataColumn(label: Expanded(child: Center(child: Text('Transaction Id',style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Customer',style:AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Transaction Type',style:AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Payment by',style:AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Description',style:AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Amount',style:AllTextStyle.tableHeadTextStyle)))),
                             
                                ],
                                rows: [
                                  ...List.generate(
                                    allCustomerPaymentData.length,
                                    (int index) => DataRow(
                                      color:index % 2 == 0? WidgetStateProperty.resolveWith(AppColors.getColors): WidgetStateProperty.resolveWith(AppColors.getAll),
                                      cells: <DataCell>[
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].cPaymentInvoice.toString()))),
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].saleMasterInvoiceNo??""))),
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].cPaymentDate.toString()))),
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].customerName.toString()))),
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].transactionType.toString()))),
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].paymentBy.toString()))),
                                        DataCell(Center(child: Text(allCustomerPaymentData[index].cPaymentNotes.toString()))),
                                        DataCell(Center(child: Text(double.parse(allCustomerPaymentData[index].cPaymentAmount.toString()).toStringAsFixed(2)))),
                                      ],
                                    ),
                                  ),
                                  DataRow(
                                    cells: [
                                      DataCell(SizedBox()),
                                      DataCell(SizedBox()),
                                      DataCell(SizedBox()),
                                      DataCell(SizedBox()),
                                      DataCell(SizedBox()),
                                      DataCell(SizedBox()),
                                      DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataCell(Center(child: Text(totalAmount.toStringAsFixed(3),style: TextStyle(fontWeight: FontWeight.bold),
                                      ))),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            ), 
          ],
        ),
      ),
    );
  }
}
