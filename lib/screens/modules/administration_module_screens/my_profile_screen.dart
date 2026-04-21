import 'dart:io';
import 'dart:math';
import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
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
    userImage = "${sharedPreferences?.getString('image_name')}";
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
                                  return CustomImage(
                                    path: userImage == 'null' ? null : '${baseUrl}uploads/users/$userImage',
                                    height: 120.h,
                                    width: 120.w,
                                    fit: BoxFit.cover,
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
                      side: BorderSide(color: Colors.teal.shade900,width: 2.5.w),
                        fixedSize: Size(double.infinity, 35.h),
                        padding: EdgeInsets.all(5.r),
                        backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      setState(() {
                        changeProfile(image: file);
                      });
                    },
                    child: isLoading ? const CircularProgressIndicator(color: Colors.white)
                        : Padding(padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: Text("Image Upload", style: AllTextStyle.menuHeadTextStyle),
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
                    padding: EdgeInsets.only(top: 20.0.h,bottom: 20.0.h),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          isLoadingPChange = true;
                        });
                        fetchPasswordChange(
                            _currentPController.text,
                            _newPController.text,
                            _confirmPController.text,
                            context);
                      },
                      child:isLoadingPChange ? const CircularProgressIndicator(
                        color: Colors.white,): Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0.r),
                        ),
                        elevation: 9.0,
                        child: Container(
                          height: MediaQuery.of(context).size.width/9,
                          width: MediaQuery.of(context).size.width/1,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade900,
                            borderRadius: BorderRadius.circular(100.0.r),
                          ),
                          child: Center(child: Text("SAVE", style: AllTextStyle.saveButtonTextStyle)),
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
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}uploadUserImage";
    try {
      final formData = FormData.fromMap({
        'image': image == "" || image == null || image == 'null' ? null : await MultipartFile.fromFile(
            image.path, filename: "${Random().nextInt(900000000)}.jpg"
        )
        /// "image": image ?? "",
      });
      final response = await Dio().post(link, data: formData,
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      var item = response.data;
      print("image ===== response == $item");
      if (item == "Image uploaded") {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Center(child: Text("Image uploaded",style: TextStyle(color: Colors.white)))));
        return "true";
        /// Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            duration: Duration(seconds: 2),
            content: Center(child: Text("Image uploaded",style: TextStyle(color: Colors.red)))));
        return "false";
      }
    } catch (e) {
      print("Error message $e");
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
    if (item == "successfully update password") {
      setState(() {
        isLoadingPChange = false;
      });
      emptyMethod();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Center(child: Text("Password Update Successfully!",style: TextStyle(color: Colors.white)))));
      return "true";
      // Navigator.pop(context);
    } else {
      setState(() {
        isLoadingPChange = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Center(child: Text("Password Update Successfully!",style: TextStyle(color: Colors.white)))));
      return "false";
    }
    } catch (e) {
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








// // import 'dart:io';
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:barishal_surgical/common_widget/custom_appbar.dart';
// // import 'package:barishal_surgical/utils/all_textstyle.dart';
// //
// // class MyProfileScreen extends StatefulWidget {
// //   const MyProfileScreen({super.key});
// //
// //   @override
// //   State<MyProfileScreen> createState() => _MyProfileScreenState();
// // }
// //
// // class _MyProfileScreenState extends State<MyProfileScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   TextEditingController currentPasswordController = TextEditingController();
// //   TextEditingController newPasswordController = TextEditingController();
// //   TextEditingController confirmPasswordController = TextEditingController();
// //   bool _isCurrentPasswordVisible = false;
// //   bool _isNewPasswordVisible = false;
// //   bool _isConfirmPasswordVisible = false;
// //   XFile? _image;
// //
// //   final ImagePicker _picker = ImagePicker();
// //   Future<void> _pickImage() async {
// //     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
// //     setState(() {
// //       _image = image;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBar(title: "My Profile"),
// //       body: Stack(
// //         children: [
// //           Column(
// //             children: [
// //               Container(
// //                 height: 120.0.h,
// //                 color: Colors.teal.shade200,
// //               ),
// //               Container(
// //                 height: MediaQuery.of(context).size.height * 0.65,
// //               ),
// //             ],
// //           ),
// //           Positioned(
// //             top: 20.h,
// //             left: MediaQuery.of(context).size.width * 0.5 - 60,
// //             child: Stack(
// //               children: [
// //                 Container(
// //                   width: 140.w,
// //                   height: 140.h,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     border: Border.all(
// //                       color: Colors.teal.shade900,
// //                       width: 2.w, // Set border width
// //                     ),
// //                   ),
// //                   child: CircleAvatar(
// //                     radius: 70.r,
// //                     backgroundImage: _image != null
// //                         ? FileImage(File(_image!.path))
// //                         : AssetImage('images/mglogo.webp') as ImageProvider,
// //                   ),
// //                 ),
// //                 Positioned(
// //                   bottom: 10.h,
// //                   right: 0.w,
// //                   child: GestureDetector(
// //                     onTap: _pickImage,
// //                     child: Container(
// //                       width: 30.w,
// //                       height: 30.h,
// //                       decoration: BoxDecoration(
// //                         color: Colors.teal.shade900,
// //                         shape: BoxShape.circle,
// //                         border: Border.all(color: Colors.cyan.shade400, width: 1.5.w),
// //                       ),
// //                       child: Icon(Icons.camera_alt, color: Colors.white, size: 20.r),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             top: 150.h,
// //             left: 0.w,
// //             right: 0.w,
// //             child: Padding(
// //               padding: EdgeInsets.all(10.0.r),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Card(
// //                       elevation: 5,
// //                       child: Container(
// //                         width: double.infinity,
// //                         padding: EdgeInsets.all(10.r),
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(10.r),
// //                           border:Border.all(color: Colors.teal.shade500,width: 1.5.w)),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('User Name:Admin', style: AllTextStyle.searchTypeTxtStyle),
// //                           Text('Branch Name:Main Branch', style: AllTextStyle.searchTypeTxtStyle),
// //                           Text('Branch Location: Link Up Technology Ltd Mirpur 10, Dhaka', style: AllTextStyle.searchTypeTxtStyle),
// //                           Text('User Role:Member', style: AllTextStyle.searchTypeTxtStyle),
// //                         ],
// //                                             ),
// //                       )),
// //                     SizedBox(height: 10.h),
// //                     Form(
// //                       key: _formKey,
// //                       child: Card(
// //                         elevation: 9,
// //                         shape: RoundedRectangleBorder(
// //                           side: BorderSide(color: Colors.teal.shade500, width: 1.5),
// //                           borderRadius: BorderRadius.circular(10.0),
// //                         ),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Column(
// //                             children: [
// //                               // Current Password Field
// //                               SizedBox(
// //                                 height: 50.0,
// //                                 child: TextFormField(
// //                                   controller: currentPasswordController,
// //                                   obscureText: !_isCurrentPasswordVisible,
// //                                   decoration: InputDecoration(
// //                                     labelText: 'Current Password',
// //                                     border: OutlineInputBorder(),
// //                                     suffixIcon: IconButton(
// //                                       icon: Icon(
// //                                         _isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off,
// //                                       ),
// //                                       onPressed: () {
// //                                         setState(() {
// //                                           _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
// //                                         });
// //                                       },
// //                                     ),
// //                                   ),
// //                                   validator: (value) {
// //                                     if (value == null || value.isEmpty) {
// //                                       return 'Please enter your current password';
// //                                     }
// //                                     return null;
// //                                   },
// //                                 ),
// //                               ),
// //                               SizedBox(height: 10),
// //
// //                               // New Password Field
// //                               SizedBox(
// //                                 height: 50.0,
// //                                 child: TextFormField(
// //                                   controller: newPasswordController,
// //                                   obscureText: !_isNewPasswordVisible,
// //                                   decoration: InputDecoration(
// //                                     labelText: 'New Password',
// //                                     border: OutlineInputBorder(),
// //                                     suffixIcon: IconButton(
// //                                       icon: Icon(
// //                                         _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
// //                                       ),
// //                                       onPressed: () {
// //                                         setState(() {
// //                                           _isNewPasswordVisible = !_isNewPasswordVisible;
// //                                         });
// //                                       },
// //                                     ),
// //                                   ),
// //                                   validator: (value) {
// //                                     if (value == null || value.isEmpty) {
// //                                       return 'Please enter a new password';
// //                                     }
// //                                     return null;
// //                                   },
// //                                 ),
// //                               ),
// //                               SizedBox(height: 10),
// //
// //                               // Confirm Password Field
// //                               SizedBox(
// //                                 height: 50.0,
// //                                 child: TextFormField(
// //                                   controller: confirmPasswordController,
// //                                   obscureText: !_isConfirmPasswordVisible,
// //                                   decoration: InputDecoration(
// //                                     labelText: 'Confirm Password',
// //                                     border: OutlineInputBorder(),
// //                                     suffixIcon: IconButton(
// //                                       icon: Icon(
// //                                         _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
// //                                       ),
// //                                       onPressed: () {
// //                                         setState(() {
// //                                           _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
// //                                         });
// //                                       },
// //                                     ),
// //                                   ),
// //                                   validator: (value) {
// //                                     if (value == null || value.isEmpty) {
// //                                       return 'Please confirm your new password';
// //                                     }
// //                                     if (value != newPasswordController.text) {
// //                                       return 'Passwords do not match';
// //                                     }
// //                                     return null;
// //                                   },
// //                                 ),
// //                               ),
// //                               SizedBox(height: 10),
// //
// //                               // Update Button
// //                               Align(
// //                                 alignment: Alignment.bottomRight,
// //                                 child: GestureDetector(
// //                                   onTap: () {
// //                                     if (_formKey.currentState?.validate() ?? false) {
// //                                       // Perform submit logic here
// //                                     }
// //                                   },
// //                                   child: Card(
// //                                     elevation: 9,
// //                                     color: Colors.teal.shade900,
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(6.0),
// //                                     ),
// //                                     child: Padding(
// //                                       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
// //                                       child: Text(
// //                                         'Update',
// //                                         style: TextStyle(
// //                                           color: Colors.white,
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 16.0,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../common_widget/custom_appbar.dart';
// import '../../../utils/all_textstyle.dart';
//
// class MyProfileScreen extends StatefulWidget {
//   const MyProfileScreen({super.key});
//
//   @override
//   State<MyProfileScreen> createState() => _MyProfileScreenState();
// }
//
// class _MyProfileScreenState extends State<MyProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController currentPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   bool _isCurrentPasswordVisible = false;
//   bool _isNewPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   XFile? _image;
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = image;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.teal.shade50,
//       appBar: CustomAppBar(title: "My Profile"),
//       body: InkWell(
//         onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     width: 120.w,
//                     height: 120.h,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.teal.shade900,
//                         width: 2.w,
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 60.r,
//                       backgroundImage: _image != null
//                           ? FileImage(File(_image!.path))
//                           : AssetImage('images/mglogo.webp') as ImageProvider,
//                       backgroundColor: Colors.grey.shade300,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 10.h,
//                     right: 0.w,
//                     child: GestureDetector(
//                       onTap: _pickImage,
//                       child: Container(
//                         width: 30.w,
//                         height: 30.h,
//                         decoration: BoxDecoration(
//                           color: Colors.teal.shade900,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.cyan.shade400, width: 1.5.w),
//                         ),
//                         child: Icon(Icons.camera_alt, color: Colors.white, size: 20.r),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Card(
//                 elevation: 5,
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(10.r),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.r),
//                     border: Border.all(color: Colors.teal.shade500, width: 1.5.w),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('User Name: Admin', style: AllTextStyle.searchTypeTxtStyle),
//                       Text('Branch Name: Main Branch', style: AllTextStyle.searchTypeTxtStyle),
//                       Text('Branch Location: Link Up Technology Ltd Mirpur 10, Dhaka', style: AllTextStyle.searchTypeTxtStyle),
//                       Text('User Role: Member', style: AllTextStyle.searchTypeTxtStyle),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Form(
//                 key: _formKey,
//                 child: Card(
//                   elevation: 9,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.teal.shade500, width: 1.5),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Column(
//                         children: [
//                           buildPasswordField('Current Password', currentPasswordController, _isCurrentPasswordVisible, () {
//                             setState(() {
//                               _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
//                             });
//                           }),
//                           SizedBox(height: 10),
//                           buildPasswordField('New Password', newPasswordController, _isNewPasswordVisible, () {
//                             setState(() {
//                               _isNewPasswordVisible = !_isNewPasswordVisible;
//                             });
//                           }),
//                           SizedBox(height: 10),
//                           buildPasswordField('Confirm Password', confirmPasswordController, _isConfirmPasswordVisible, () {
//                             setState(() {
//                               _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//                             });
//                           }),
//                           SizedBox(height: 10),
//                           Align(
//                             alignment: Alignment.bottomRight,
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (_formKey.currentState?.validate() ?? false) {
//                                 }
//                               },
//                               child: Card(
//                                 elevation: 9,
//                                 color: Colors.teal.shade900,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(6.0),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//                                   child: Text(
//                                     'Update',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
//   return TextFormField(
//     controller: controller,
//     obscureText: !obscureText,
//     decoration: InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(),
//       suffixIcon: IconButton(
//         icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//         onPressed: toggleVisibility,
//       ),
//     ),
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return 'Please enter $label';
//       }
//       return null;
//     },
//   );
// }


