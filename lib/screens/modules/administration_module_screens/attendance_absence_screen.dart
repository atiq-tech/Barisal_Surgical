import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:barishal_surgical/auth/login_screen.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceAbsencePage extends StatefulWidget {
  const AttendanceAbsencePage({super.key});

  @override
  State<AttendanceAbsencePage> createState() => _AttendanceAbsencePageState();
}

class _AttendanceAbsencePageState extends State<AttendanceAbsencePage> {
String officeStartTime = "";
String officeEndTime = "";
String lateAbsentTime = "";

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
  if (response.data is List) {
    var data = response.data[0];
    setState(() {
      officeStartTime = data['start_time'] ?? "";
      lateAbsentTime = data['late_absent_time'] ?? "";
      officeEndTime = data['end_time'] ?? "";
    });
  } else if (response.data is Map) {
    var data = response.data;
    setState(() {
      officeStartTime = data['start_time'] ?? "";
      lateAbsentTime = data['late_absent_time'] ?? "";
      officeEndTime = data['end_time'] ?? "";
    });
  } else {
    print("Unknown data format!");
  }
  print("officeStartTime => $officeStartTime");
  print("lateAbsentTime => $lateAbsentTime");
  print("officeEndTime => $officeEndTime");
}
 else {
      print("Failed to fetch company profile: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching company profile: $e");
  }
}


  String userId = "";
  String userName = "";
  String userType = "";
  bool? attendanceInStatus;
  bool? attendanceOutStatus;
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userId = "${sharedPreferences?.getString('userMainId')}";
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    attendanceInStatus = sharedPreferences?.getBool('attendanceInStatus');
    attendanceOutStatus = sharedPreferences?.getBool('attendanceOutStatus');

    print("userEmployeeId==== $userId");
    print("userName==== $userName");
    print("userType==== $userType");
    print("attendanceInStatus==== $attendanceInStatus");
    print("attendanceOutStatus==== $attendanceOutStatus");
  }

  String latitude = "";
  String longitude = "";
  String address = "Fetching address...";
  StreamSubscription<Position>? positionStream;
  String currentTime = DateFormat("HH:mm:ss").format(DateTime.now());


  @override
  void initState() {
    getCompanyProfile();
    _initializeData();
    super.initState();
    _startLocationTracking();
    print("Current Time: $currentTime");
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        latitude = "Service Disabled";
        longitude = "Service Disabled";
        address = "Location Service Disabled";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          latitude = "Permission Denied";
          longitude = "Permission Denied";
          address = "Permission Denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        latitude = "Permission Denied Forever";
        longitude = "Permission Denied Forever";
        address = "Permission Denied Forever";
      });
      return;
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((Position position) async {
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });

      await _getAddressFromLatLng(position.latitude, position.longitude);

      print("Live Latitude: $latitude, Longitude: $longitude ✅");
    });
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      Placemark place = placemarks[0];

      setState(() {
        address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        address = "Failed to get address";
      });
    }
  }

  // void markPresent(BuildContext context) {
  //   print("Present Given ✅ at $latitude, $longitude ($address)");

  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
  //     (route) => false,
  //   );
  // }

  // void markAbsent(BuildContext context) {
  //   print("Absent Marked ❌ at $latitude, $longitude ($address)");

  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
  //     (route) => false,
  //   );
  // }
  // void markPresent(BuildContext context) {
  //   String currentTime = DateFormat("hh:mm a").format(DateTime.now());
  //   print("Present Given ✅ at $latitude, $longitude ($address) on $currentTime");

  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
  //     (route) => false,
  //   );
  // }

  // void markAbsent(BuildContext context) {
  //   String currentTime = DateFormat("hh:mm a").format(DateTime.now());
  //   print("Absent Marked ❌ at $latitude, $longitude ($address) on $currentTime");

  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
  //     (route) => false,
  //   );
  // }
//================
//   String getLeaveStatus({
//   required String officeStartTime,
//   required String lateAbsentTime,
// }) {
//   DateTime now = DateTime.now();
//   DateTime currentTime = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     int.parse(now.hour.toString().padLeft(2, '0')),
//     int.parse(now.minute.toString().padLeft(2, '0')),
//     int.parse(now.second.toString().padLeft(2, '0')),
//   );

//   List<String> startParts = officeStartTime.split(":");
//   DateTime officeStart = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     int.parse(startParts[0]),
//     int.parse(startParts[1]),
//     int.parse(startParts[2]),
//   );

//   List<String> lateParts = lateAbsentTime.split(":");
//   DateTime lateAbsent = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     int.parse(lateParts[0]),
//     int.parse(lateParts[1]),
//     int.parse(lateParts[2]),
//   );

//   if (currentTime.isBefore(officeStart)) {
//     return "P"; // আগেই এসেছে
//   } else if (currentTime.isAfter(officeStart) &&
//       currentTime.isBefore(lateAbsent)) {
//     return "L"; // Late
//   } else {
//     return "LA"; // Late Absent
//   }
// }


  // Present
  bool presentBtnClk = false;
  Future<String> markPresent(context) async {
    String link = "${baseUrl}save_attendance";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currentTime = DateFormat("HH:mm:ss").format(DateTime.now());

  //   String leaveStatus = getLeaveStatus(
  //   officeStartTime: officeStartTime,
  //   lateAbsentTime: lateAbsentTime,
  // );

  //print("Calculated Leave Status => $leaveStatus");

    try {
      var response = await Dio().post(
        link,
        data: {
          "leaveStatus": "P",
          "inTime": currentTime,
          "outTime": null,
          "userId": sharedPreferences.getString("userMainId") ?? "",
          "employeeId": sharedPreferences.getString("employeeId") ?? "",
          "lat": latitude,
          "lan": longitude,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            "Cookie": "ci_session=${sharedPreferences.getString("sessionId")}",
          },
        ),
      );

      var item = response.data;
      print("Present API Response: $item");

      if (item["success"] == true) {
        setState(() {
          presentBtnClk = false;
        });
        sharedPreferences.setBool("attendanceInStatus", true);
        CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),(route) => false,
        );
        return "true";
      } else {
        setState(() {
          presentBtnClk = false;
        });
        Utils.showTopSnackBar(context, "${item["message"]}");
        return "false";
      }
    } catch (e) {
      setState(() {
        presentBtnClk = false;
      });
      print("Exception caught: $e");
      Utils.showTopSnackBar(context, "Something went wrong: $e");
      return "false";
    }
  }

  // Absent
  bool absentBtnClk = false;
  Future<String> markAbsent(context) async {
    String link = "${baseUrl}save_attendance";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currentTime = DateFormat("HH:mm:ss").format(DateTime.now());
    try {
      var response = await Dio().post(
        link,
        data: {
          "leaveStatus": "A",
          "inTime": null,
          "outTime": currentTime,
          "userId": sharedPreferences.getString("userMainId") ?? "",
          "employeeId": sharedPreferences.getString("employeeId") ?? "",
          "lat": latitude,
          "lan": longitude,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            "Cookie": "ci_session=${sharedPreferences.getString("sessionId")}",
          },
        ),
      );

      var item = response.data;
      print("Absent API Response: $item");

      if (item["success"] == true) {
        setState(() {
          absentBtnClk = false;
        });
        sharedPreferences.setBool("attendanceInStatus", true);
        CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),(route) => false,
        );
        return "true";
      } else {
        setState(() {
          absentBtnClk = false;
        });
        Utils.showTopSnackBar(context, "${item["message"]}");
        return "false";
      }
    } catch (e) {
      setState(() {
        absentBtnClk = false;
      });
      print("Exception caught: $e");
      Utils.showTopSnackBar(context, "Something went wrong: $e");
      return "false";
    }
  }

  // Absent
  bool outAttendBtnClk = false;
  Future<String> outAttendance(context) async {
    String link = "${baseUrl}out_attendance";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currentTime = DateFormat("HH:mm:ss").format(DateTime.now());
    try {
      var response = await Dio().post(
        link,
        data: {
          "employeeId": sharedPreferences.getString("employeeId") ?? "",
          "lat_out": latitude,
          "lan_out": longitude,     
          "out_time":currentTime,
          "late_time":""
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            "Cookie": "ci_session=${sharedPreferences.getString("sessionId")}",
          },
        ),
      );

      var item = response.data;
      print("Absent API Response: $item");
      if (item["success"] == true) {
        setState(() {
          outAttendBtnClk = false;
        });
        sharedPreferences.setBool("attendanceOutStatus", item["status"]["attendanceOutStatus"]);
        print('attendanceOutStatus from API===== ${sharedPreferences.getBool('attendanceOutStatus')}');
        CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
        Navigator.pushAndRemoveUntil(
          context,MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),(route) => false,
        );
        return "true";
      } else {
        setState(() {
          outAttendBtnClk = false;
        });
        Utils.showTopSnackBar(context, "${item["message"]}");
        return "false";
      }
    } catch (e) {
      setState(() {
        outAttendBtnClk = false;
      });
      print("Exception caught: $e");
      Utils.showTopSnackBar(context, "Something went wrong: $e");
      return "false";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.appColor,
        title: Text(
          "Present and Absent",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24.sp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const LogInPage()),(route) => false,
            );
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg4.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Present Button
                  attendanceInStatus == false ? InkWell(
                    onTap: () async {
                      Utils.closeKeyBoard(context);
                      print("Tapped Present");
                      if (!presentBtnClk) {
                        setState(() {
                          presentBtnClk = true;
                        });
                        markPresent(context);
                      }
                      setState(() {});
                    },
                    child: Card(
                      color: Colors.green.withOpacity(0.4.w),
                      child: Container(
                        height: 110.0.h,
                        width: 110.0.w,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.4.w),
                          borderRadius: BorderRadius.circular(10.0.r),
                          border: Border.all(color: Colors.white, width: 3.0.w),
                        ),
                        child: Center(
                          child: presentBtnClk
                            ? SizedBox(
                              height: 30.0.h,
                              width: 30.0.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("images/present.png"),
                                  height: 40.0.h,
                                  width: 40.0.w,
                                ),
                                Text(
                                  "Present",
                                  style: AllTextStyle.saveButtonTextStyle,
                                ),
                              ],
                            ),
                        ),
                      ),
                    ),
                  ):
                 //attendanceOutStatus == false || attendanceOutStatus == null ?
                  InkWell(
                    onTap: () async {
                      Utils.closeKeyBoard(context);
                      print("Tapped Out Time");
                      if (!outAttendBtnClk) {
                        setState(() {
                          outAttendBtnClk = true;
                        });
                        outAttendance(context);
                      }
                      setState(() {});
                    },
                    child: Card(
                      color: Colors.green.withOpacity(0.4.w),
                      child: Container(
                        height: 110.0.h,
                        width: 110.0.w,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.4.w),
                          borderRadius: BorderRadius.circular(10.0.r),
                          border: Border.all(color: Colors.white, width: 3.0.w),
                        ),
                        child: Center(
                          child: outAttendBtnClk
                            ? SizedBox(
                              height: 30.0.h,
                              width: 30.0.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("images/present.png"),
                                  height: 40.0.h,
                                  width: 40.0.w,
                                ),
                                Text(
                                  "Out Time",
                                  style: AllTextStyle.saveButtonTextStyle,
                                ),
                              ],
                            ),
                        ),
                      ),
                    ),
                  ),
                  //:SizedBox(),
                  SizedBox(width: 10.w),
                  // ❌ Absent Button
                  InkWell(
                    onTap: () async {
                      Utils.closeKeyBoard(context);
                      print("Tapped Absent");
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: AppColors.appColor,
                              width: 6.w,
                            ),
                          ),
                          title: const Text(
                            "Confirmation!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "Are you sure you want to mark Absent?",
                          ),
                          actions: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.green,
                                  width: 2.w,
                                ),
                                foregroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed:
                                  () => Navigator.pop(context, false),
                              child: const Text("No"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.red,
                                  width: 2.w,
                                ),
                                foregroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        if (!absentBtnClk) {
                          setState(() {
                            absentBtnClk = true;
                          });
                          markAbsent(context);
                        }
                        setState(() {});
                      }
                    },
                    child: Card(
                      color: Colors.red.withOpacity(0.4.w),
                      elevation: 9,
                      child: Container(
                        height: 110.0.h,
                        width: 110.0.w,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.4.w),
                          borderRadius: BorderRadius.circular(10.0.r),
                          border: Border.all(color: Colors.white, width: 3.0.w),
                        ),
                        child: Center(
                          child: absentBtnClk
                            ? SizedBox(
                              height: 30.0.h,
                              width: 30.0.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: const AssetImage("images/absence.png"),
                                  height: 40.0.h,
                                  width: 40.0.w,
                                ),
                                Text("Absent", style: AllTextStyle.saveButtonTextStyle),
                              ],
                            ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}