
import 'dart:io';
import 'dart:typed_data';

import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/common_widget/commontype_aheadfield.dart';
import 'package:barishal_surgical/common_widget/custom_appbar.dart';
import 'package:barishal_surgical/models/administration_module_models/areas_model.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/models/sales_module_models/invoice_due_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/areas_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_list_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/customer_due_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/invoice_due_provider.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDueListScreen extends StatefulWidget {
  const CustomerDueListScreen({super.key});
  @override
  State<CustomerDueListScreen> createState() => _CustomerDueListScreenState();
}
class _CustomerDueListScreenState extends State<CustomerDueListScreen> {
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

  //main dropdowns logic
  bool isAll = true;
  bool isAreas = false;
  bool isCustomers = false;
  bool isInvoices = false;
  bool _isDropdownOpen = false;
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Customer',
    'By Area',
    'By Invoice'
  ];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final GlobalKey _key = GlobalKey();
  Size _dropdownSize = Size.zero;

  void _getDropdownSize(Duration _) {
    final RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    _dropdownSize = renderBox.size;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }
  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: _dropdownSize.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, _dropdownSize.height + 0),
                child: Material(
                  elevation: 9.0,
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(5.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _searchTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final type = entry.value;
                      return InkWell(
                        onTap: () {
                          _onSelectedType(type);
                          _removeDropdown();
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              child: Text(type, style: TextStyle(fontSize: 13.sp)),
                            ),
                            if (index != _searchTypes.length - 1)
                              Divider(height: 1.h, thickness: 0.8, color: Colors.indigo.shade400),
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

  void _onSelectedType(String selectedValue) {  
    setState(() {
      _selectedSearchTypes = selectedValue;
      isAll = selectedValue == "All";
      isCustomers = selectedValue == "By Customer";
      isAreas = selectedValue == "By Area";
      isInvoices = selectedValue == "By Invoice";
      emtyMethod();
    });
  }

  String? customerId;
  String? areaId;
  String? invoiceId;
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

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_company_profile-------Company_Name======$companyName");
    print("get_company_profile-------Company_Name======$repotHeading");
    print("get_company_profile-------dueStatus======$dueStatus");
    print("get_company_profile-------invoiceNote======$invoiceNote");
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

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_current_branch-------Branch_header======$headerImg");
    print("get_current_branch-------Branch_footer======$footerImg");
  }

  @override
  void initState() {
    getCompanyProfile();
    getCurrentBranch();
    _initLocation();
    WidgetsBinding.instance.addPostFrameCallback(_getDropdownSize);
    _initializeData();
    Provider.of<AreasProvider>(context, listen: false).getAreas(context);
    Provider.of<CustomerDueProvider>(context, listen: false).customerDuelist = [];
    Provider.of<InvoiceDueProvider>(context, listen: false).invoiceDueList = [];
    _loadCustomerData();
    super.initState();
    print("myAddress=======$myAddress");
  }
  var customerController = TextEditingController();
  var areaController = TextEditingController();
  var invoiceController = TextEditingController();
  emtyMethod() {
    setState(() {
      customerController.text= "";
      areaController.text= "";
      invoiceController.text= "";
      customerId = "";
      areaId = "";
      invoiceId = "";
    });
  }

   // ইমেজ ফেচ করার জন্য উন্নত ফাংশন
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

 // --- Actual PDF Print Function for Customer Due List ---
  Future<void> _printCustomerDueList(List allCustomerDueData, double totalDue) async {
    final pdf = pw.Document();
    String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());
    
    // Load Unicode compatible font from Google Fonts
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
      
    // Optional: Header image fetch (jodi thake)
    final Uint8List? netHeader = await _fetchImage("$imageBaseUrl$headerImg");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(2), // Margin ektuadjust kore dilam for better look
        build: (pw.Context context) {
          return [
            // Date & Time
            pw.Text(currentDateTime, style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic, font: font)),
            pw.SizedBox(height: 5),
            
            //Header Image (Jodi thake)
            if (netHeader != null) 
            pw.Center(child: pw.Image(pw.MemoryImage(netHeader), height: 80, width: 500)),
            pw.SizedBox(height: 10),

            // Data Table
            pw.Table.fromTextArray(
              headers: ['Customer Id', 'Customer Name', 'Owner Name', 'Address', 'Mobile', 'Due Amount'],
              data: [
                ...List.generate(allCustomerDueData.length, (index) {
                  final item = allCustomerDueData[index];
                  return [
                    //'${index + 1}',
                    item.customerCode ?? '',
                    item.customerName ?? '',
                    item.ownerName ?? '',
                    item.customerAddress ?? '',
                    item.customerMobile ?? '',
                    item.dueAmount ?? '0',
                  ];
                }),
                // Total Row inside PDF table
                [
                  //'',
                  '',
                  '',
                  '',
                  '',
                  'TOTAL DUE',
                  totalDue.toStringAsFixed(3),
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


  // --- Customer Due List Excel Export Function ---
  Future<void> _downloadCustomerDueExcel(List allCustomerDueData, double totalDue) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Exporting Excel..."),
          ],
        ),
      ),
    );

    try {
      final excel = ex.Excel.createExcel();
      final sheet = excel['Customer Due List'];
      excel.setDefaultSheet('Customer Due List');

      // HEADER ROW
      sheet.appendRow([
       // ex.TextCellValue('Sl.'),
        ex.TextCellValue('Customer Id'),
        ex.TextCellValue('Customer Name'),
        ex.TextCellValue('Owner Name'),
        ex.TextCellValue('Address'),
        ex.TextCellValue('Customer Mobile'),
        ex.TextCellValue('Due Amount'),
      ]);

      // DATA ROWS
      for (int i = 0; i < allCustomerDueData.length; i++) {
        final item = allCustomerDueData[i];

        sheet.appendRow([
          // ex.IntCellValue(i + 1),
          ex.TextCellValue(item.customerCode ?? ''),
          ex.TextCellValue(item.customerName ?? ''),
          ex.TextCellValue(item.ownerName ?? ''),
          ex.TextCellValue(item.customerAddress ?? ''),
          ex.TextCellValue(item.customerMobile ?? ''),
          ex.DoubleCellValue(double.tryParse(item.dueAmount.toString()) ?? 0.0),
        ]);
      }

      // TOTAL ROW
      sheet.appendRow([
        //ex.TextCellValue(''),
        ex.TextCellValue(''),
        ex.TextCellValue(''),
        ex.TextCellValue(''),
        ex.TextCellValue(''),
        ex.TextCellValue('TOTAL DUE'),
        ex.DoubleCellValue(totalDue),
      ]);

      final bytes = excel.encode();

      if (bytes == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Excel generate failed")),
        );
        return;
      }

      // SAVE LOCATION (DOWNLOADS FOLDER)
      Directory directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = "${directory.path}/Customer_Due_List_${DateTime.now().millisecondsSinceEpoch}.xlsx";

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Excel Export Successful (Saved in Downloads)"),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: "OPEN",
            textColor: Colors.white,
            onPressed: () async {
              await OpenFile.open(filePath);
            },
          ),
        ),
      );

      await OpenFile.open(filePath);
      print("Saved at: $filePath");

    } catch (e) {
      Navigator.pop(context); // Close loading dialog if error occurs

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Export Error: $e")),
      );

      print("Export Error => $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final allCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo!=0).toList();
    print("Customer length==============${allCustomersData.length}");
    final allInvoiceDueData = Provider.of<InvoiceDueProvider>(context).invoiceDueList;
    print("allInvoiceDueData========${allInvoiceDueData.length}");
    // final allCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo != 0).toList();
    final allAreasData = Provider.of<AreasProvider>(context).areasList;
    final providerCDueData = Provider.of<CustomerDueProvider>(context).customerDuelist;
    final allCustomerDueData = providerCDueData.where((item) {
      final due = double.tryParse(item.dueAmount ?? "0") ?? 0.0;
      return due != 0;
    }).toList();

    final totalDue = allCustomerDueData.fold<double>(0.0, (sum, item) => sum + (double.tryParse(item.dueAmount ?? "0") ?? 0.0));

    return Scaffold(
      appBar: CustomAppBar(title: "Customer Due List"),
      body: Container(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 6.0.h,bottom: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.0.r),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10.0.r),
                border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.6), spreadRadius: 2, blurRadius: 5.r, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Search Type", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: CompositedTransformTarget(
                        link: _layerLink,
                        child: GestureDetector(
                          onTap: _toggleDropdown,
                          child: Container(
                            key: _key,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            height: 25.h,
                            decoration: ContDecoration.contDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedSearchTypes ?? 'Please select a type',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                GestureDetector(
                                  onTap: _toggleDropdown,
                                  child: Icon(
                                    color: Colors.grey.shade700,
                                    _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  isAreas == true? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Area",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        height: 25.0.h,
                        decoration: ContDecoration.contDecoration,
                          child: CommonTypeAheadField<AreasModel>(
                          controller: areaController,
                          suggestionList: allAreasData,
                          hintText: 'Select Area',
                          selectedValueId: areaId,
                          onValueIdChanged: (id) {
                            setState(() {
                              areaId = id;
                            });
                          },
                          displayText: (a) => a.districtName,
                          valueId: (a) => a.districtSlNo.toString(),
                        ),
                      )
                    )
                    ],
                  ): Container(),
                  isCustomers == true
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        height: 25.0.h,
                        decoration: ContDecoration.contDecoration,
                          child: CommonTypeAheadField<CustomerListModel>(
                          controller: customerController,
                          suggestionList: allCustomersData,
                          hintText: 'Select Customer',
                          selectedValueId: customerId,
                          onValueIdChanged: (id) {
                            setState(() {
                              customerId = id;
                            });
                          },
                          displayText: (c) => c.displayName,
                          valueId: (c) => c.customerSlNo.toString(),
                        ),
                      )
                    )
                    ],
                  ): Container(),
                  Column(
                    children: [
                    isInvoices == true? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        height: 25.0.h,
                        decoration: ContDecoration.contDecoration,
                          child:  TypeAheadField<CustomerListModel>(
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
                                  suffixIcon: customerId == '' || customerId == 'null' || customerId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        customerController.clear();
                                        controller.clear();
                                        customerId = null;
                                        invoiceController.clear();
                                        invoiceId = null;
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
                                return allCustomersData.where((element) =>
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
                                customerId = suggestion.customerSlNo.toString();
                              }); 
                             InvoiceDueProvider().on();
                             Provider.of<InvoiceDueProvider>(context, listen: false).getInvoiceDue(context, customerId); 
                            },
                          ),
                      )
                    )
                    ],
                  ): SizedBox(),
                  isInvoices == true? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 1, child: Text("Invoice",style:AllTextStyle.textFieldHeadStyle)),
                        Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                        Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          height: 25.0.h,
                          decoration: ContDecoration.contDecoration,
                            child: CommonTypeAheadField<InvoiceDueModel>(
                            controller: invoiceController,
                            suggestionList: allInvoiceDueData,
                            hintText: 'Select Invoice',
                            selectedValueId: invoiceId,
                            onValueIdChanged: (id) {
                              setState(() {
                                invoiceId = id;
                              });
                            },
                            displayText: (c) => c.saleMasterInvoiceNo,
                            valueId: (c) => c.saleMasterSlNo.toString(),
                          ),
                        )
                      )
                    ],
                  ): SizedBox(),]),
                  
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(1.0.r),
                      child: InkWell(
                        onTap: () async {
                          if (isAll) {
                            CustomerDueProvider().on();
                            Provider.of<CustomerDueProvider>(context, listen: false).getCustomerDue(context, "", "", "");
                            return;
                          }
                          if (isCustomers && (customerId == null || customerId!.isEmpty)) {
                            Utils.showTopSnackBar(context, "Please select customer");
                            return;
                          }
                          if (isAreas && (areaId == null || areaId!.isEmpty)) {
                            Utils.showTopSnackBar(context, "Please Select Area");
                            return;
                          }
                          if (isInvoices && (invoiceId == null || invoiceId!.isEmpty)) {
                            Utils.showTopSnackBar(context, "Please Select Invoice");
                            return;
                          }
                          CustomerDueProvider().on();
                          Provider.of<CustomerDueProvider>(context, listen: false).getCustomerDue(context, customerId ?? "", areaId ?? "", invoiceId ?? "");
                         print("customerId====$customerId===areaId====$areaId====invoiceId====$invoiceId");
                        },
                        
                        child: Container(
                          height: 28.0.h,
                          width: 102.0.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5.0.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5.r,
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
            // Action Buttons (Print & Excel)
            allCustomerDueData.isEmpty ? SizedBox(height: 0.w) : Padding(
              padding: EdgeInsets.only(top: 5.0.h, left: 10.0.w, right: 5.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                        _printCustomerDueList(allCustomerDueData, totalDue);
                    },
                    child: Card(
                      elevation: 5,
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
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      _downloadCustomerDueExcel(allCustomerDueData, totalDue);
                    },
                    child: Card(
                      elevation: 5,    
                      color: Colors.green.shade700,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.0.h),
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 16.0.r, color: Colors.white),
                            Text("Excel",style: TextStyle(color: Colors.white, fontSize: 14.0.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            CustomerDueProvider.isCustomerDueLoading ?
            const Center(child: CircularProgressIndicator(),)
           :allCustomerDueData.isNotEmpty? Expanded(child: Container(
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
                       headingRowColor: isAreas == true ? WidgetStateColor.resolveWith((states) => AppColors.isAreas):
                       isCustomers == true ? WidgetStateColor.resolveWith((states) => AppColors.isCustomers):
                       WidgetStateColor.resolveWith((states) => AppColors.appColor),
                       showCheckboxColumn: true,
                       border: TableBorder.all(color: Colors.black54, width: 1.w),
                       columns: [
                         //DataColumn(label: Expanded(child: Center(child: Text('Sl',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Owner Name',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Address',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Customer Mobile',style:AllTextStyle.tableHeadTextStyle)))),
                         DataColumn(label: Expanded(child: Center(child: Text('Due Amount',style:AllTextStyle.tableHeadTextStyle)))),
                        ],
                      
                       rows: [
                        ...List.generate(
                          allCustomerDueData.length,
                          (int index) => DataRow(
                             color: 
                            isAreas == true
                                ? index % 2 == 0
                                    ? WidgetStateProperty.resolveWith(AppColors.getColors)
                                    : WidgetStateProperty.resolveWith(AppColors.getArea)
                                : isCustomers == true
                                    ? index % 2 == 0
                                        ? WidgetStateProperty.resolveWith(AppColors.getColors)
                                        : WidgetStateProperty.resolveWith(AppColors.getCustomer)
                                : index % 2 == 0
                                  ? WidgetStateProperty.resolveWith(AppColors.getColors)
                                  : WidgetStateProperty.resolveWith(AppColors.getAll),
                            cells: <DataCell>[
                              //DataCell(Center(child: Text("${index + 1}"))),
                              DataCell(Center(child: Text(allCustomerDueData[index].customerCode ?? ""))),
                              DataCell(Center(child: Text(allCustomerDueData[index].customerName ?? ""))),
                              DataCell(Center(child: Text(allCustomerDueData[index].ownerName ?? ""))),
                              DataCell(Center(child: Text(allCustomerDueData[index].customerAddress ?? ""))),
                              DataCell(Center(child: Text(allCustomerDueData[index].customerMobile ?? ""))),
                              DataCell(Center(child: Text(allCustomerDueData[index].dueAmount ?? ""))),
                            ],
                          ),
                        ),
                        DataRow(
                          cells: [
                            //DataCell(SizedBox()),
                            DataCell(SizedBox()),
                            DataCell(SizedBox()),
                            DataCell(SizedBox()),
                            DataCell(SizedBox()),
                            DataCell(Center(child: Text("Total Due", style: TextStyle(fontWeight: FontWeight.bold)))),
                            DataCell(Center(child: Text(totalDue.toStringAsFixed(3),style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                          ],
                        ),
                      ],
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
}
