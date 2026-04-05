import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barishal_surgical/common_widget/commontext_fieldrow.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_list_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_list_provider.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/const_model.dart';
import '../../../utils/utils.dart';


class VisitEntryScreen extends StatefulWidget {
  const VisitEntryScreen({super.key});

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  Color getColor(Set<WidgetState> states) {return Colors.blue.shade100;}
  Color getColors(Set<WidgetState> states) {return Colors.white;}
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _employeeCustomerController = TextEditingController();
  final _locationController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

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
  bool isLocationLoading = false;
  Future<void> getCurrentLocation() async {
    // Permission check
    LocationPermission permission = await Geolocator.checkPermission();
    CustomSnackBar.showTopSnackBar(context, "✅Get Location Please wait...");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _latController.text = position.latitude.toString();
    _longController.text = position.longitude.toString();

    // Get address from lat long
    List<Placemark> placemarks =await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks.first;

    String fullAddress ="${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";

    _locationController.text = fullAddress;
  }

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
  }

  String? employeeSlNo;
  String? employeeId = "";
  String? userEmployeeId = "";
  String? _selectedCustomerId;
  String userName = "";
  String userType = "";

  @override
  void initState() {
    // TODO: implement initState
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    super.initState();
    _initializeData();
    getCurrentLocation();
    // Provider.of<EmployeeProvider>(context,listen: false).getEmployee();
    // Provider.of<VisitsProvider>(context, listen: false).visitslist=[];
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context, "");
    // CustomerListProvider.isCustomerTypeChange = true;
    // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("","","");
    userName = _employeeCustomerController.text;
    print("eeeeeeeeeeeeeeee======  ${_employeeCustomerController.text}");
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
        mainScrollController.animateTo(50, duration: const Duration(milliseconds: 200), curve: Curves.linear);
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
    // final allEmployeeData = Provider.of<EmployeeProvider>(context).allEmployeeList;
    //get Customer
    final allCustomerList = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo!=0).toList();
    //get Visits
    // final allGetVisitsData = Provider.of<VisitsProvider>(context).visitslist;
    // print("Get allGetVisitsData length=====> ${allGetVisitsData.length} ");
    return Scaffold(
      appBar: CustomAppBar(title: "Visit Entry"),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.0.r),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(10.0.r),
                  border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
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
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Customer",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: Container(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: ContDecoration.contDecoration,
                            child: TypeAheadField<CustomerListModel>(
                            controller: _customerNameController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                  isDense: true,
                                  hintText: 'Select Customer',
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  suffixIcon: _selectedCustomerId == '' || _selectedCustomerId == 'null' || _selectedCustomerId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _customerNameController.clear();
                                        controller.clear();
                                        _selectedCustomerId = null;
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
                                return allCustomerList.where((element) =>
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
                                _customerNameController.text = suggestion.displayName!;
                                _selectedCustomerId = suggestion.customerSlNo.toString();
                                _nameController.text = suggestion.customerName.toString();
                                _phoneController.text = suggestion.customerMobile.toString();
                                _addressController.text = suggestion.customerAddress.toString();
                                _employeeController.text = suggestion.employeeName.toString();
                              });
                            },
                          ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 4.0.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Name",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style:  AllTextStyle.dropDownlistStyle,
                              controller: _nameController,
                              decoration: InputDecoration(
                                  hintText: "Enter name",
                                  hintStyle:  AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border:InputBorder.none,
                                  focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Phone",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                  hintText: "Enter Phone",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border:InputBorder.none,
                                  focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Address",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _addressController,
                              decoration: InputDecoration(
                                  hintText: "Enter Address",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border:InputBorder.none,
                                  focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Visit Date",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: Container(
                            height: 25.h,
                            padding: EdgeInsets.all(5.r),
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 10.h),
                                  filled: true,
                                  suffixIcon: Padding(padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r)),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: firstPickedDate ,
                                  hintStyle:  TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade700, fontWeight: FontWeight.w400),
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
                    SizedBox(height: 4.0.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Employee",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _employeeController,
                              decoration: InputDecoration(
                                  hintText: "Enter employee",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                        // userName == "Admin"? Expanded(
                        //   flex: 11,
                        //   child: Container(
                        //     height: 30.0,
                        //     width: MediaQuery.of(context).size.width / 2,
                        //     decoration: ContDecoration.contDecoration,
                        //     child: TypeAheadFormField(
                        //       textFieldConfiguration: TextFieldConfiguration(
                        //           onChanged: (value) {
                        //             if (value == '') {
                        //               employeeSlNo = '';
                        //             }
                        //           },
                        //           style: AllTextStyle.dropDownlistStyle,
                        //           controller: _employeeController,
                        //           decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 10,left: 5.0),
                        //               hintText: 'Select Employee',
                        //               hintStyle: AllTextStyle.textValueStyle,
                        //               suffixIcon: employeeSlNo == "null" || employeeSlNo == "" || _employeeController.text == "" || employeeSlNo == null ? null
                        //                   : GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     _employeeController.text = '';
                        //                   });
                        //                 },
                        //                 child: const Padding(padding: EdgeInsets.only(left: 6, right: 6), child: Icon(Icons.close, size: 16)),
                        //               ),
                        //               suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                        //               filled: true,
                        //               fillColor: Colors.white,
                        //               border: InputBorder.none,
                        //               focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                        //               enabledBorder:TextFieldInputBorder.focusEnabledBorder
                        //           )),
                        //       suggestionsCallback: (pattern) {
                        //         return allEmployeeData.where((element) => element.employeeName.toString().toLowerCase().contains(pattern.toString().toLowerCase())).take(allEmployeeData.length).toList();
                        //       },
                        //       itemBuilder: (context, suggestion) {
                        //         return SizedBox(
                        //           child: Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        //             child: Text("${suggestion.employeeName} - ${suggestion.employeeSlNo}",
                        //                 style: const TextStyle(fontSize: 12),
                        //                 maxLines: 1, overflow: TextOverflow.ellipsis),
                        //           ),
                        //         );
                        //       },
                        //       transitionBuilder: (context, suggestionsBox, controller) {
                        //         return suggestionsBox;
                        //       },
                        //       onSuggestionSelected: (EmployeeModel suggestion) {
                        //         _employeeController.text = suggestion.employeeName!;
                        //         setState(() {
                        //           employeeSlNo = suggestion.employeeSlNo.toString();
                        //         });
                        //         print("Employeee====  $employeeSlNo");
                        //       },
                        //       onSaved: (value) {},
                        //     ),
                        //   ),
                        // ):Expanded(
                        //   flex: 11,
                        //   child: Container(
                        //       height: 30.0,
                        //       width: MediaQuery.of(context).size.width / 2,
                        //       padding: const EdgeInsets.only(top: 5.0,left: 4.0),
                        //       decoration: ContDecoration.contDecoration,
                        //       child: Text(userName,style: AllTextStyle.textValueStyle,)
                        //   ),
                        // ),
                      ],
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
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Note",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 14,
                          child: SizedBox(
                            height: 45.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _noteController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  hintText: "Note here",
                                  hintStyle: AllTextStyle.textValueStyle,
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                  enabledBorder: TextFieldInputBorder.focusEnabledBorder
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          // final connectivityResult = await (Connectivity().checkConnectivity());
                          // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                          //   Utils.closeKeyBoard(context);
                          //   if(_customerNameController.text==''){
                          //     Utils.errorSnackBar(context, "Please Select Customer");
                          //   }
                          //   else if(_nameController.text==''){
                          //     Utils.errorSnackBar(context, "Name is required");
                          //   }
                          //   else if(_phoneController.text==''){
                          //     Utils.errorSnackBar(context, "Phone field is required");
                          //   }
                          //   else if(_employeeController.text == '') {
                          //     Utils.errorSnackBar(context, "Employee field is required");
                          //   }
                          //   else{
                          //     setState(() {
                          //       visitEntryBtnClk = true;
                          //     });
                          //     addVisit(context).then((value){
                          //       Provider.of<VisitsProvider>(context, listen: false).getVisits("",userType == "m"||userType == "a" ? "$employeeSlNo" : userEmployeeId, "", "");
                          //       setState(() {
                          //       });
                          //     });
                          //   }
                          // }
                          // else{
                          //   Utils.errorSnackBar(context, "Please check your internet connection");
                          // }
                        },
                        child: Container(
                          height: 28.h,
                          width: MediaQuery.of(context).size.width/5.5,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(5.0.r),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 2,blurRadius: 5, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: Center(child: visitEntryBtnClk ? SizedBox(height: 20.h,width:20.w,child: CircularProgressIndicator(color: Colors.white,)) : Text(
                              "SAVE",style: AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ///
            // const SizedBox(height: 4.0),
            // VisitsProvider.isVisitsLoading
            //     ? const Center(child: CircularProgressIndicator(),)
            //     : Container(
            //   height: MediaQuery.of(context).size.height / 1.43,
            //   width: double.infinity,
            //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: SingleChildScrollView(
            //       controller: _listViewScrollController,
            //       physics: _physics,
            //       scrollDirection: Axis.vertical,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: DataTable(
            //           columnSpacing: 25,
            //           headingRowHeight: 20.0,
            //           dataRowHeight: 20.0,
            //           headingRowColor: WidgetStateColor.resolveWith((states) => Colors.blue.shade700),
            //           showCheckboxColumn: true,
            //           border: TableBorder.all(color: Colors.blueGrey.shade100, width: 1),
            //           columns: const [
            //             DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Customer Address',style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Phone',style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Visit Date',style: AllTextStyle.tableHeadTextStyle)))),
            //             DataColumn(label: Expanded(child: Center(child: Text('Note',style: AllTextStyle.tableHeadTextStyle)))),
            //           ],
            //           rows: List.generate(
            //             allGetVisitsData.length > 100 ? 100 : allGetVisitsData.length,
            //                 (int index) => DataRow(
            //               color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
            //               cells: <DataCell>[
            //                 DataCell(Center(child: Text(allGetVisitsData[index].customerCode))),
            //                 DataCell(Center(child: Text(allGetVisitsData[index].customerName))),
            //                 DataCell(Center(child: Text(allGetVisitsData[index].customerAddress))),
            //                 DataCell(Center(child: Text(allGetVisitsData[index].phone))),
            //                 DataCell(Center(child: Text(allGetVisitsData[index].visitDate))),
            //                 DataCell(Center(child: Text(allGetVisitsData[index].note))),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
  emptyMethod() {
    setState(() {
      _nameController.text = "";
      _customerNameController.text = "";
      _phoneController.text = "";
      _addressController.text = "";
      _employeeController.text="";
      _noteController.text="";
    });
  }
  Future<String> addVisit(BuildContext context) async {
    print("name=====${_nameController.text.trim()}");
    print("customer_id=====$_selectedCustomerId");
    print("Customer_Address=====${_addressController.text.trim()}");
    print("phone=====${_phoneController.text.trim()}");
    print("Employee_Name=====${_employeeController.text.trim()}");
    print("visit_date=====$backEndFirstDate");
    print("note=====${_noteController.text.trim()}");
    String link = "${baseUrl}api/v1/addVisit";
    var data = {
      "name":_nameController.text.trim(),
      "customer_id":_selectedCustomerId,
      "Customer_Address":_addressController.text.trim(),
      "phone":_phoneController.text.trim(),
      "Employee_Name":_employeeController.text.trim(),
      "visit_date": backEndFirstDate,
      "note": _noteController.text.trim(),
    };
    FormData formData = FormData.fromMap({
      "visit": jsonEncode(data),
    });
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(
        link,
        data: formData,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );

      var item = jsonDecode(response.data);
      print("Visit Data: $item");
      if (item["success"] == true) {
        setState(() {
          visitEntryBtnClk = false;
        });
        emptyMethod();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 4, 108, 156),
            duration: const Duration(seconds: 2),
            content: Center(child: Text("${item["message"]}", style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
        return "true";
      } else {
        setState(() {
          visitEntryBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
            content: Center(
              child: Text(
                "${item["message"]}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
        return "false";
      }
    } catch (e) {
      print("Error: $e");
      return "false";
    }
  }
  bool visitEntryBtnClk = false;
}
