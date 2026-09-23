import 'dart:typed_data';

import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/models/sales_module_models/emp_wise_cus_pay_due_model.dart';
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
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
                offset: Offset(0.0, _searchDropdownSize.height + 5), 
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
      emtyMethod();
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
                              child: Text(
                                type,style: TextStyle(fontSize: 12.sp), 
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
       if (userType == "a" || userType == "m") {
      } else {
        employeeController.text = userEmployeeName ?? "";
      }
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

Future<void> _generatePDF() async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final allEmpWiseCusPayDueData = Provider.of<EmpWiseCusPayDueProvider>(context, listen: false).empWiseCusPayDuelist;
    
    if (allEmpWiseCusPayDueData.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to generate PDF')));
      return;
    }

    // Build table data
    final tableData = _buildTableDataForExport(allEmpWiseCusPayDueData);
    final pdf = pw.Document();
    String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final Uint8List? netHeader = await _fetchImage("$imageBaseUrl$headerImg");
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(2.r),
        build: (pw.Context context) {
          return [
            pw.Text(currentDateTime, style: pw.TextStyle(fontSize: 8.sp, fontStyle: pw.FontStyle.italic, font: font)),
            pw.SizedBox(height: 5.h),
            if (netHeader != null) 
            pw.Center(child: pw.Image(pw.MemoryImage(netHeader), height: 80.h, width: 500.w)),
            pw.SizedBox(height: 10.h),
            pw.Divider(height: 1,thickness: 1, color: PdfColors.black),
            pw.SizedBox(height: 3.h),
            pw.Divider(height: 1,thickness: 1, color: PdfColors.black),
            pw.SizedBox(height: 10.h),
            // Header
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(
                children: [
                  pw.Text(
                    'Customer Payment Due Report',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Statement: "$firstPickedDate" to "$secondPickedDate"',
                    style: pw.TextStyle(fontSize: 9,font: fontBold),
                  ),
                  pw.SizedBox(height: 8),
                ],
              ),
            ),
            
            // Table
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: _buildPdfRows(tableData),
            ),
            
            // Signature Section
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('_______________________'),
                    pw.Text('Manager Signature', style: pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('_______________________'),
                    pw.Text('Authorized Signature', style: pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    // Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/customer_payment_due_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    // Close loading dialog
    Navigator.pop(context);
    
    // Show success dialog with options
    _showPrintOptionsDialog(context, file.path);
    
  } catch (e) {
    // Close loading dialog if open
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error generating PDF: $e')),
    );
  }
}

// Show print options dialog
void _showPrintOptionsDialog(BuildContext context, String filePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('PDF Generated Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 10),
            Text(
              'PDF file has been generated successfully!',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              'File saved at: ${filePath.split('/').last}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          // Print Button
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                final file = File(filePath);
                await Printing.sharePdf(
                  bytes: await file.readAsBytes(),
                  filename: filePath.split('/').last,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error printing: $e')),
                );
              }
            },
            icon: const Icon(Icons.print, color: Colors.blue),
            label: const Text('Print / Share'),
          ),
          
          // Share Button
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await Share.shareXFiles(
                  [XFile(filePath)],
                  text: 'Customer Payment Due Report',
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error sharing: $e')),
                );
              }
            },
            icon: const Icon(Icons.share, color: Colors.green),
            label: const Text('Share'),
          ),
          
          // Close Button
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

// Helper method to parse double safely
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// Helper method to build table data for export
List<Map<String, dynamic>> _buildTableDataForExport(List<EmpWiseCusPayDueModel> data) {
  List<Map<String, dynamic>> tableData = [];
  String currentEmployee = "";
  String currentCustomer = "";
  int serial = 0;

  // Employee totals
  double empInvoiceAmount = 0, empDiscount = 0, empVat = 0, empTrCost = 0;
  double empReturned = 0, empNetPayable = 0, empPaid = 0;
  double empInvoiceDue = 0, empPreviousDue = 0, empTotalDue = 0;

  // Customer totals
  double cusInvoiceAmount = 0, cusDiscount = 0, cusVat = 0, cusTrCost = 0;
  double cusReturned = 0, cusNetPayable = 0, cusPaid = 0;
  double cusInvoiceDue = 0, cusPreviousDue = 0, cusTotalDue = 0;

  for (int i = 0; i < data.length; i++) {
    var item = data[i];

    // Employee change
    if (currentEmployee != (item.employeeName ?? "")) {
      // Add customer subtotal
      if (currentCustomer.isNotEmpty) {
        tableData.add({
          'isSubtotal': true,
          'isCustomer': true,
          'customerName': currentCustomer,
          'subTotal': cusInvoiceAmount,
          'discount': cusDiscount,
          'vat': cusVat,
          'transport': cusTrCost,
          'returned': cusReturned,
          'bill': cusNetPayable,
          'paid': cusPaid,
          'invoiceDue': cusInvoiceDue,
          'previousDue': cusPreviousDue,
          'due': cusTotalDue,
        });
      }

      // Add employee subtotal
      if (currentEmployee.isNotEmpty) {
        tableData.add({
          'isSubtotal': true,
          'isEmployee': true,
          'employeeName': currentEmployee,
          'subTotal': empInvoiceAmount,
          'discount': empDiscount,
          'vat': empVat,
          'transport': empTrCost,
          'returned': empReturned,
          'bill': empNetPayable,
          'paid': empPaid,
          'invoiceDue': empInvoiceDue,
          'previousDue': empPreviousDue,
          'due': empTotalDue,
        });
      }

      currentEmployee = item.employeeName ?? "";
      currentCustomer = "";
      serial = 0;

      // Reset employee totals
      empInvoiceAmount = empDiscount = empVat = empTrCost = 0;
      empReturned = empNetPayable = empPaid = 0;
      empInvoiceDue = empPreviousDue = empTotalDue = 0;

      // Add employee header
      tableData.add({
        'isHeader': true,
        'isEmployeeHeader': true,
        'employeeName': currentEmployee,
      });
    }

    // Customer change
    if (currentCustomer != (item.customerName ?? "")) {
      // Add customer subtotal
      if (currentCustomer.isNotEmpty) {
        tableData.add({
          'isSubtotal': true,
          'isCustomer': true,
          'customerName': currentCustomer,
          'subTotal': cusInvoiceAmount,
          'discount': cusDiscount,
          'vat': cusVat,
          'transport': cusTrCost,
          'returned': cusReturned,
          'bill': cusNetPayable,
          'paid': cusPaid,
          'invoiceDue': cusInvoiceDue,
          'previousDue': cusPreviousDue,
          'due': cusTotalDue,
        });
      }

      currentCustomer = item.customerName ?? "";
      serial = 0;

      // Reset customer totals
      cusInvoiceAmount = cusDiscount = cusVat = cusTrCost = 0;
      cusReturned = cusNetPayable = cusPaid = 0;
      cusInvoiceDue = cusPreviousDue = cusTotalDue = 0;
    }

    serial++;

    // Add data row
    double subTotal = _parseDouble(item.subTotal);
    double discount = _parseDouble(item.discount);
    double vat = _parseDouble(item.vat);
    double transport = _parseDouble(item.transport);
    double returned = _parseDouble(item.returned);
    double bill = _parseDouble(item.bill);
    double paid = _parseDouble(item.paid);
    double invoiceDue = _parseDouble(item.invoiceDue);
    double previousDue = _parseDouble(item.previousDue);
    double due = _parseDouble(item.due);

    tableData.add({
      'slNo': serial,
      'date': item.date ?? '',
      'invoiceNo': item.invoiceNo ?? '',
      'comment': item.comment ?? '',
      'customerName': item.customerName ?? '',
      'subTotal': subTotal,
      'discount': discount,
      'vat': vat,
      'transport': transport,
      'returned': returned,
      'bill': bill,
      'paid': paid,
      'invoiceDue': invoiceDue,
      'previousDue': previousDue,
      'due': due,
    });

    // Update totals
    cusInvoiceAmount += subTotal;
    cusDiscount += discount;
    cusVat += vat;
    cusTrCost += transport;
    cusReturned += returned;
    cusNetPayable += bill;
    cusPaid += paid;
    cusInvoiceDue += invoiceDue;
    cusPreviousDue += previousDue;
    cusTotalDue += due;

    empInvoiceAmount += subTotal;
    empDiscount += discount;
    empVat += vat;
    empTrCost += transport;
    empReturned += returned;
    empNetPayable += bill;
    empPaid += paid;
    empInvoiceDue += invoiceDue;
    empPreviousDue += previousDue;
    empTotalDue += due;
  }

  // Add final customer subtotal
  if (currentCustomer.isNotEmpty) {
    tableData.add({
      'isSubtotal': true,
      'isCustomer': true,
      'customerName': currentCustomer,
      'subTotal': cusInvoiceAmount,
      'discount': cusDiscount,
      'vat': cusVat,
      'transport': cusTrCost,
      'returned': cusReturned,
      'bill': cusNetPayable,
      'paid': cusPaid,
      'invoiceDue': cusInvoiceDue,
      'previousDue': cusPreviousDue,
      'due': cusTotalDue,
    });
  }

  // Add final employee subtotal
  if (currentEmployee.isNotEmpty) {
    tableData.add({
      'isSubtotal': true,
      'isEmployee': true,
      'employeeName': currentEmployee,
      'subTotal': empInvoiceAmount,
      'discount': empDiscount,
      'vat': empVat,
      'transport': empTrCost,
      'returned': empReturned,
      'bill': empNetPayable,
      'paid': empPaid,
      'invoiceDue': empInvoiceDue,
      'previousDue': empPreviousDue,
      'due': empTotalDue,
    });
  }

  return tableData;
}

// Helper method to build PDF rows
List<pw.TableRow> _buildPdfRows(List<Map<String, dynamic>> tableData) {
  List<pw.TableRow> rows = [];
  
  // Header
  rows.add(
    pw.TableRow(
      decoration: pw.BoxDecoration(
        color: PdfColors.blue,
      ),
      children: [
        _buildPdfCell('SL', isHeader: true),
        _buildPdfCell('Invoice Date', isHeader: true),
        _buildPdfCell('Invoice No', isHeader: true),
        _buildPdfCell('Comments', isHeader: true),
        _buildPdfCell('Customer Name', isHeader: true),
        _buildPdfCell('Inv. Amount', isHeader: true),
        _buildPdfCell('Discount', isHeader: true),
        _buildPdfCell('VAT', isHeader: true),
        _buildPdfCell('Transport', isHeader: true),
        _buildPdfCell('Return', isHeader: true),
        _buildPdfCell('Net Payable', isHeader: true),
        _buildPdfCell('Paid', isHeader: true),
        _buildPdfCell('Inv. Due', isHeader: true),
        _buildPdfCell('Prev. Due', isHeader: true),
        _buildPdfCell('Total Due', isHeader: true),
      ],
    ),
  );

  // Process all rows
  for (int i = 0; i < tableData.length; i++) {
    final data = tableData[i];
    
    // Check if it's a header
    if (data['isHeader'] == true && data['isEmployeeHeader'] == true) {
      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          children: [
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell(
              'Employee Name: ${data['employeeName']}', 
              isBold: true, 
              color: PdfColors.green,
            ),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
            _buildPdfCell('', isBold: true, color: PdfColors.green),
          ],
        ),
      );
      continue;
    }
    
    // Check if it's a subtotal
    if (data['isSubtotal'] == true) {
      String label = '';
      if (data['isEmployee'] == true) {
        label = 'Sub Total (${data['employeeName']}):';
      } else if (data['isCustomer'] == true) {
        label = 'Sub Total (${data['customerName']}):';
      }
      
      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: data['isEmployee'] == true ? PdfColors.grey300 : PdfColors.grey200,
          ),
          children: [
            _buildPdfCell('', isBold: true),
            _buildPdfCell('', isBold: true),
            _buildPdfCell('', isBold: true),
            _buildPdfCell('', isBold: true),
            _buildPdfCell(label, isBold: true),
            _buildPdfCell((data['subTotal'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['discount'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['vat'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['transport'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['returned'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['bill'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['paid'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['invoiceDue'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['previousDue'] ?? 0).toStringAsFixed(2), isBold: true),
            _buildPdfCell((data['due'] ?? 0).toStringAsFixed(2), isBold: true),
          ],
        ),
      );
      continue;
    }
    
    // Regular data row
    final color = i % 2 == 0 ? PdfColors.grey100 : PdfColors.white;
    rows.add(
      pw.TableRow(
        decoration: pw.BoxDecoration(
          color: color,
        ),
        children: [
          _buildPdfCell('${data['slNo']}'),
          _buildPdfCell(data['date'].toString()),
          _buildPdfCell(data['invoiceNo'].toString()),
          _buildPdfCell(data['comment'].toString()),
          _buildPdfCell(data['customerName'].toString()),
          _buildPdfCell((data['subTotal'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['discount'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['vat'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['transport'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['returned'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['bill'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['paid'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['invoiceDue'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['previousDue'] ?? 0).toStringAsFixed(2)),
          _buildPdfCell((data['due'] ?? 0).toStringAsFixed(2)),
        ],
      ),
    );
  }

  // Add Grand Total Row (like a data row)
  final grandTotalData = _getGrandTotalData(tableData);
  rows.add(
    pw.TableRow(
      decoration: pw.BoxDecoration(
        color: PdfColors.green700,
      ),
      children: [
        _buildPdfCell('', isBold: true, color: PdfColors.white),
        _buildPdfCell('', isBold: true, color: PdfColors.white),
        _buildPdfCell('', isBold: true, color: PdfColors.white),
        _buildPdfCell('', isBold: true, color: PdfColors.white),
        _buildPdfCell('GRAND TOTAL', isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['subTotal']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['discount']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['vat']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['transport']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['returned']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['bill']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['paid']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['invoiceDue']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['previousDue']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
        _buildPdfCell(grandTotalData['due']!.toStringAsFixed(2), isBold: true, color: PdfColors.white),
      ],
    ),
  );
  
  return rows;
}

// Helper method to get grand total data
Map<String, double> _getGrandTotalData(List<Map<String, dynamic>> tableData) {
  double totalSubTotal = 0;
  double totalDiscount = 0;
  double totalVat = 0;
  double totalTransport = 0;
  double totalReturned = 0;
  double totalNetPayable = 0;
  double totalPaid = 0;
  double totalInvoiceDue = 0;
  double totalPreviousDue = 0;
  double totalDue = 0;

  for (var data in tableData) {
    // Skip header rows and subtotal rows for grand total calculation
    if (data['isHeader'] == true || data['isSubtotal'] == true) continue;
    
    totalSubTotal += (data['subTotal'] ?? 0);
    totalDiscount += (data['discount'] ?? 0);
    totalVat += (data['vat'] ?? 0);
    totalTransport += (data['transport'] ?? 0);
    totalReturned += (data['returned'] ?? 0);
    totalNetPayable += (data['bill'] ?? 0);
    totalPaid += (data['paid'] ?? 0);
    totalInvoiceDue += (data['invoiceDue'] ?? 0);
    totalPreviousDue += (data['previousDue'] ?? 0);
    totalDue += (data['due'] ?? 0);
  }
  
  return {
    'subTotal': totalSubTotal,
    'discount': totalDiscount,
    'vat': totalVat,
    'transport': totalTransport,
    'returned': totalReturned,
    'bill': totalNetPayable,
    'paid': totalPaid,
    'invoiceDue': totalInvoiceDue,
    'previousDue': totalPreviousDue,
    'due': totalDue,
  };
}

// Update _buildPdfCell to support custom color
pw.Widget _buildPdfCell(String text, {bool isHeader = false, bool isBold = false, PdfColor? color}) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(3),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: isHeader ? 8 : 7,
        fontWeight: isBold || isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: color ?? (isHeader ? PdfColors.white : PdfColors.black),
      ),
    ),
  );
}

// // Helper method to build PDF rows
// List<pw.TableRow> _buildPdfRows(List<Map<String, dynamic>> tableData) {
//   List<pw.TableRow> rows = [];
  
//   // Header
//   rows.add(
//     pw.TableRow(
//       decoration: pw.BoxDecoration(
//         color: PdfColors.blue,
//       ),
//       children: [
//         _buildPdfCell('SL', isHeader: true),
//         _buildPdfCell('Invoice Date', isHeader: true),
//         _buildPdfCell('Invoice No', isHeader: true),
//         _buildPdfCell('Comments', isHeader: true),
//         _buildPdfCell('Customer Name', isHeader: true),
//         _buildPdfCell('Inv. Amount', isHeader: true),
//         _buildPdfCell('Discount', isHeader: true),
//         _buildPdfCell('VAT', isHeader: true),
//         _buildPdfCell('Transport', isHeader: true),
//         _buildPdfCell('Return', isHeader: true),
//         _buildPdfCell('Net Payable', isHeader: true),
//         _buildPdfCell('Paid', isHeader: true),
//         _buildPdfCell('Inv. Due', isHeader: true),
//         _buildPdfCell('Prev. Due', isHeader: true),
//         _buildPdfCell('Total Due', isHeader: true),
//       ],
//     ),
//   );

//   // Process all rows
//   for (int i = 0; i < tableData.length; i++) {
//     final data = tableData[i];
    
//     // Check if it's a header
//     if (data['isHeader'] == true && data['isEmployeeHeader'] == true) {
//       rows.add(
//         pw.TableRow(
//           decoration: pw.BoxDecoration(
//             color: PdfColors.grey300,
//           ),
//           children: [
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell(
//               'Employee Name: ${data['employeeName']}', 
//               isBold: true, 
//               color: PdfColors.green,
//             ),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//             _buildPdfCell('', isBold: true, color: PdfColors.green),
//           ],
//         ),
//       );
//       continue;
//     }
    
//     // Check if it's a subtotal
//     if (data['isSubtotal'] == true) {
//       String label = '';
//       if (data['isEmployee'] == true) {
//         label = 'Sub Total (${data['employeeName']}):';
//       } else if (data['isCustomer'] == true) {
//         label = 'Sub Total (${data['customerName']}):';
//       }
      
//       rows.add(
//         pw.TableRow(
//           decoration: pw.BoxDecoration(
//             color: data['isEmployee'] == true ? PdfColors.grey300 : PdfColors.grey200,
//           ),
//           children: [
//             _buildPdfCell('', isBold: true),
//             _buildPdfCell('', isBold: true),
//             _buildPdfCell('', isBold: true),
//             _buildPdfCell('', isBold: true),
//             _buildPdfCell(label, isBold: true),
//             _buildPdfCell((data['subTotal'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['discount'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['vat'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['transport'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['returned'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['bill'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['paid'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['invoiceDue'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['previousDue'] ?? 0).toStringAsFixed(2), isBold: true),
//             _buildPdfCell((data['due'] ?? 0).toStringAsFixed(2), isBold: true),
//           ],
//         ),
//       );
//       continue;
//     }
    
//     // Regular data row
//     final color = i % 2 == 0 ? PdfColors.grey100 : PdfColors.white;
//     rows.add(
//       pw.TableRow(
//         decoration: pw.BoxDecoration(
//           color: color,
//         ),
//         children: [
//           _buildPdfCell('${data['slNo']}'),
//           _buildPdfCell(data['date'].toString()),
//           _buildPdfCell(data['invoiceNo'].toString()),
//           _buildPdfCell(data['comment'].toString()),
//           _buildPdfCell(data['customerName'].toString()),
//           _buildPdfCell((data['subTotal'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['discount'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['vat'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['transport'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['returned'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['bill'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['paid'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['invoiceDue'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['previousDue'] ?? 0).toStringAsFixed(2)),
//           _buildPdfCell((data['due'] ?? 0).toStringAsFixed(2)),
//         ],
//       ),
//     );
//   }
  
//   return rows;
// }

// String _getGrandTotalRowForPDF(List<Map<String, dynamic>> tableData) {
//   double totalSubTotal = 0;
//   double totalDiscount = 0;
//   double totalVat = 0;
//   double totalTransport = 0;
//   double totalReturned = 0;
//   double totalNetPayable = 0;
//   double totalPaid = 0;
//   double totalInvoiceDue = 0;
//   double totalPreviousDue = 0;
//   double totalDue = 0;

//   for (var data in tableData) {
//     // Skip header rows and subtotal rows for grand total calculation
//     if (data['isHeader'] == true || data['isSubtotal'] == true) continue;
    
//     totalSubTotal += (data['subTotal'] ?? 0);
//     totalDiscount += (data['discount'] ?? 0);
//     totalVat += (data['vat'] ?? 0);
//     totalTransport += (data['transport'] ?? 0);
//     totalReturned += (data['returned'] ?? 0);
//     totalNetPayable += (data['bill'] ?? 0);
//     totalPaid += (data['paid'] ?? 0);
//     totalInvoiceDue += (data['invoiceDue'] ?? 0);
//     totalPreviousDue += (data['previousDue'] ?? 0);
//     totalDue += (data['due'] ?? 0);
//   }
  
//   return 'Grand Total: SubTotal: ${totalSubTotal.toStringAsFixed(2)} | Discount: ${totalDiscount.toStringAsFixed(2)} | VAT: ${totalVat.toStringAsFixed(2)} | Transport: ${totalTransport.toStringAsFixed(2)} | Return: ${totalReturned.toStringAsFixed(2)} | Net Payable: ${totalNetPayable.toStringAsFixed(2)} | Paid: ${totalPaid.toStringAsFixed(2)} | Invoice Due: ${totalInvoiceDue.toStringAsFixed(2)} | Previous Due: ${totalPreviousDue.toStringAsFixed(2)} | Total Due: ${totalDue.toStringAsFixed(2)}';
// }

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
                              return allGetEmployeesData.where((element) =>
                                    element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
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
                 isEmployeeWiseClicked == true ? Row(
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
                              return allCustomerData.where((element) => element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
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
                  ):SizedBox(height: 0.h),
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
                        },
                        child: Container(
                          height: 28.0.h,
                          width: 120.0.w,
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
            SizedBox(height: 10.w),
            if (allEmpWiseCusPayDueData.isNotEmpty) ...[
              SizedBox(width: 10.w),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _generatePDF,
                  child: Container(
                    height: 28.0.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade900,
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.white, size: 16.r),
                        SizedBox(width: 5.w),
                        Text("PDF", style: AllTextStyle.saveButtonTextStyle),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 5.h),
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
                        border: TableBorder.all(color: Colors.cyan.shade100, width: 1.w),

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
