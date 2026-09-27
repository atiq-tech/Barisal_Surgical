import 'dart:io';
import 'dart:math';
import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/const_model.dart';
import '../../../utils/custom_image.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _currentPController = TextEditingController();
  final TextEditingController _newPController = TextEditingController();
  final TextEditingController _confirmPController = TextEditingController();
  bool _isObscureCP = true;
  bool _isObscureNP = true;
  bool _isObscureCnFP = true;
  bool isLoading = false;
  bool isLoadingPChange = false;

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    userImage = "${sharedPreferences?.getString('userImage')}";
    branchName = "${sharedPreferences?.getString('branchName')}";
    branchAddress = "${sharedPreferences?.getString('branchAddress')}";
    print("profile userName====$userName");
    print("profile userImage====$userImage");
    print("profile branchName====$branchName");
    print("profile branchAddress====$branchAddress");
    setState(() {
    });
  }
  String? userName = "";
  String? userImage = "";
  String? branchName = "";
  String? branchAddress = "";

  XFile? imageFile;
  File? file;
  chooseImageFrom() async {
    ImagePicker picker = ImagePicker();
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    file = File("${imageFile?.path}");
    setState(() {

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
    _initLocation();
    _initializeData();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      scrolledUnderElevation: 0,
      leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationBarView()));
          },
          child: Icon(Icons.arrow_back, size: 22.0.sp,color: Colors.white)),
      elevation: 0.0,
      backgroundColor: AppColors.appColor,
      title: const Text("My Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500))),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10.0.r),
        child:  SingleChildScrollView(
          child: Column(
              children: [
                Center(
                  child: Container(
                    height: 140.h,
                    width: 150.w,
                    margin: EdgeInsets.only(top: 10.h,bottom: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade900,width: 2.5.w),
                      borderRadius:BorderRadius.circular(100.r),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: Container(
                            padding: EdgeInsets.all(8.0.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                if (imageFile == null) {
                                  return Container(
                                    height: 120.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: CustomImage(
                                        path: userImage == 'null' ? null : '$imageBaseUrl$userImage',
                                        height: 120.h,
                                        width: 120.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: Image(
                                    image: FileImage(File("${imageFile?.path}")),
                                    height: 120.h,
                                    width: 120.w,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5.h,
                          right: 0.w,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                              });
                              chooseImageFrom();
                            },
                            child: Container(
                              height: 35.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal.shade900,width: 2.5.w),
                                borderRadius: BorderRadius.circular(100.r),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.camera_alt, size: 18.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.teal.shade900, width: 2.5.w),
                    fixedSize: Size(double.infinity, 35.h),
                    padding: EdgeInsets.all(5.r),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null                          // লোডিং থাকলে আবার ক্লিক করতে দিবে না
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await changeProfile(image: file);   // ← await দিন (যদি async হয়)
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: CircularProgressIndicator(
                            color: Colors.teal.shade900,     // ← সাদার বদলে টিল কালার দিন
                            strokeWidth: 2.5,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                          child: Text(
                            "Image Upload",
                            style: AllTextStyle.menuHeadTextStyle,
                          ),
                        ),
                ),
              ),
                SizedBox(height: 5.h),
                Container(
                    padding: EdgeInsets.all(10.0.r),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal.shade900),
                        borderRadius: BorderRadius.circular(10.0.r)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Username        :  ",style: AllTextStyle.profileTextStyle),
                            Text("$userName",style: TextStyle(color: Colors.black,fontSize: 12.sp)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Branch Name  :  ",style: AllTextStyle.profileTextStyle),
                            Text("$branchName",style: TextStyle(color: Colors.black,fontSize: 12.sp)),
                          ],
                        ),
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Branch\nLocation          :  ",
                            style: AllTextStyle.profileTextStyle,
                          ),
                          Expanded(
                            child: Text(
                              "$branchAddress",
                              style: TextStyle(fontSize: 12.0.sp),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      ],
                    )),
                 SizedBox(height: 10.0.h),
                Container(
                  padding: EdgeInsets.all(5.0.r),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade900),
                      borderRadius: BorderRadius.circular(10.0.r)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 6,child: Text("Current Password", style: AllTextStyle.profileTextStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 9,
                            child: SizedBox(
                              height: 35.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                obscureText: _isObscureCP,
                                onChanged: (value) {
                                  setState(() {
                                    _isObscureCP = true;
                                  });
                                },
                                style: TextStyle(fontSize: 13.sp),
                                controller: _currentPController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10.0.w),
                                      child: Icon(_isObscureCP ? Icons.visibility : Icons.visibility_off,color: Colors.grey,size: 16.0.r),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureCP = !_isObscureCP;
                                      });
                                    },
                                  ),
                                  suffixIconColor: Colors.grey,
                                  hintText: "Current Password",
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0.h),
                      Row(
                        children: [
                          Expanded(flex: 6, child: Text("New Password", style: AllTextStyle.profileTextStyle)),
                          Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 9,
                            child: SizedBox(
                              height: 35.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                obscureText: _isObscureNP,
                                onChanged: (value) {
                                  setState(() {
                                    _isObscureNP = true;
                                  });
                                },
                                style: TextStyle(fontSize: 13.sp),
                                controller: _newPController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10.0.w),
                                      child: Icon(_isObscureNP ? Icons.visibility : Icons.visibility_off,color: Colors.grey,size: 16.0.r),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureNP = !_isObscureNP;
                                      });
                                    },
                                  ),
                                  suffixIconColor: Colors.grey,
                                  hintText: "New Password",
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0.h),
                      Row(
                        children: [
                          Expanded(flex: 6, child: Text("Confirm Password", style: AllTextStyle.profileTextStyle)),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 9,
                            child: SizedBox(
                              height: 35.0.h,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                obscureText: _isObscureCnFP,
                                onChanged: (value) {
                                  setState(() {
                                    _isObscureCnFP = true;
                                  });
                                },
                                style: TextStyle(fontSize: 13.h),
                                controller: _confirmPController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10.0.w),
                                      child: Icon(_isObscureCnFP ? Icons.visibility : Icons.visibility_off,color: Colors.grey,size: 16.0.r),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureCnFP = !_isObscureCnFP;
                                      });
                                    },
                                  ),
                                  suffixIconColor: Colors.grey,
                                  hintText: "Confirm Password",
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                                    borderRadius: BorderRadius.circular(5.0.r),
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
                Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(top: 20.0.h, bottom: 20.0.h),
                  child: InkWell(
                    onTap: () async {
                      if (_newPController.text != _confirmPController.text) {
                        Utils.showTopSnackBar(context, "New Password and Confirm Password do not match.");
                        return;
                      }
                      setState(() {
                        isLoadingPChange = true;
                      });
                      try {
                        await fetchPasswordChange(          
                          _currentPController.text,
                          _newPController.text,
                          _confirmPController.text,
                          context,
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoadingPChange = false;
                          });
                        }
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0.r),
                      ),
                      elevation: 9.0,
                      child: Container(
                        height: MediaQuery.of(context).size.width / 9,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade900,
                          borderRadius: BorderRadius.circular(100.0.r),
                        ),
                        child: Center(
                          child: isLoadingPChange
                              ? SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,         
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text("SAVE",style: AllTextStyle.saveButtonTextStyle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ]),
        ),
      ),
    );
  }
  changeProfile({File? image}) async {
  print("image======  $image");

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String link = "${baseUrl}uploadUserImage";

  try {
    if (image == null) {
      print("Image is null");
      return "false";
    }

    final formData = FormData.fromMap({
      'user_image': await MultipartFile.fromFile(
        image.path,
        filename: "${Random().nextInt(900000000)}.jpg",
      ),
    });

    final response = await Dio().post(
      link,
      data: formData,
      options: Options(
        headers: {
          // Content-Type দিবেন না
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        },
        responseType: ResponseType.plain,   // ← এটাই মূল সমাধান
      ),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.data}");

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    if (response.statusCode == 200 && response.data.toString().trim() == "Image uploaded") {
      CustomSnackBar.showTopSnackBar(context, "Image uploaded");
      return "true";
    } else {
      CustomSnackBar.showTopSnackBar(context, "Upload failed");
      return "false";
    }
  } catch (e) {
    print("Error message $e");

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    Utils.showTopSnackBar(context, "Something went wrong");
    return e.toString();
  }
}

  fetchPasswordChange(String oldPass,String newPass,String confirmPass,  BuildContext context) async {

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}passwordChange";
     try {
    final formData = FormData.fromMap({
      "current_password": oldPass.trim(),
      "password": newPass.trim(),
      "confirm_password": confirmPass.trim(),
    });
    final response = await Dio().post(link, data: formData,
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }),);
    var item = response.data;
    print("change password====$item");
    if (item["success"] == true) {
      setState(() {
        isLoadingPChange = false;
      });
      emptyMethod();
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      return "true";
      // Navigator.pop(context);
    } else {
      setState(() {
        isLoadingPChange = false;
      });
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      return "false";
    }
    } catch (e) {
      Utils.showTopSnackBar(context, "Something went wrong: $e");
      print("Error change password message $e");
      return e.toString();
    }
  }
  emptyMethod() {
    setState(() {
      _currentPController.text="";
      _newPController.text="";
      _confirmPController.text="";
    });
  }
}

