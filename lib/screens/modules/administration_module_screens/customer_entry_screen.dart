library;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/administration_module_models/areas_model.dart';
import '../../../models/administration_module_models/branches_model.dart';
import '../../../models/administration_module_models/employees_model.dart';
import '../../../providers/administration_module_providers/areas_provider.dart';
import '../../../providers/administration_module_providers/branches_provider.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/const_model.dart';

class CustomerEntryScreen extends StatefulWidget {
  const CustomerEntryScreen({super.key,});
  @override
  State<CustomerEntryScreen> createState() => _CustomerEntryScreenState();
}

class _CustomerEntryScreenState extends State<CustomerEntryScreen> {
  Color getColor(Set<WidgetState> states) {
    return Colors.teal.shade100;
  }

  Color getColors(Set<WidgetState> states) {
    return Colors.white;
  }
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _officePhoneController = TextEditingController();
  final TextEditingController _previousDueController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userEmployeeId = "${sharedPreferences?.getString('employeeId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userEmployeeId==== $userEmployeeId");
  }

  String? _customerType = "retail";
  String? areaSlNo;
  String? _selectBranchId;
  String? outletsSlNo;
  String? routeSlNo;
  String? employeeId = "";
  String? userEmployeeId = "";
  String userName = "";
  String userType = "";

  File? _image;
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800.w,
        maxHeight: 800.h,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        if (mounted) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

String? attachFileName, attachFilePath;
String? tradeLicenseName, tradeLicensePath;

  // File pick korar function
  Future<void> pickGenericFile(String type) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'png'],
  );

  if (result != null) {
    setState(() {
      if (type == "attach") {
        attachFileName = result.files.single.name;
        attachFilePath = result.files.single.path; // Path save kora holo
      } else {
        tradeLicenseName = result.files.single.name;
        tradeLicensePath = result.files.single.path; // Path save kora holo
      }
    });
  }
}

  Widget fileUploadRow(String label, String? fileName, VoidCallback onTap) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center, 
    children: [
      Expanded(flex: 6,child: Text(label,style: AllTextStyle.textFieldHeadStyle)),
       const Expanded(flex: 1, child: Text(":")),
      Expanded(
        flex: 16,
        child: Container(
          height: 35.h,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text("Choose File", 
                    style: TextStyle(fontSize: 12.sp, color: Colors.black)),
              ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  fileName ?? "No file chosen",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: fileName == null ? Colors.grey : Colors.black87
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeData();
    Provider.of<BranchesProvider>(context, listen: false).getBranches(context);
    Provider.of<EmployeesProvider>(context,listen: false).getEmployees(context);
    Provider.of<AreasProvider>(context,listen: false).getAreas(context);
    CustomerListProvider.isCustomerListloading = true;
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"");
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

  var areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mainScrollController.addListener(mainScrollListener);
    final allAreaData = Provider.of<AreasProvider>(context).areasList;
    final allBranchesData = Provider.of<BranchesProvider>(context).branchesList;
    final allEmployeeData = Provider.of<EmployeesProvider>(context).employeesList;
    ///get Customer
    final allCustomerList = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo!=0).toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appColor,
        title: const Text("Customer Entry",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
            );
          },
        ),
      ),
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
                  color: Colors.teal[200],
                  borderRadius: BorderRadius.circular(10.0.r),
                  border: Border.all(color: Colors.teal.shade900, width: 1.0.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2, blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Employee",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        userName == "Admin"? Expanded(
                          flex: 16,
                          child: Container(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
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
                                    hintStyle: AllTextStyle.textValueStyle,
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
                          flex: 16,
                          child: Container(
                              height: 25.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.only(top: 5.0.h,left: 4.0.w),
                              decoration: ContDecoration.contDecoration,
                              child: Text(userName,style: AllTextStyle.textValueStyle)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Customer",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 16,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _customerNameController,
                              decoration: InputDecoration(
                                  hintText: "Enter Customer Name",
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
                        Expanded(flex: 6,child: Text("Owner",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 16,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style:  AllTextStyle.dropDownlistStyle,
                              controller: _ownerNameController,
                              decoration: InputDecoration(
                                  hintText: "Enter Owner Name",
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
                        Expanded(flex: 6,child: Text("Address",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 16,
                          child: SizedBox(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: AllTextStyle.dropDownlistStyle,
                              controller: _addressController,
                              decoration: InputDecoration(
                                  hintText: "Enter Address Name",
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
                        Expanded(flex: 6,child: Text("Area",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 16,
                          child: Container(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: ContDecoration.contDecoration,
                            child: TypeAheadField<AreasModel>(
                              controller: areaController,
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                    isDense: true,
                                    hintText: 'Select Area',
                                    hintStyle: AllTextStyle.textValueStyle,
                                    suffixIcon: areaSlNo == '' || areaSlNo == 'null' || areaSlNo == null || controller.text == '' ? null
                                        : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          areaController.clear();
                                          controller.clear();
                                          areaSlNo = null;
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
                                  return allAreaData.where((element) =>
                                      element.districtName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                });
                              },
                              itemBuilder: (context, AreasModel suggestion) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                  child: Text(suggestion.districtName!,
                                    style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                              onSelected: (AreasModel suggestion) {
                                setState(() {
                                  areaController.text = suggestion.districtName!;
                                  areaSlNo = suggestion.districtSlNo.toString();
                                });
                              },
                            ),
                            // child: TypeAheadFormField(
                            //   textFieldConfiguration: TextFieldConfiguration(
                            //       onChanged: (value) {
                            //         if (value == '') {
                            //           areaSlNo = '';
                            //         }
                            //       },
                            //       style: AllTextStyle.dropDownlistStyle,
                            //       controller: areaController,
                            //       decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 10,left: 5.0),
                            //           hintText: 'Select Area',
                            //           hintStyle: AllTextStyle.textValueStyle,
                            //           suffixIcon: areaSlNo == "null" || areaSlNo == "" || areaController.text == "" || areaSlNo == null ? null
                            //               : GestureDetector(
                            //             onTap: () {
                            //               setState(() {
                            //                 areaController.text = '';
                            //               });
                            //             },
                            //             child: const Padding(padding: EdgeInsets.only(left: 6, right: 6), child: Icon(Icons.close, size: 16)),
                            //           ),
                            //           suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                            //           filled: true,
                            //           fillColor: Colors.white,
                            //           border: InputBorder.none,
                            //           focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                            //           enabledBorder:TextFieldInputBorder.focusEnabledBorder
                            //       )),
                            //   suggestionsCallback: (pattern) {
                            //     return allAreaData.where((element) => element.districtName.toString().toLowerCase().contains(pattern.toString().toLowerCase())).take(allAreaData.length).toList();
                            //   },
                            //   itemBuilder: (context, suggestion) {
                            //     return SizedBox(
                            //       child: Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            //         child: Text("${suggestion.districtName} - ${suggestion.districtSlNo}",
                            //             style: const TextStyle(fontSize: 12),
                            //             maxLines: 1, overflow: TextOverflow.ellipsis),
                            //       ),
                            //     );
                            //   },
                            //   transitionBuilder: (context, suggestionsBox, controller) {
                            //     return suggestionsBox;
                            //   },
                            //   onSuggestionSelected: (AreaModel suggestion) {
                            //     areaController.text = suggestion.districtName;
                            //     setState(() {
                            //       areaSlNo = suggestion.districtSlNo.toString();
                            //     });
                            //   },
                            //   onSaved: (value) {},
                            // ),
                          ),
                        ),
                      ],
                    ),
                    ///===new
                    Row(
                      children: [
                        Expanded(
                          flex:5,
                          child: Container(
                            padding: EdgeInsets.only(right: 5.0.w),
                            child: Column(children: [
                              SizedBox(height: 4.0.h),
                              Row(
                                children: [
                                  Expanded(flex: 6,child: Text("Mobile",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 9,
                                    child: SizedBox(
                                      height: 25.0.h,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _mobileController,
                                        decoration: InputDecoration(
                                          hintText: "Enter Mobile",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.0.h),
                              Row(
                                children: [
                                  Expanded(flex: 6,child: Text("Off. Phone",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 9,
                                    child: SizedBox(
                                      height: 25.0.h,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _officePhoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            hintText: "Enter Office Phone",
                                            hintStyle: AllTextStyle.textValueStyle,
                                            contentPadding: EdgeInsets.only(left: 5.w),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder: TextFieldInputBorder.focusEnabledBorder,
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
                                  Expanded(flex: 6,child: Text("Prev. Due",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 9,
                                    child: SizedBox(
                                      height: 25.0.h,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _previousDueController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.0.h),
                              Row(
                                children: [
                                  Expanded(flex: 6,child: Text("Cr. Limit",style: AllTextStyle.textFieldHeadStyle)),
                                  const Expanded(flex: 1, child: Text(":")),
                                  Expanded(
                                    flex: 9,
                                    child: SizedBox(
                                      height: 25.0.h,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: TextField(
                                        style: AllTextStyle.dropDownlistStyle,
                                        controller: _creditLimitController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "0",
                                          hintStyle: AllTextStyle.textValueStyle,
                                          contentPadding: EdgeInsets.only(left: 5.w),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],),
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: Container(
                            padding: EdgeInsets.only(top: 4.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _image != null
                                    ? Container(
                                  height: 80.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0.r),
                                    image: DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                  : Container(
                                  height: 80.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5.0.r),
                                      border: Border.all(color: Colors.white,width: 2.w)
                                  ),
                                  child: Center(child: Text("No Image Available",textAlign:TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 14.0.sp,fontWeight: FontWeight.w600))),
                                ),
                                SizedBox(height:4.0.h),
                                InkWell(
                                  onTap: () async {
                                    await _pickImage();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.teal.shade900,width: 2.0.w),
                                      borderRadius: BorderRadius.circular(5.0.r),
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 2,blurRadius: 5, offset: const Offset(0, 3)),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 5.h),
                                      child: Center(child: Text(
                                          "Select Image",style: TextStyle(fontSize: 11.0.sp,color: Colors.blueGrey,fontWeight: FontWeight.w500))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _customerType == "dealer" ? SizedBox(height: 5.0): SizedBox(),
                    _customerType == "dealer" ? Row(
                      children: [
                        Expanded(flex: 6,child: Text("Father",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 16,
                          child: SizedBox(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: TextStyle(fontSize: 10.0,color: Colors.grey.shade700),
                              controller: _fatherNameController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter Father Name",
                                hintStyle: AllTextStyle.textValueStyle,
                                contentPadding: const EdgeInsets.only(left: 5),
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ): SizedBox(),
                    _customerType == "dealer" ? SizedBox(height: 5.0): SizedBox(),
                    _customerType == "dealer" ? Row(
                      children: [
                        Expanded(flex: 6,child: Text("Mother",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 16,
                          child: SizedBox(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: TextStyle(fontSize: 10.0,color: Colors.grey.shade700),
                              controller: _motherNameController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter Mother Name",
                                hintStyle: AllTextStyle.textValueStyle,
                                contentPadding: const EdgeInsets.only(left: 5),
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ):SizedBox(),
                    _customerType == "dealer" ? SizedBox(height: 4.0.h):SizedBox(),
                    _customerType == "dealer" ? Row(
                        children: [
                          Expanded(flex: 6,child: Text("NID",style: AllTextStyle.textFieldHeadStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 16,
                            child: SizedBox(
                              height: 25.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                style: AllTextStyle.dropDownlistStyle,
                                controller: _nidController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: "Enter NID",
                                    hintStyle: AllTextStyle.textValueStyle,
                                    contentPadding: EdgeInsets.only(left: 5.w),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                    enabledBorder: TextFieldInputBorder.focusEnabledBorder
                                ),
                              ),
                            ),
                          ),
                        ],
                      ):SizedBox(),
                    _customerType == "dealer" ? Row(
                      children: [
                        Expanded(flex: 6,child: Text("Branch",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        userName == "Admin"? Expanded(
                          flex: 16,
                          child: Container(
                            height: 25.0.h,
                            margin: EdgeInsets.only(top: 5.0.h),
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: ContDecoration.contDecoration,
                            child: TypeAheadField<BranchesModel>(
                              controller: _branchController,
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                    isDense: true,
                                    hintText: 'Select Branch',
                                    hintStyle: AllTextStyle.textValueStyle,
                                    suffixIcon: _selectBranchId == '' || _selectBranchId == 'null' || _selectBranchId == null || controller.text == '' ? null
                                        : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _branchController.clear();
                                          controller.clear();
                                          _selectBranchId = null;
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
                                  return allBranchesData.where((element) =>
                                      element.branchTitle!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                });
                              },
                              itemBuilder: (context, BranchesModel suggestion) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                  child: Text(suggestion.branchTitle!,
                                    style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                              onSelected: (BranchesModel suggestion) {
                                setState(() {
                                  _branchController.text = suggestion.branchTitle!;
                                  _selectBranchId = suggestion.branchId.toString();
                                });
                              },
                            ),
                            // child: TypeAheadFormField(
                            //   textFieldConfiguration: TextFieldConfiguration(
                            //       onChanged: (value) {
                            //         if (value == '') {
                            //           employeeSlNo = '';
                            //         }
                            //       },
                            //       style: AllTextStyle.dropDownlistStyle,
                            //       controller: _employeeController,
                            //       decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 10,left: 5.0),
                            //           hintText: 'Select Employee',
                            //           hintStyle: AllTextStyle.textValueStyle,
                            //           suffixIcon: employeeSlNo == "null" || employeeSlNo == "" || _employeeController.text == "" || employeeSlNo == null ? null
                            //               : GestureDetector(
                            //             onTap: () {
                            //               setState(() {
                            //                 _employeeController.text = '';
                            //               });
                            //             },
                            //             child: const Padding(padding: EdgeInsets.only(left: 6, right: 6), child: Icon(Icons.close, size: 16)),
                            //           ),
                            //           suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                            //           filled: true,
                            //           fillColor: Colors.white,
                            //           border: InputBorder.none,
                            //           focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                            //           enabledBorder:TextFieldInputBorder.focusEnabledBorder
                            //       )),
                            //   suggestionsCallback: (pattern) {
                            //     return allEmployeeData.where((element) => element.employeeName.toString().toLowerCase().contains(pattern.toString().toLowerCase())).take(allEmployeeData.length).toList();
                            //   },
                            //   itemBuilder: (context, suggestion) {
                            //     return SizedBox(
                            //       child: Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            //         child: Text("${suggestion.employeeName} - ${suggestion.employeeSlNo}",
                            //             style: const TextStyle(fontSize: 12),
                            //             maxLines: 1, overflow: TextOverflow.ellipsis),
                            //       ),
                            //     );
                            //   },
                            //   transitionBuilder: (context, suggestionsBox, controller) {
                            //     return suggestionsBox;
                            //   },
                            //   onSuggestionSelected: (EmployeeModel suggestion) {
                            //     _employeeController.text = suggestion.employeeName;
                            //     setState(() {
                            //       employeeSlNo = suggestion.employeeSlNo.toString();
                            //     });
                            //   },
                            //   onSaved: (value) {},
                            // ),
                          ),
                        ):Expanded(
                          flex: 15,
                          child: Container(
                            height: 25.0.h,
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.only(top: 5.0.h,left: 4.0.w),
                            decoration: ContDecoration.contDecoration,
                            child: Text(userName,style: AllTextStyle.textValueStyle)
                          ),
                        ),
                      ],
                    ):SizedBox(),
                     _customerType == "dealer" ? SizedBox(height: 4.0.h):SizedBox(),
                     _customerType == "dealer" ? fileUploadRow("Attach File", attachFileName, () => pickGenericFile("attach")):SizedBox(),
                     _customerType == "dealer" ? SizedBox(height: 4.0.h):SizedBox(),
                     _customerType == "dealer" ? fileUploadRow("Tr. Licence", tradeLicenseName, () => pickGenericFile("license")):SizedBox(),
                    SizedBox(height: 6.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("C. Type :",style: AllTextStyle.textFieldHeadStyle),
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4), // Density komano holo
                                  fillColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
                                  value: "retail",
                                  groupValue: _customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _customerType = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox(child: Text("Retail",maxLines: 2,overflow: TextOverflow.ellipsis,style: AllTextStyle.textFieldHeadStyle))),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4), // Density komano holo
                                  fillColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
                                  value: "wholesale",
                                  groupValue: _customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _customerType = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox(child: Text("Wholesale",maxLines: 2,overflow: TextOverflow.ellipsis,style: AllTextStyle.textFieldHeadStyle))),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4), // Density komano holo
                                  fillColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
                                  value: "dealer",
                                  groupValue: _customerType,
                                  activeColor: const Color.fromARGB(255, 84, 107, 241),
                                  onChanged: (value) {
                                    setState(() {
                                      _customerType = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(child: SizedBox(child: Text("Dealer",maxLines: 2,overflow: TextOverflow.ellipsis,style: AllTextStyle.textFieldHeadStyle))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          print("object");
                            // Utils.closeKeyBoard(context);
                            // if(_customerNameController.text==''){
                            //   Utils.errorSnackBar(context, "Customer name is required");
                            // }
                            // else if(areaController.text==''){
                            //   Utils.errorSnackBar(context, "Area field is required");
                            // }
                            // else if (userName == 'Admin') {
                            //   if (_employeeController.text == '') {
                            //     Utils.errorSnackBar(context, "Employee field is required");
                            //   }
                            // }
                            // else if(_mobileController.text==''){
                            //   Utils.errorSnackBar(context, "Mobile field is required");
                            // }
                           // else{
                              setState(() {
                                customerEntryBtnClk = true;
                              });
                              customerEntry(context).then((value){
                                Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"");
                                setState(() {
                                });
                              });
                            //}
                        },
                        child: Container(
                          height: 28.0.h,
                          width: 80.0.w,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade900,
                            borderRadius: BorderRadius.circular(5.0.r),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.6),spreadRadius: 2,blurRadius: 5, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: Center(child: customerEntryBtnClk ? SizedBox(height: 20.0.h,width:20.0.w,child: CircularProgressIndicator(color: Colors.white,)) : Text(
                              "SAVE",style: AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.0.h),
            CustomerListProvider.isCustomerListloading
                ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.43,
                child: _buildShimmerEffect(allCustomerList.length))
                : Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
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
                      headingRowHeight: 20.0,
                      dataRowHeight: 20.0,
                      headingRowColor: WidgetStateColor.resolveWith((states) => Colors.teal.shade900),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Sl.',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Id',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Owner Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Area',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Contact Number',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Type',style: AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Credit Limit',style: AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows: List.generate(
                       allCustomerList.length,
                            (int index) => DataRow(
                          color: index % 2 == 0 ? WidgetStateProperty.resolveWith(getColor) : WidgetStateProperty.resolveWith(getColors),
                          cells: <DataCell>[
                            DataCell(Center(child: Text('${index +1}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].customerCode}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].customerName}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].ownerName??""}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].districtName}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].customerMobile}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].employeeName??""}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].customerType}'))),
                            DataCell(Center(child: Text('${allCustomerList[index].customerCreditLimit}'))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100.0.h),
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
  emptyMethod() {
    setState(() {
      _customerNameController.text = "";
      _mobileController.text = "";
      _officePhoneController.text = "";
      _addressController.text = "";
      _ownerNameController.text = "";
      areaController.text = "";
      _employeeController.text="";
      _creditLimitController.text = "";
      _previousDueController.text = "";
      _routeController.text = "";
      _fatherNameController.text = "";
      _motherNameController.text = "";
      _nidController.text = "";
      _image = null;
    });
  }

  Future<String> customerEntry(BuildContext context) async {
  String link = "${baseUrl}add_customer";
  
  var data = {
    "Customer_SlNo": "",
    "Customer_Code": "",
    "Customer_Name": _customerNameController.text.trim(),
    "Customer_Type": _customerType.toString().trim(),
    "Customer_Phone": "",
    "Customer_Mobile": _mobileController.text.trim(),
    "Customer_OfficePhone": _officePhoneController.text.trim(),
    "Customer_Email": "",
    "Customer_Address": _addressController.text.trim(),
    "owner_name": _ownerNameController.text.trim(),
    "area_ID": areaSlNo.toString().trim(),
    "employee_id": userType == "m" || userType == "a" ? "$employeeId" : userEmployeeId,
    "Customer_Credit_Limit": _creditLimitController.text.trim(),
    "previous_due": _previousDueController.text.trim(),
    "dealerId": _selectBranchId.toString().trim(),
    "father_name": _fatherNameController.text.trim(),
    "mother_name": _motherNameController.text.trim(),
    "nid": _nidController.text.trim(),
  };

  // FormData setup with Null safety check
  FormData formData = FormData.fromMap({
    "data": jsonEncode(data),
    if (_image != null)
      "image": await MultipartFile.fromFile(_image!.path, filename: "customer_image.jpg"),
    
    if (attachFilePath != null)
      "attach_file": await MultipartFile.fromFile(attachFilePath!, filename: attachFileName),
    
    if (tradeLicensePath != null)
      "trade_licence": await MultipartFile.fromFile(tradeLicensePath!, filename: tradeLicenseName),
  });

  // Printing for Debugging
  for (var field in formData.fields) {
    print('Key: ${field.key}, Value: ${field.value}');
  }
  for (var file in formData.files) {
    print('File Key: ${file.key}, File Name: ${file.value.filename}');
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  
  try {
    var response = await Dio().post(
      link,
      data: formData,
      options: Options(headers: {
        "Content-Type": "multipart/form-data",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }),
    );

    // Dio usually returns a Map if the response is JSON, so use it directly
    var item = response.data;
    
    // Check if item is String, then decode (safety check)
    if (item is String) {
      item = jsonDecode(response.data);
    }

    if (item["success"] == true || item["success"] == "true") {
      setState(() {
        customerEntryBtnClk = false;
      });
      emptyMethod();
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      return "true";
    } else {
      setState(() {
        customerEntryBtnClk = false;
      });
      Utils.showTopSnackBar(context, "${item["message"]}");
      return "false";
    }
  } catch (e) {
    setState(() {
      customerEntryBtnClk = false;
    });
    print("Error: $e");
    return "false";
  }
}
  bool customerEntryBtnClk = false;
}
