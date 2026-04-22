library;
import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/common_widget/commontext_fieldrow.dart';
import 'package:barishal_surgical/common_widget/custom_appbar.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_list_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/employees_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/visits_provider.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/utils.dart';

class VisitEntryScreen extends StatefulWidget {
  const VisitEntryScreen({super.key,});
  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  Color getColor(Set<WidgetState> states) {
    return Colors.blue.shade200;
  }

  Color getColors(Set<WidgetState> states) {
    return Colors.white;
  }
  final _employeeController = TextEditingController();
  final _customerController = TextEditingController();
  final _remarkController = TextEditingController();
  final _locationController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userEmployeeName = "${sharedPreferences?.getString('employeeName')}";
    // employeeCode = "${sharedPreferences?.getString('employeeCode')}";
    // designationName = "${sharedPreferences?.getString('designationName')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
    print("userEmployeeName==== $userEmployeeName");
    print("userName==== $userName");
    print("userType==== $userType");
  }

  String? customerId;
  String? employeeId;
  String? userEmployeeId = "";
  String? userEmployeeName = "";
  // String? employeeCode = "";
  // String? designationName = "";
  String userName = "";
  String userType = "";


  //
  String? firstPickedDate;
  String? backEndFirstDate;
  bool isBtnLoading = false;

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

  
  Future<void> getCurrentLocation() async {
    // Permission check
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _latController.text = position.latitude.toString();
    _longController.text = position.longitude.toString();

    // Get address from lat long
    List<Placemark> placemarks =await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks.first;

    String fullAddress ="${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";

    _locationController.text = fullAddress;
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
    _initLocation();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    // TODO: implement initState
    super.initState();
    _initializeData();
    getCurrentLocation();
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"","");
    Provider.of<VisitsProvider>(context, listen: false).visitsList = [];
  }

  ScrollController mainScrollController = ScrollController();
  late final ScrollController _listViewScrollController = ScrollController()
    ..addListener(listViewScrollListener);
  ScrollPhysics _physics = const ScrollPhysics();

  void listViewScrollListener() {
    if (_listViewScrollController.offset >=
        _listViewScrollController.position.maxScrollExtent &&
        !_listViewScrollController.position.outOfRange) {
      if (mainScrollController.offset == 0) {
        mainScrollController.animateTo(50,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
      setState(() {
        _physics = const NeverScrollableScrollPhysics();
      });
      print("bottom");
    }
  }
  void mainScrollListener() {
    if (mainScrollController.offset <=
        mainScrollController.position.minScrollExtent &&
        !mainScrollController.position.outOfRange) {
      setState(() {
        if (_physics is NeverScrollableScrollPhysics) {
          _physics = const ScrollPhysics();
          _listViewScrollController.animateTo(
              _listViewScrollController.position.maxScrollExtent - 50,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        }
      });
      print("top");
    }
  }

  @override
  Widget build(BuildContext context) {
    mainScrollController.addListener(mainScrollListener);
    final allEmployeeData = Provider.of<EmployeesProvider>(context).employeesList;
    final allCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo != 0).toList();
    final allVisitsData = Provider.of<VisitsProvider>(context).visitsList.toList();
    return Scaffold(
      appBar: CustomAppBar(title: "Visit Entry"),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0.r),
              child: Card(
                elevation: 2,
                color: Colors.blue.shade200,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 5.0.w,right: 5.0.w,top: 2.0.h),
                  child: Column(
                    children: [
                       Row(
                        children: [
                          Expanded(flex: 6,child:Text("Visited Date",style:AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 14,
                            child: Container(
                              margin: const EdgeInsets.only(top: 3,bottom: 3),
                              height: 25.0.h,
                              decoration: ContDecoration.contDecoration,
                              child: userType == "a" || userType == "m" ? GestureDetector(
                                onTap: (() {
                                  _firstSelectedDate();
                                  //FocusScope.of(context).requestFocus(quantityFocusNode);
                                }),
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 5),
                                      suffixIcon: const Padding(padding: EdgeInsets.only(left: 20),
                                        child: Icon(Icons.calendar_month, color: Colors.black87, size: 16)),
                                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                                      hintText: firstPickedDate, hintStyle:AllTextStyle.dropDownlistStyle
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    return null;
                                  },
                                ),
                              ):GestureDetector(
                                onTap: (() {
                                }),
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 5),
                                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                                      hintText: firstPickedDate, hintStyle:AllTextStyle.dropDownlistStyle
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
                      SizedBox(height: 2.0.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Employee",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 14,
                            child: userType == "a" || userType == "m" ? Container(
                              height: 25.0.h,
                              decoration: ContDecoration.contDecoration,
                              child: TypeAheadField<EmployeesModel>(
                              controller: _employeeController,
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: AllTextStyle.textValueStyle,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5.w, top: 2.5.h),
                                    isDense: true,
                                    hintText: 'Select Employee',
                                    hintStyle: TextStyle(fontSize: 13.sp),
                                    suffixIcon: employeeId == '' || employeeId == 'null' || employeeId == null || controller.text == ''
                                        ? null
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _employeeController.clear();
                                                controller.clear();
                                                employeeId = null;
                                              });
                                              // Clear করার পর নতুনভাবে customer লোড
                                              Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5.r),
                                              child: Icon(Icons.close, size: 16.r),
                                            ),
                                          ),
                                    suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                    filled: false,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  ),
                                  onTap: () {
                                    // কার্সর রাখলেই নতুনভাবে লোড হবে
                                   Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
                      
                                    // আগের সিলেকশন থাকলে clear হবে
                                    if (employeeId != null &&
                                        employeeId != '' &&
                                        employeeId != 'null') {
                                      setState(() {
                                        _employeeController.clear();
                                        controller.clear();
                                        employeeId = null;
                                      });
                                    }
                                  },
                                );
                              },
                              suggestionsCallback: (pattern) async {
                                return Future.delayed(const Duration(seconds: 1), () {
                                  return allEmployeeData
                                      .where((element) => element.displayName
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList()
                                      .cast<EmployeesModel>();
                                });
                              },
                              itemBuilder: (context, EmployeesModel suggestion) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                  child: Text(
                                    "${suggestion.displayName}",
                                    style: TextStyle(fontSize: 12.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                              onSelected: (EmployeesModel suggestion) {
                                _employeeController.text = "${suggestion.displayName}";
                                setState(() {
                                  employeeId = suggestion.employeeSlNo.toString();
                                });
                              },
                            ),
                            ): Container(
                                height: 25.h,
                                decoration:ContDecoration.contDecoration,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                  child: Text("$userEmployeeName",style: AllTextStyle.dateFormatStyle),
                                )
                              ),
                          )
                      
                        ],
                      ),
                       SizedBox(height: 4.0.h),
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Customer",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 14,
                            child: Container(
                              height: 25.0.h,
                              decoration: ContDecoration.contDecoration,
                              child: TypeAheadField<CustomerListModel>(
                              controller: _customerController,
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: AllTextStyle.textValueStyle,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5.w, top: 2.5.h),
                                    isDense: true,
                                    hintText: 'Select Customer',
                                    hintStyle: TextStyle(fontSize: 13.sp),
                                    suffixIcon: customerId == '' || customerId == 'null' || customerId == null || controller.text == ''
                                        ? null
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _customerController.clear();
                                                controller.clear();
                                                customerId = null;
                                              });
                      
                                              // Clear করার পর নতুনভাবে customer লোড
                                              Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"","");
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5.r),
                                              child: Icon(Icons.close, size: 16.r),
                                            ),
                                          ),
                                    suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                    filled: false,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  ),
                                  onTap: () {
                                    // কার্সর রাখলেই নতুনভাবে লোড হবে
                                   Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"","");
                      
                                    // আগের সিলেকশন থাকলে clear হবে
                                    if (customerId != null &&
                                        customerId != '' &&
                                        customerId != 'null') {
                                      setState(() {
                                        _customerController.clear();
                                        controller.clear();
                                        customerId = null;
                                      });
                                    }
                                  },
                                );
                              },
                              suggestionsCallback: (pattern) async {
                                return Future.delayed(const Duration(seconds: 1), () {
                                  return allCustomersData
                                      .where((element) => element.customerName
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList()
                                      .cast<CustomerListModel>();
                                });
                              },
                              itemBuilder: (context, CustomerListModel suggestion) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                  child: Text(
                                    "${suggestion.displayName}",
                                    style: TextStyle(fontSize: 12.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                              onSelected: (CustomerListModel suggestion) {
                                _customerController.text = "${suggestion.displayName}";
                                setState(() {
                                  customerId = suggestion.customerSlNo.toString();
                                });
                              },
                            ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 4.0.h),
                      CommonTextFieldRow(
                        label: "Remark",
                        controller: _remarkController,
                        hintText: "Enter Remark",
                      ),
                      SizedBox(height: 4.0.h),
                      CommonTextFieldRow(
                        label: "Latitude",
                        controller: _latController,
                        hintText: "Enter Latitude",
                      ),
                      SizedBox(height: 4.0.h),
                      CommonTextFieldRow(
                        label: "Longitude",
                        controller: _longController,
                        hintText: "Enter Longitude",
                      ),
                      SizedBox(height: 4.0.h),
                      CommonTextFieldRow(
                        label: "Location",
                        controller: _locationController,
                        hintText: "Enter Visited Location",
                        maxLines: 3,
                      ),
                      SizedBox(height: 4.0.h),
                    Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () async {
                        Utils.closeKeyBoard(context);
                        print("Tapped Save");
                
                        if (_employeeController.text.isNotEmpty && (employeeId == null || employeeId == '')) {
                          Utils.showTopSnackBar(context, "Please Select Employee");
                          return;
                        }
                        if (_customerController.text == '') {
                          Utils.showTopSnackBar(context, "Please Select Customer");
                          return;
                        }
                        setState(() {
                          customerEntryBtnClk = true;
                        });
                
                        var result = await addVisit(context);
                        if (result == "true") {
                          Provider.of<VisitsProvider>(context, listen: false).getVisits(context,
                            customerId??"",
                            userType == "a" || userType == "m" ? employeeId??"" : userEmployeeId??"",
                            "",
                            "",
                          );
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: 28.0.h,
                        width: 80.0.w,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
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
                        child: Center(
                          child: customerEntryBtnClk
                              ? SizedBox(
                                  height: 20.0.h,
                                  width: 20.0.w,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : Text("SAVE", style: AllTextStyle.saveButtonTextStyle),
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height: 4.0.h),
                   ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0.h),
            VisitsProvider.isVisitsLoading
                ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.43,
                child: _buildShimmerEffect(allVisitsData.length))
                : Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: EdgeInsets.only(left: 8.w, right: 8.w,bottom: 20.h),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _listViewScrollController,
                  physics: _physics,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 20.h,
                      dataRowHeight: 20.h,
                      headingRowColor: WidgetStateColor.resolveWith((states) => Colors.blue.shade900),
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
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0.h),
          ],
        ),
      ),
    );
  }
  Widget _buildShimmerEffect(int length) {
    return ListView.builder(
      itemCount: length+1,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 15.h,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(2.r)),
            ),
          ),
        );
      },
    );
  }
  void emptyMethod() {
  setState(() {
    _employeeController.text = "";
    _customerController.text = "";
    _locationController.text = "";
    customerId = "";
    employeeId = "";
  });
}
bool customerEntryBtnClk = false;
Future<String> addVisit(BuildContext context) async {
  String link = "${baseUrl}add_visit";
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    var response = await Dio().post(link,
      data:{
        "id": 0,
        "date": backEndFirstDate,
        "employee_id": userType == "a" || userType == "m" ? employeeId.toString() : userEmployeeId.toString(),
        "customer_id": customerId.toString(),
        "location": _locationController.text.trim(),
        "remark": _remarkController.text.trim(),
        "latitude": _latController.text.trim(),
        "longitude": _longController.text.trim()
      },
      
      options: Options(
        headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        },
      ),
    );

    var item = response.data;
    print("API Response: $item");

    if (item["success"] == true) {
      setState(() {
        customerEntryBtnClk = false;
      });
      emptyMethod();
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      //Navigator.push(context,MaterialPageRoute(builder:(context) => const CustomerEntryScreen()));
      return "true";
    } else {
      setState(() {
        customerEntryBtnClk = false;
      });
      Utils.showTopSnackBar(context,"${item["message"]}");
      return "false";
    }
  } catch (e) {
    setState(() {
      customerEntryBtnClk = false;
    });
    print("Exception caught: $e");
    Utils.showTopSnackBar(context, "Something went wrong: $e");
    return "false";
  }
}
 
}