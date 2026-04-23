import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:quickalert/quickalert.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget/custom_appbar.dart';

class AttendanceEntryScreen extends StatefulWidget {
  const AttendanceEntryScreen({super.key});

  @override
  State<AttendanceEntryScreen> createState() => _AttendanceEntryScreenState();
}

class _AttendanceEntryScreenState extends State<AttendanceEntryScreen> {
  bool isFinished = false;
  bool isFinishedTwo = false;
  bool isCheckInCompleted = false;

  @override
  void initState() {
    super.initState();
    // _loadCheckInStatus();
    // _checkAndResetCheckInStatus();
  }

  void _loadCheckInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isCheckInCompleted = prefs.getBool('isCheckInCompleted') ?? false;
    });
  }

  void _saveCheckInStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCheckInCompleted', value);
  }

  void _checkAndResetCheckInStatus() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    Future.delayed(durationUntilMidnight, () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isCheckInCompleted', false);
      setState(() {
        isCheckInCompleted = false;
      });
    });
  }


  final Dio _dio = Dio();
  Future<bool> checkInApi(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        "YOUR_CHECK_IN_API_URL",
        data: data,
      );

      print("Check In Response: ${response.data}");
      return response.statusCode == 200;

    } catch (e) {
      print("Check In Error: $e");
      return false;
    }
  }

  Future<bool> checkOutApi(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        "YOUR_CHECK_OUT_API_URL",
        data: data,
      );

      print("Check Out Response: ${response.data}");
      return response.statusCode == 200;

    } catch (e) {
      print("Check Out Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentTime = DateFormat.jm().format(DateTime.now());
    return Scaffold(
      appBar: CustomAppBar(title: "Attendance"),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.isOrder,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.r), bottomRight: Radius.circular(15.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              elevation: 9,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                              child: Container(
                                height: 130.h,
                                width: 160.w,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Image.asset(height: 25.h, width: 25.w, "images/checked.png"),
                                          SizedBox(width: 8.w),
                                          Text("Check In", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 35.w),
                                        child: Text(currentTime, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                                      ),
                                      SizedBox(height: 12.h),
                                      Spacer(),
                                      SizedBox(
                                        height: 35.h,
                                        child: Stack(
                                          children: [
                                            SwipeableButtonView(
                                              buttonText: isCheckInCompleted ? "        Checked In" : "      Check In",
                                              buttontextstyle: TextStyle(fontSize: 16.sp, color: Colors.white),
                                              buttonWidget: Icon(size: 18.sp, Icons.arrow_forward_ios_rounded, color: Colors.grey),
                                              activeColor: isCheckInCompleted ? Colors.red : AppColors.appColor,
                                              onWaitingProcess: () {
                                                if (!isCheckInCompleted) {
                                                  Future.delayed(const Duration(seconds: 2), () => setState(() => isFinished = true),
                                                  );
                                                }
                                              },
                                              isFinished: isCheckInCompleted ? false : isFinished,
                                              onFinish: isCheckInCompleted ? () {} : () async {

                                              String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
                                              String time = DateFormat("HH:mm:ss").format(DateTime.now());

                                              Map<String, dynamic> body = {
                                                "employee_id": "11", // dynamic করবা
                                                "date": date,
                                                "time": time,
                                                "type": "in"
                                              };

                                              bool success = await checkInApi(body);

                                              if (success) {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  title: 'Success!',
                                                  text: 'Check In Successfully!',
                                                  showConfirmBtn: false,
                                                  autoCloseDuration: const Duration(seconds: 3),
                                                );

                                                setState(() {
                                                  isFinished = false;
                                                  isCheckInCompleted = true;
                                                });

                                                _saveCheckInStatus(true);

                                              } else {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  title: 'Failed!',
                                                  text: 'Check In Failed!',
                                                );

                                                setState(() => isFinished = false);
                                              }
                                            }
                                            ),
                                            if (isCheckInCompleted)
                                              Positioned.fill(child: Container(color: Colors.transparent)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //SizedBox(width: 10.w),
                            Card(
                              elevation: 9,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                              child: Container(
                                height: 130.h,
                                width: 160.w,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          //Image.asset(height: 25.h, width: 25.w, "images/checked.png"),
                                          //SizedBox(width: 8.w),
                                          Text("⏰  Check Out", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 35.w),
                                        child: Text(currentTime, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                                      ),
                                      SizedBox(height: 12.h,),
                                      Spacer(),
                                      SizedBox(
                                        height: 35.h,
                                        child: SwipeableButtonView(
                                          buttonText: '       Check Out',
                                          buttontextstyle: TextStyle(fontSize: 16.sp, color: Colors.white),
                                          buttonWidget: Icon(size: 18.sp, Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                                          activeColor: AppColors.appColor,
                                          onWaitingProcess: () {
                                            Future.delayed(const Duration(seconds: 2), () => setState(() => isFinishedTwo = true),
                                            );
                                          },
                                          isFinished: isFinishedTwo,
                                          onFinish: () async {

                                          String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
                                          String time = DateFormat("HH:mm:ss").format(DateTime.now());

                                          Map<String, dynamic> body = {
                                            "employee_id": "11",
                                            "date": date,
                                            "time": time,
                                            "type": "out"
                                          };

                                          bool success = await checkOutApi(body);

                                          if (success) {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              title: 'Success!',
                                              text: 'Check Out Successfully!',
                                              showConfirmBtn: false,
                                              autoCloseDuration: const Duration(seconds: 3),
                                            );

                                            setState(() => isFinishedTwo = false);

                                          } else {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              title: 'Failed!',
                                              text: 'Check Out Failed!',
                                            );

                                            setState(() => isFinishedTwo = false);
                                          }
                                        }
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.isOrder,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(2),
                              },
                              border: TableBorder(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(child: Center(child: Text("SL", style: AllTextStyle.tableHeadTextStyle))),
                                    TableCell(child: Center(child: Text("Date", style: AllTextStyle.tableHeadTextStyle))),
                                    TableCell(child: Center(child: Text("Check In", style: AllTextStyle.tableHeadTextStyle))),
                                    TableCell(child: Center(child: Text("Check Out", style: AllTextStyle.tableHeadTextStyle))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.r),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 4), blurRadius: 8,),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(1.r),
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                    },
                                    border: TableBorder.symmetric(inside: BorderSide(color: Colors.teal)),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(child: Center(child: Text("${index+1}", style: AllTextStyle.attendDateTextStyle))),
                                          TableCell(child: Center(child: Text("2025-02-22", style: AllTextStyle.attendDateTextStyle))),
                                          TableCell(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("images/checked.png", height: 20.h, width: 20.w),
                                                SizedBox(width: 2.w),
                                                Text("08:00 AM", style: AllTextStyle.attendTrueTextStyle),
                                              ],
                                            ),
                                          ),
                                          TableCell(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                               // Image.asset("images/out.png", height: 16.h, width: 16.w, color: const Color.fromARGB(255, 240, 89, 89)),
                                                SizedBox(width: 5.w),
                                                Text("⏰00.00PM", style: TextStyle(color: Colors.red,fontSize: 14.0.sp,fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





///===
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:swipeable_button_view/swipeable_button_view.dart';
//
// import '../../../common_widget/custom_appbar.dart';
//
// class AttendanceEntryScreen extends StatefulWidget {
//   const AttendanceEntryScreen({super.key});
//
//   @override
//   State<AttendanceEntryScreen> createState() => _AttendanceEntryScreenState();
// }
//
// class _AttendanceEntryScreenState extends State<AttendanceEntryScreen> {
//   bool isFinished = false;
//   bool isFinishedTwo = false;
//   bool isCheckInCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCheckInStatus();
//     _checkAndResetCheckInStatus();
//   }
//
//   // SharedPreferences থেকে isCheckInCompleted লোড করুন
//   void _loadCheckInStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isCheckInCompleted = prefs.getBool('isCheckInCompleted') ?? false;
//     });
//   }
//
//   // চেক-ইন স্ট্যাটাস সেভ করুন
//   void _saveCheckInStatus(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isCheckInCompleted', value);
//   }
//
//   // মধ্যরাতে স্ট্যাটাস রিসেট করুন
//   void _checkAndResetCheckInStatus() async {
//     final now = DateTime.now();
//     final midnight = DateTime(now.year, now.month, now.day + 1);
//     final durationUntilMidnight = midnight.difference(now);
//
//     Future.delayed(durationUntilMidnight, () async {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isCheckInCompleted', false);
//       setState(() {
//         isCheckInCompleted = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String currentTime = DateFormat.jm().format(DateTime.now());
//     return Scaffold(
//       appBar: CustomAppBar(title: "Attendance Entry"),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Container(
//                 width: double.infinity.w,
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade600,
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(15.r),
//                       bottomRight: Radius.circular(15.r)),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0.r),
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 4.h),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 130.h,
//                               width: 160.w,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10.r)),
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 20.h),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Image.asset(height: 25.h, width: 25.w, "images/checked.png"),
//                                         SizedBox(width: 8.w),
//                                         Text("Check In",
//                                           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 4.h,),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 35.w),
//                                       child: Text(currentTime,
//                                         style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
//                                       ),
//                                     ),
//                                     SizedBox(height: 12.h),
//                                     Spacer(),
//                                     SizedBox(
//                                       height: 35.h,
//                                       child: Stack(
//                                         children: [
//                                           SwipeableButtonView(
//                                             buttonText: isCheckInCompleted
//                                                 ? "        Checked In"
//                                                 : "      Check In",
//                                             buttontextstyle: TextStyle(fontSize: 16.sp, color: Colors.white),
//                                             buttonWidget: Icon(size: 18.sp, Icons.arrow_forward_ios_rounded, color: Colors.grey),
//                                             activeColor: isCheckInCompleted ? Colors.red : Colors.teal.shade900,
//                                             onWaitingProcess: () {
//                                               if (!isCheckInCompleted) {
//                                                 Future.delayed(const Duration(seconds: 2),
//                                                       () => setState(() => isFinished = true),
//                                                 );
//                                               }
//                                             },
//                                             isFinished: isCheckInCompleted ? false : isFinished,
//                                             onFinish: isCheckInCompleted ? () {} : () {
//                                               QuickAlert.show(
//                                                 context: context,
//                                                 type: QuickAlertType.success,
//                                                 title: 'Success!',
//                                                 text: 'Check In Successfully!',
//                                                 showConfirmBtn: false,
//                                                 barrierDismissible: true,
//                                                 autoCloseDuration:
//                                                 const Duration(seconds: 3),
//                                               );
//                                               setState(() {
//                                                 isFinished = false;
//                                                 isCheckInCompleted = true;
//                                               });
//                                               _saveCheckInStatus(true);
//                                             },
//                                           ),
//                                           if (isCheckInCompleted)
//                                             Positioned.fill(child: Container(color: Colors.transparent)),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 20.w),
//                             Container(
//                               height: 130.h,
//                               width: 160.w,
//                               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 20.h),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Image.asset(height: 25.h, width: 25.w, "images/checked.png"),
//                                         SizedBox(width: 8.w,),
//                                         Text("Check Out", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
//                                       ],
//                                     ),
//                                     SizedBox(height: 4.h),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 35.w),
//                                       child: Text(currentTime, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
//                                     ),
//                                     SizedBox(height: 12.h),
//                                     Spacer(),
//                                     SizedBox(
//                                       height: 35.h,
//                                       child: SwipeableButtonView(
//                                         buttonText: '       Check Out',
//                                         buttontextstyle: TextStyle(fontSize: 16.sp, color: Colors.white),
//                                         buttonWidget: Icon(size: 18.sp, Icons.arrow_forward_ios_rounded,color: Colors.grey),
//                                         activeColor: Colors.teal.shade900,
//                                         onWaitingProcess: () {
//                                           Future.delayed(const Duration(seconds: 2), () => setState(() => isFinishedTwo = true));
//                                         },
//                                         isFinished: isFinishedTwo,
//                                         onFinish: () {
//                                           QuickAlert.show(
//                                             context: context,
//                                             type: QuickAlertType.success,
//                                             title: 'Success!',
//                                             text: 'Chech Out Successfully!',
//                                             showConfirmBtn: false,
//                                             barrierDismissible: true,
//                                             autoCloseDuration:
//                                             const Duration(seconds: 3),
//                                           );
//                                           setState(() => isFinishedTwo = false);
//                                         },
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8.h)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(top: 20.h),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.withOpacity(0.1),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.15),
//                                 offset: const Offset(0, 4),
//                                 blurRadius: 8,
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 12.h, bottom: 12.h, left: 35.w, right: 25.w),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Date", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                                 Text("Check In", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                                 Text("Check Out", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: 1,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(5.r),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.2),
//                                       offset: const Offset(0, 4),
//                                       blurRadius: 8,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(6.r),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         "2025-02-22",
//                                         style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1271B0), fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(width: 12.w),
//                                       Expanded(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Image.asset("images/checked.png", height: 20.h, width: 20.w),
//                                                 SizedBox(width: 2.w),
//                                                 Text(
//                                                   "08:00 AM",
//                                                   style: TextStyle(fontSize: 14.sp, color: const Color.fromARGB(255, 51, 189, 56), fontWeight: FontWeight.w600),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(width: 4.h),
//                                             Row(
//                                               children: [
//                                                 Image.asset("images/checked.png", height: 20.h,width: 20.w, color: const Color.fromARGB(255, 240, 89, 89)),
//                                                 SizedBox(width: 2.w),
//                                                 Text(
//                                                   "00.00",
//                                                   style: TextStyle(fontSize: 14.sp, color: const Color.fromARGB(255, 240, 89, 89), fontWeight: FontWeight.w600),
//                                                 ),
//                                                 SizedBox(width: 12.w)
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



///=====
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:barishal_surgical/common_widget/custom_appbar.dart';
//
// class AttendanceEntryScreen extends StatefulWidget {
//   const AttendanceEntryScreen({super.key});
//
//   @override
//   _AttendanceEntryScreenState createState() => _AttendanceEntryScreenState();
// }
//
// class _AttendanceEntryScreenState extends State<AttendanceEntryScreen> {
//   bool isInTime = false;
//   bool isOutTime = false;
//   Position? _currentPosition;
//   String? selectedAttendanceType;
//   bool isLoading = false;
//
//   Future<void> _handleAttendanceSelection(bool isForInTime) async {
//     setState(() {
//       isInTime = isForInTime;
//       isOutTime = !isForInTime;
//       selectedAttendanceType = isForInTime ? "In Time" : "Out Time";
//     });
//   }
//
//   Future<void> _submitAttendance() async {
//     if (selectedAttendanceType == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select In Time or Out Time!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     Position? position = await _getCurrentLocation();
//     if (position == null) {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     setState(() {
//       _currentPosition = position;
//       isLoading = false;
//     });
//
//     print("Attendance Submitted!");
//     print("$selectedAttendanceType: ${position.latitude}, ${position.longitude}");
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.teal.shade900,
//         content: Center(
//           child: Text(
//             "$selectedAttendanceType Marked!Location: ${position.latitude}, ${position.longitude}",
//           ),
//         ),
//       ),
//     );
//
//     // এখানে API call করতে পারেন
//   }
//
//   Future<Position?> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location services are disabled!")),
//       );
//       return null;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permissions are permanently denied!")),
//         );
//         return null;
//       }
//     }
//
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "Attendance Entry"),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_currentPosition != null)
//               Text(
//                 "Your Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//             const SizedBox(height: 20),
//             SwitchListTile(
//               title: const Text("In Time", style: TextStyle(fontSize: 16)),
//               value: isInTime,
//               onChanged: (value) {
//                 if (value) _handleAttendanceSelection(true);
//               },
//             ),
//             SwitchListTile(
//               title: const Text("Out Time", style: TextStyle(fontSize: 16)),
//               value: isOutTime,
//               onChanged: (value) {
//                 if (value) _handleAttendanceSelection(false);
//               },
//             ),
//             const SizedBox(height: 30),
//             Center(
//               child: isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 onPressed: _submitAttendance,
//                 child: const Text("Submit Attendance"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
