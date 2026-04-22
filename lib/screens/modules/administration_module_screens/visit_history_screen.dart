
import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_list_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/employees_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/visits_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/utils.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  Color getColor(Set<WidgetState> states) {return Colors.teal.shade100;}
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
  
  String? userEmployeeId = "";
  String? userEmployeeName = "";
  String userName = "";
  String userType = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userEmployeeName = "${sharedPreferences?.getString('employeeName')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
  }
  String? customerId = '';
  String? employeeId = "";
  bool isAll = true;
  bool isEmployeeListClicked = false;
  bool isCustomerListClicked = false;
  bool _isDropdownOpen = false;
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Customer',
    'By Employee',
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
      isCustomerListClicked = selectedValue == "By Customer";
      isEmployeeListClicked = selectedValue == "By Employee";
      emtyMethod();
    });
  }

   emtyMethod() {
    setState(() {
      customerController.text= "";
      _employeeController.text= "";
      customerId = "";
      employeeId = "";
    });
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

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback(_getDropdownSize);
    _initLocation();
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"","");
    Provider.of<VisitsProvider>(context, listen: false).visitsList = [];
    // TODO: implement initState
    super.initState();
  }
  var customerController = TextEditingController();
  final _employeeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allEmployeeData = Provider.of<EmployeesProvider>(context).employeesList;
    //Get customers
    final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerCode != "").toList();
    print("allCustomerData====${allCustomerData.length}");
    //get Visits
    final allVisitsData = Provider.of<VisitsProvider>(context).visitsList;
    print("Get allVisitsData length=====> ${allVisitsData.length} ");
    return Scaffold(
      appBar: CustomAppBar(title: "Visit List"),
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
                      Expanded(flex: 4, child: Text("Search Type", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 8,
                        child: CompositedTransformTarget(
                        link: _layerLink,
                        child: GestureDetector(
                          onTap: _toggleDropdown,
                          child: Container(
                            key: _key,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            margin: EdgeInsets.only(top: 3.0.h),
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
                  SizedBox(height: 3.0.h),
                  isCustomerListClicked == true ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 4, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                          Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                          Expanded(
                            flex: 8,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5.w),
                              height: 25.0.h,
                              decoration: ContDecoration.contDecoration,
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
                                      suffixIcon: customerId == '' || customerId == 'null' || customerId == null || controller.text == '' ? null
                                          : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            customerController.clear();
                                            controller.clear();
                                            customerId = null;
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
                                        element.customerName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                  });
                                },
                                itemBuilder: (context, CustomerListModel suggestion) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                    child: Text(suggestion.customerName!,
                                      style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                                onSelected: (CustomerListModel suggestion) {
                                  setState(() {
                                    customerController.text = suggestion.customerName!;
                                    customerId = suggestion.customerSlNo.toString();
                                  });
                                },
                              ),
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
                          Expanded(flex: 4, child: Text("Employee",style:AllTextStyle.textFieldHeadStyle)),
                          Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                          userName == "Admin"? Expanded(
                            flex: 8,
                            child: Container(
                              height: 25.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              margin: EdgeInsets.only(bottom: 5.0.h),
                              decoration: ContDecoration.contDecoration,
                              child: TypeAheadField<EmployeesModel>(
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
                                    _employeeController.text = suggestion.displayName!;
                                    employeeId = suggestion.employeeSlNo.toString();
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
                                child: Text(userEmployeeName!,style: AllTextStyle.textValueStyle)
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
                              VisitsProvider().on();
                              Provider.of<VisitsProvider>(context, listen: false).getVisits(context,
                                customerId ?? '',
                                userType == "m"||userType == "a" ? employeeId : userEmployeeId,
                                "$backEndFirstDate",
                                "$backEndSecondtDate",
                              );
                              print("customerId=====> $customerId");
                              print("employeeId=====> ${userType == "m"||userType == "a" ? employeeId : userEmployeeId}");
                              print("backEndFirstDate=====> $backEndFirstDate");  
                              print("backEndSecondtDate=====> $backEndSecondtDate");
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
          VisitsProvider.isVisitsLoading ?
          const Center(child: CircularProgressIndicator(),)
              :allVisitsData.isNotEmpty? Expanded(child: Container(
            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      headingRowHeight: 20.h,
                      dataRowHeight: 20.h,
                      headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Sl.',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Date',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Employee',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Location',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Latitude',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Longitude',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Remark',style: AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows: List.generate(
                       allVisitsData.length,
                            (int index) => DataRow(
                          color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
                          cells: <DataCell>[
                            DataCell(Center(child: Text('${index +1}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].date??""}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].employeeName??""}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].customerName??""}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].location??""}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].latitude??""}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].longitude??""}'))),
                            DataCell(Center(child: Text('${allVisitsData[index].remark??""}'))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))),
          
        ],
      ),
    );
  }
}
