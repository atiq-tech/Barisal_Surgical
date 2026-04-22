import 'dart:core';

import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/const_model.dart';
import '../utils/utils.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  var errUsername = "";
  var errPassword = "";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences? sharedPreferences;
  fetchLogin() async {
    String link = "${baseUrl}login";
    try {
      final formData = FormData.fromMap({
        "username": _usernameController.text,
        "password": _passwordController.text
      });
      final response = await Dio().post(link, data: formData);
      var item = response.data;
      errUsername = "";
      errPassword = "";
      print('Log In Response Data=== $item');
      print("Message Response=== ${item["message"]}");
      if (item["success"] == true) {
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences?.setString('token', "${item["token"]}");
        sharedPreferences?.setString('sessionId', "${item["session_id"]}");
        sharedPreferences?.setString("userName", "${item["data"]["name"]}");
        sharedPreferences?.setString("userId", "${item["data"]["id"]}");
        sharedPreferences?.setString("userType", "${item["data"]["userType"]}");
        sharedPreferences?.setString('employeeId', "${item["data"]["employee_id"]}");
        sharedPreferences?.setString('employeeName', "${item["data"]["employee_name"]}");
        sharedPreferences?.setString('image_name', "${item["data"]["image_name"]}");
        sharedPreferences?.setString('employeePhone', "${item["data"]["employee_phone"]}");
        sharedPreferences?.setString('customerId', "${item["data"]["customerId"]}");
        sharedPreferences?.setString("branchName", "${item["data"]["branchName"]}");
        sharedPreferences?.setString("userBranchId", "${item["data"]["user_branch_id"]}");
        sharedPreferences?.setString("loginAddress", "${item["data"]["login_address"]}");
        sharedPreferences?.setString("branchAddress", "${item["data"]["branchAddress"]}");
        var box = Hive.box('profile');
        box.put('name', "${item["data"]["name"]}");
        box.put('token', "${item["token"]}");


        print('tokeeeen=====${sharedPreferences?.getString('token')}');
        print('employeeId=====${sharedPreferences?.getString('employeeId')}');
        print('sessionId===== ${sharedPreferences?.getString('sessionId')}');
        print('userName===== ${sharedPreferences?.getString('userName')}');

        GetStorage().write("token", "${item["token"]}");
        GetStorage().write("id", "${item["data"]["id"]}");
        GetStorage().write("name", "${item["data"]["name"]}");
        GetStorage().write("usertype", "${item["data"]["usertype"]}");
        GetStorage().write("customerId", "${item["data"]["customerId"]}");
        GetStorage().write("image_name", "${item["data"]["image_name"]}");
        GetStorage().write("branch", "${item["data"]["branch"]}");
        GetStorage().write("branch_name", "${item["data"]["branch_name"]}");

        ///access for sales module
        if(item["access"]=="null"||item["access"]==null){
           item["access"]=[];
        }else{
          sharedPreferences?.setString("sales", "${item["access"].contains("sales")}");
          sharedPreferences?.setString("salesinvoice", "${item["access"].contains("salesinvoice")}");
          sharedPreferences?.setString("salesrecord", "${item["access"].contains("salesrecord")}");
          sharedPreferences?.setString("customerlist", "${item["access"].contains("customerlist")}");
          sharedPreferences?.setString("order_entry", "${item["access"].contains("order")}");
          sharedPreferences?.setString("orderRecord", "${item["access"].contains("order_record")}");
          sharedPreferences?.setString("customer", "${item["access"].contains("customer")}");
          sharedPreferences?.setString("productlist", "${item["access"].contains("productlist")}");
          sharedPreferences?.setString("category", "${item["access"].contains("category")}");
          sharedPreferences?.setString("currentStock", "${item["access"].contains("currentStock")}");
          sharedPreferences?.setString("attendanceEntry", "${item["access"].contains("attendance_entry")}");
          sharedPreferences?.setString("attendanceRecord", "${item["access"].contains("attendanceList")}");
          sharedPreferences?.setString("visitEntry", "${item["access"].contains("visit")}");
          sharedPreferences?.setString("visitList", "${item["access"].contains("visit_list")}");
        }
         
         
        setState(() {
          isLogInBtnClk = false;
        });
        _usernameController.text = "";
        _passwordController.text = "";

        Utils.showMotionToast(
        context,
        title: "${item["message"]}!",
        description: "Welcome to Barisal Surgical Sales Management App",
        icon: Icons.check_circle,
        duration: const Duration(seconds: 3),
      );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationBarView()));
      }else{
        setState(() {
          isLogInBtnClk = false;
          isError=true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Center(child: Text("${item["message"]}",style: const TextStyle(color: Colors.white),))));
        print("errors ${item['errors']['username']}");
        errUsername = item['errors']['username'];
        errPassword = item['errors']['password'];
      }
    } catch (e) {
      setState(() {
        isLogInBtnClk = false;
        isError=true;
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     backgroundColor: Colors.green.shade900,
        //     content: Center(child: Text("$e",style: const TextStyle(color: Colors.white),))));
      });
    }
  }

  String? user_name;
   bool _isObscure = true;
   final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: InkWell(onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("images/bg5.jpg"),fit: BoxFit.fill)),
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 40.0.h,
                        width: MediaQuery.of(context).size.width,
                        decoration:  BoxDecoration(color: AppColors.appColor),
                        child: Center(
                          child: Text("Sales Management Apps",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0.sp, color: Colors.white),
                       ))),
                      SizedBox(height: 30.h),
                      Container(
                        height: 120.0.h,
                        width: 210.0.w,
                        padding: EdgeInsets.all(8.0.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0.r),
                          border: Border.all(color: Colors.white, width: 2.0.w),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0.r),
                          child: Image.asset( "images/brsgcl.png",fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Center(
                        child: SizedBox(
                          height: 30.0.h,
                          width: 300.0.w,
                          child: Marquee(
                            text: 'Welcome to Barisal Surgical',
                            style: TextStyle(fontSize: 22.0.sp, fontWeight: FontWeight.w600, color: Colors.cyan.shade400),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 50.0,
                            velocity: 50.0,
                            pauseAfterRound: Duration(seconds: 1),
                            startPadding: 10.0,
                            accelerationDuration: Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Center(
                        child: Text(
                          "Barisal Surgical",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0.sp, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Container(
                          height: errPassword.isNotEmpty ? MediaQuery.of(context).size.height/2.3 : MediaQuery.of(context).size.height/2.6,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                          padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, top: 10.0.h),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white, width: 2.0.w),
                            borderRadius: BorderRadius.circular(10.0.r),
                           ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                 Center(
                                  child: Text(
                                    "Sign In Form",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22.0.sp, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),
                                SizedBox(
                                  height: errUsername.isNotEmpty ? 65.0.h:45.0.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 14.0.h),
                                            fillColor: Colors.white.withOpacity(0.9),
                                            filled: true,
                                            hintText: "User Name",
                                            hintStyle: TextStyle(fontSize: 14.0.sp),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1.w, color: Color.fromARGB(255, 155, 152, 152)),
                                              borderRadius: BorderRadius.circular(6.0.r),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1.w, color: Color.fromARGB(255, 185, 185, 185)),
                                              borderRadius: BorderRadius.circular(6.0.r),
                                            ),
                                          ),
                                          onTap: () async {},
                                        ),
                                      ),
                                      if (errUsername.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.0.h, left: 8.0.w),
                                          child: Text(errUsername,style: TextStyle(fontSize: 14.0.sp, color: Colors.red)),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0.h),
                                SizedBox(
                                  height: errPassword.isNotEmpty ? 65.0.h:45.0.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          obscureText: _isObscure,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 14.0.h),
                                            fillColor: Colors.white.withOpacity(0.9),
                                            filled: true,
                                            suffixIcon: IconButton(
                                              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _isObscure = !_isObscure;
                                                });
                                              },
                                            ),
                                            suffixIconColor: Colors.grey,
                                            hintText: "Password",
                                            hintStyle: TextStyle(fontSize: 14.0.sp),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1.w, color: Color.fromARGB(255, 155, 152, 152)),
                                              borderRadius: BorderRadius.circular(6.0.r),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1.w, color: Color.fromARGB(255, 185, 185, 185)),
                                              borderRadius: BorderRadius.circular(6.0.r),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (errPassword.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.0.h, left: 8.0.w),
                                          child: Text(errPassword,style: TextStyle(fontSize: 14.0.sp, color: Colors.red)),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.0.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () async {
                                      try {
                                        final List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
                                        if (connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi)) {
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            isLogInBtnClk = true;
                                          });

                                          if (_formkey.currentState!.validate()) {
                                            await fetchLogin();
                                          } else {
                                            setState(() {
                                              isError = false;
                                              isLogInBtnClk = false;
                                            });
                                          }
                                        } else {
                                          Utils.errorSnackBar(context, "Please check your internet connection");
                                        }
                                      } catch (e) {
                                        Utils.errorSnackBar(context, "Connectivity Error: $e");
                                      }
                                    },
                                    child: Card(
                                      elevation: 9.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.0.r),
                                      ),
                                      child: Container(
                                        height: 45.0.h,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: AppColors.buttonColor,
                                          borderRadius: BorderRadius.circular(6.0.r),
                                        ),
                                        child: Center(
                                          child: isLogInBtnClk ? SizedBox(height: 20.0.h, width: 20.0.w,
                                            child: CircularProgressIndicator(color: Colors.white)):
                                          Text("Login", style: AllTextStyle.saveButtonTextStyle),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0.h),
                              ],
                            ),
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: 20.0.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: AppColors.appColor),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Developed by", style: TextStyle(color: Colors.white, fontSize: 12.0.sp)),
                SizedBox(width: 5.0.w),
                RichText(
                 text: TextSpan(text: "Link-Up Technology Ltd.", style: TextStyle(color: Colors.cyanAccent, fontSize: 12.0.sp),
                  recognizer: TapGestureRecognizer()
                   ..onTap = () {
                    launch("https://linktechbd.com/#");
                 })),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool isLogInBtnClk = false;
  bool isError=false;
}
