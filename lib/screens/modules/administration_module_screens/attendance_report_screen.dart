import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/common_widget/commontype_aheadfield.dart';
import 'package:barishal_surgical/common_widget/custom_appbar.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/employees_provider.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  String? user = "";
  String? userType = "";
  String? userWiseEmployeeId = "";
  String? starTime = "";
  String? endTime = "";
  String? salesEntry;
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    user = "${sharedPreferences?.getString('user')}";
    userType = "${sharedPreferences?.getString('userType')}";
    userWiseEmployeeId = "${sharedPreferences?.getString("employeeId")}";
    starTime = "${sharedPreferences?.getString('startTime')}";
    endTime = "${sharedPreferences?.getString('endTime')}";
    
    print("user-==========----==========$user");
    print("userType-==========----==========$userType");
    print("userWiseEmployeeId-==========----==========$userWiseEmployeeId");
    print("Office starTime -==========----==========$starTime");
    print("Office endTime -==========----==========$endTime");
  }
  
  Color getColor(Set<WidgetState> states) {
    return Colors.blue.shade200;
  }

  Color getColors(Set<WidgetState> states) {
    return Colors.white;
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
  var empluyeeNameController = TextEditingController();
  String? employeeSlNo;

  String calculateOvertime({
  required String? inTime,
  required String? outTime,
  required String normalShiftStart,
  required String normalShiftEnd,
}) {
  try {
    if (inTime == null || inTime.isEmpty) return "";
    if (outTime == null || outTime.isEmpty || outTime == "00:00:00") return "--";

    final now = DateTime.now();
    final dateString = "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";

    final start = DateTime.parse("$dateString $inTime");
    final end = DateTime.parse("$dateString $outTime");
    
    Duration actualWorking = end.difference(start);
    if (actualWorking.isNegative) actualWorking = actualWorking.abs();
    final shiftStart = DateTime.parse("$dateString $normalShiftStart");
    final shiftEnd = DateTime.parse("$dateString $normalShiftEnd");

    Duration normalShiftDuration = shiftEnd.difference(shiftStart);
    if (normalShiftDuration.isNegative) normalShiftDuration = normalShiftDuration.abs();
    Duration overtime = actualWorking - normalShiftDuration;
    if (overtime.isNegative) return "0h 0m";

    final hours = overtime.inHours;
    final minutes = overtime.inMinutes % 60;
    return "${hours}h ${minutes}m";
  } catch (e) {
    return "";
  }
}

  String calculateTotalHours(String? inTime, String? outTime) {
    try {
      if (inTime == null || inTime.isEmpty) {
        return "";
      }
      if (outTime == null || outTime.isEmpty || outTime == "00:00:00") {
        return "--";
      }
      final now = DateTime.now();
      final dateString ="${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final start = DateTime.parse("$dateString $inTime");
      final end = DateTime.parse("$dateString $outTime");
      Duration diff = end.difference(start);
      if (diff.isNegative) {
        diff = diff.abs();
      }
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return "${hours}h ${minutes}m";
    } catch (e) {
      return "";
    }
  }


   @override
  void initState() {
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    super.initState();
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    // Provider.of<AttendanceProvider>(context,listen: false).attendanceList=[];
  }

  bool isAllClicked = true;
  bool isEmployeeClicked = false;
  String? _selectedType = 'All';
  String menuType = "";
  String data = '';

final List<String> _stockTypes = [
  'All',
  'By Employee',
];
void _onStockTypeChanged(String? newValue) {
  setState(() {
    _selectedType = newValue;
      _selectedType = newValue;
      isAllClicked = newValue == "All";
      isEmployeeClicked = newValue == "By Employee";
      emtyMethod(); 
    });

  debugPrint("Selected Type: $menuType");
}
void emtyMethod() {
  setState(() {
    empluyeeNameController.text = "";
    employeeSlNo = "";
  });
}
  
  @override
  Widget build(BuildContext context) {
    final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
    // final allAttendanceData = Provider.of<AttendanceProvider>(context).attendanceList;
    return Scaffold(
      appBar: CustomAppBar(title: "Attendance Report"),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.h),
                margin: EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w, bottom: 10.h),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 136, 195, 255),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                      color: const Color.fromARGB(255, 7, 125, 180), width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6.w),
                      spreadRadius: 2.r,
                      blurRadius: 5.r,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                   userType == "m" || userType == "a" ? Row(
                      children: [
                        Expanded(flex: 4, child: Text("Select Type",style:AllTextStyle.textFieldHeadStyle),),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 12,
                          child: Container(
                            margin: EdgeInsets.only(top: 5.h),
                          decoration: ContDecoration.contDecoration,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              value: _selectedType,
                              items: _stockTypes.map(
                                (type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: AllTextStyle.dropDownlistStyle,
                                  ),
                                ),
                              ).toList(),
                              onChanged: _onStockTypeChanged,
                              dropdownStyleData: DropdownStyleData(
                                padding: null,
                                maxHeight: 200.h,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 203, 247, 253),
                                ),
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 25.h,
                                padding: EdgeInsets.only(right: 6.w),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 25.h,
                                padding: EdgeInsets.only(left: 12.w),
                              ),
                            ),
                          ),
                         ),
                       ),
                      ],
                    ):Container(),
                  isEmployeeClicked == true ? Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text("Employee", style: AllTextStyle.textFieldHeadStyle),
                      ),
                      const Expanded(flex: 1, child: Text(":")),
                      Expanded(
                        flex: 12,
                        child: Container(
                          margin: EdgeInsets.only(top: 4.h),
                          height: 25.h,
                          decoration: ContDecoration.contDecoration,
                          child: CommonTypeAheadField<EmployeesModel>(
                          controller: empluyeeNameController,
                          suggestionList: allGetEmployeesData,
                          hintText: 'Select Employee',
                          selectedValueId: employeeSlNo,
                          onValueIdChanged: (id) {
                            setState(() {
                              employeeSlNo = id;
                            });
                          },
                          displayText: (e) => e.displayName,
                          valueId: (e) => e.employeeSlNo.toString(),
                        ),
                        ),
                      ),
                    ],
                  ):Container(),
                    SizedBox(
                      height: 35.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(right: 5.w),
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
                                        child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 14.r),
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
                              margin: EdgeInsets.only(left: 5.w),
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
                                        child: Icon(Icons.calendar_month,color: Color.fromARGB(221, 22, 51, 95), size: 14.r),
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
                  
                     Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(1.0.r),
                        child: InkWell(
                          onTap: () {
                            // AttendanceProvider().on();
                            // setState(() {
                            //   if(userType == "m" || userType == "a"){
                            //    Provider.of<AttendanceProvider>(context,listen: false).getAttendance(employeeSlNo??"", backEndFirstDate, backEndSecondtDate);
                            //   }else if(_selectedType == null || _selectedType == "All") {
                            //      Provider.of<AttendanceProvider>(context,listen: false).getAttendance(userWiseEmployeeId??"", backEndFirstDate, backEndSecondtDate);
                            //   }else if(_selectedType == "By Employee"){
                            //     Utils.showTopSnackBar(context, "Please Select Employee");
                            //      Provider.of<AttendanceProvider>(context,listen: false).getAttendance(employeeSlNo??"", backEndFirstDate, backEndSecondtDate);
                            //   }
                            // });
                            print("userWiseEmployeeId ==== $userWiseEmployeeId");
                            print("select employeeId ==== $employeeSlNo");
                            print('firstPickedDate $backEndFirstDate');
                            print('secondPickedDate $backEndSecondtDate');
                          },
                          child: Container(
                            height: 28.0.h,
                            width: 120.0.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5.0.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  spreadRadius: 2.r,
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
              // AttendanceProvider.isAttendanceLoading
              //   ? const Center(child: CircularProgressIndicator())
              //   : Container(
              //       height: MediaQuery.of(context).size.height / 1.43,
              //       width: double.infinity,
              //       padding: EdgeInsets.only(left: 6.w, right: 6.w,bottom: 18.h),
              //       child: allAttendanceData.isNotEmpty ? SizedBox(
              //         width: double.infinity,
              //         height: double.infinity,
              //         child: SingleChildScrollView(
              //           scrollDirection: Axis.vertical,
              //           child: SingleChildScrollView(
              //             scrollDirection: Axis.horizontal,
              //             child: DataTable(
              //               headingRowHeight: 20.h,
              //               dataRowHeight: 30.h,
              //               headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.primaryColor),
              //               showCheckboxColumn: false,
              //               border: TableBorder.all(color: Colors.grey.shade400, width: 1.w),
              //               columns: [
              //                 DataColumn(label: Expanded(child: Center(child: Text('Sl.', style: AllTextStyle.tableHeadTextStyle)))),
              //                 DataColumn(label: Expanded(child: Center(child: Text('Date', style: AllTextStyle.tableHeadTextStyle)))),
              //                 DataColumn(label: Expanded(child: Center(child: Text('Employee ID', style: AllTextStyle.tableHeadTextStyle)))),
              //                 DataColumn(label: Expanded(child: Center(child: Text('Employee Name', style: AllTextStyle.tableHeadTextStyle)))),
              //                 DataColumn(label: Expanded(child: Center(child: Text('In Time', style: AllTextStyle.tableHeadTextStyle)))),
              //                 DataColumn(label: Expanded(child: Center(child: Text('Out Time', style: AllTextStyle.tableHeadTextStyle)))),
              //                 // ⭐ TOTAL HOURS
              //                 //DataColumn(label: Expanded(child: Center(child: Text('Total Hours', style: AllTextStyle.tableHeadTextStyle)))),
              //                 // ⭐ OVERTIME
              //                 //DataColumn(label: Expanded(child: Center(child: Text('Overtime', style: AllTextStyle.tableHeadTextStyle)))),
              //                 DataColumn(label: Expanded(child: Center(child: Text('Location', style: AllTextStyle.tableHeadTextStyle)))),
              //               ],
              //               rows: List.generate(
              //                 allAttendanceData.length,
              //                 (int index) => DataRow(
              //                   color: index % 2 == 0
              //                       ? WidgetStateProperty.resolveWith(getColors)
              //                       : WidgetStateProperty.resolveWith(getColor),
              //                   cells: <DataCell>[
              //                     DataCell(Center(child: Text('${index + 1}'))),
              //                     DataCell(Center(child: Text('${allAttendanceData[index].date ?? ""}'))),
              //                     DataCell(Center(child: Text("${allAttendanceData[index].employeeId ?? ""}"))),
              //                     DataCell(Center(child: Text("${allAttendanceData[index].employeeName ?? ""}"))),
              //                     DataCell(Center(child: Text("${allAttendanceData[index].inTime ?? ""}"))),
              //                     DataCell(Center(child: Text("${allAttendanceData[index].outTime ?? ""}"))),
              //                     // ⭐ TOTAL HOURS
              //                     // DataCell(Center(
              //                     //   child: Text(
              //                     //     calculateTotalHours(
              //                     //       allAttendanceData[index].inTime,
              //                     //       allAttendanceData[index].outTime,
              //                     //     ),
              //                     //   ),
              //                     // )),
              //                     // ⭐ OVERTIME
              //                     // DataCell(Center(
              //                     //   child: Text(
              //                     //     calculateOvertime(
              //                     //       inTime: allAttendanceData[index].inTime,
              //                     //       outTime: allAttendanceData[index].outTime,
              //                     //       normalShiftStart: "$starTime", 
              //                     //       normalShiftEnd: "$endTime",    
              //                     //     ),
              //                     //   ),
              //                     // )),
              //                     // ⭐ LOCATION BUTTON
              //                     DataCell(
              //                       userType == "m" || userType == "a"
              //                           ? Center(
              //                               child: ElevatedButton(
              //                                 onPressed: () {
              //                                   final lat = allAttendanceData[index].lat;
              //                                   final lng = allAttendanceData[index].lan;
              //                                   if (lat != null && lng != null) {
              //                                     final Uri locationUrl = Uri.parse(
              //                                         "https://www.google.com/maps/search/?api=1&query=$lat,$lng");
              //                                     launchUrl(locationUrl, mode: LaunchMode.externalApplication);
              //                                   } else {
              //                                     ScaffoldMessenger.of(context).showSnackBar(
              //                                         const SnackBar(content: Text("Location data not available")));
              //                                   }
              //                                 },
              //                                 child: Icon(Icons.location_on, color: Colors.red, size: 18.r),
              //                                 style: ElevatedButton.styleFrom(
              //                                   backgroundColor: Colors.transparent,
              //                                   shadowColor: Colors.transparent,
              //                                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              //                                 ),
              //                               ),
              //                             )
              //                           : Container(),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //       :Align(
              //         alignment: Alignment.topCenter,
              //         child: Text("No Data Found",style: TextStyle(fontSize: 16.sp,color: Colors.red))
              //       ),
              //     ),
            ],
          ),
        ),
      ),
    );
  }
}

