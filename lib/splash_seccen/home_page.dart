import 'package:barishal_surgical/auth/add_finger.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_invoice_list_screen.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_record_screen.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:barishal_surgical/auth/global_logout.dart';
import 'package:barishal_surgical/auth/login_screen.dart';
import 'package:barishal_surgical/drawer_section/drawer_menu.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/attendance_report_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_list_screen.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/modules/administration_module_screens/category_list_screen.dart';
import '../screens/modules/administration_module_screens/product_list_screen.dart';
import '../screens/modules/sales_module_screens/sales_entry_screen.dart';
import '../screens/modules/sales_module_screens/sales_invoice_list_screen.dart';
import '../screens/modules/sales_module_screens/sales_record_screen.dart';
import '../utils/const_model.dart';
import 'dart:core';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    salesEntry = '${sharedPreferences?.getString("sales")}';
    salesInvoice = '${sharedPreferences?.getString("salesinvoice")}';
    salesRecord = '${sharedPreferences?.getString("salesrecord")}';
    customerList = '${sharedPreferences?.getString("customerlist")}';
    orderEntry = '${sharedPreferences?.getString("order_entry")}';
    orderRecord = '${sharedPreferences?.getString("orderRecord")}';
    customerEntry = '${sharedPreferences?.getString("customer")}';
    productList = '${sharedPreferences?.getString("productlist")}';
    categoryList = '${sharedPreferences?.getString("category")}';
    currentStock = '${sharedPreferences?.getString("currentStock")}';
    attendanceEntry = '${sharedPreferences?.getString("attendanceEntry")}';
    attendanceRecord = '${sharedPreferences?.getString("attendanceRecord")}';
    visitEntry = '${sharedPreferences?.getString("visitEntry")}';
    visitRecord = '${sharedPreferences?.getString("visitEntryRecord")}';
  }
          
  String? userType = "";
  String? userName = "";
  String? salesEntry;
  String? salesRecord;
  String? salesInvoice;
  String? orderEntry;
  String? orderRecord;
  String? customerList;
  String? customerEntry;
  String? productList;
  String? categoryList;
  String? currentStock;
  String? attendanceEntry;
  String? attendanceRecord;
  String? visitEntry;
  String? visitRecord;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  int? totatOrdValue = 0;
  String? routName;

  ///late Position currentPosition;
  String? currentAddress;
  String fullAddress = "";
  bool isRouteAvailable = true;
  String? latitude;
  String? longitude;

  Future<void> _getLocation() async {
    /// Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    /// Get current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
    print("latitude=====$latitude  longitude=====$longitude");
  }
  late ScrollController _scrollController;

  @override
  void initState() {
    _getLocation();
    _initializeData();
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 25.0.w,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
              padding: EdgeInsets.only(left: 8.0.w),
              child: Icon(Icons.menu, color: Colors.white, size: 25.0.sp)),
        ),
        elevation: 0.0,
        backgroundColor: AppColors.appColor,
        title: Row(
          children: [
            Text("Barisal Surgical",style: TextStyle(fontSize: 18.5.sp,color: Colors.white,fontWeight: FontWeight.w700),overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          Row(
            children: [
              Column(
                children: [
                   CircleAvatar(
                    radius: 15.0.r,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNq-fhMeQRIAFfcfgPFaQDO8yTQ_SOW1-6raA_0HgiiKDJTV0TkDiojPT98h40g8T4FAk&usqp=CAU'),
                  ),
                  Center(
                    child: Text(
                      "${sharedPreferences?.getString('userName')}",
                      style: TextStyle(
                          fontSize: 12.0.sp,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0.w),
              PopupMenuButton(
                child: Container(
                  height: 20.0.h,
                  width: 30.0.w,
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_drop_down, color: Colors.white, size: 25.0.sp),
                ),
                onSelected: (value) {
                  if (value == 0) {
                  } else {
                   showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          height: 160.0.h,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 5.0.w,bottom: 10.0.h),
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15.0.r)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
                                child: Text("Logout...!",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
                                ),
                              ),
                                Padding(
                                padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
                                child: Text("Are you sure want to Logout?",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0.sp)),
                              ),
                              SizedBox(height: 25.0.h),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 28.0.h,
                                        width: 60.0.w,
                                        decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0.r)),
                                        child: Center(child: Text("NO", style: AllTextStyle.saveButtonTextStyle)),
                                      ),
                                    ),
                                    SizedBox(width: 10.0.w),
                                    InkWell(
                                      onTap: () async {
                                        LogoutService.fetchLogout(context);
                                        },
                                      child: Container(
                                        height: 28.0.h,
                                        width: 60.0.w,
                                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0.r)),
                                        child: Center(child: Text("YES", style: AllTextStyle.saveButtonTextStyle)),
                                      ),
                                    ),
                                    SizedBox(width: 10.0.w),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  }
                },
                itemBuilder: (BuildContext bc) {
                  return [
                    PopupMenuItem(
                      height: 25.0.h,
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.logout_outlined,size: 16.0.r),
                          Text("Logout", style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ];
                },
              )
            ],
          ),
          SizedBox(width: 5.0.w)
        ],
      ),
      drawer: DrawerDemoPage(
        name: userName,
        lateValue:latitude,
        LongitValue: longitude,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0.h,left: 15.0.w,right: 15.0.w),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GestureDetector(
              //  onTap: () {
              //    Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => const AttendanceAbsencePage()),
              //     (route) => false,
              //   );
              //  },
              //   child: Card(
              //    elevation: 9,
              //    color: Colors.purple,
              //    shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(100.r)
              //    ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 8.w),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(
              //             Icons.logout,
              //             color: Colors.white,
              //             size: 16.r,
              //           ),
              //           SizedBox(width: 5.w),
              //           Text(
              //             "Out Time",
              //             style: TextStyle(
              //               fontSize: 11.sp,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(top: 5.h),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dashboardItems.length,
                  gridDelegate: customGridDelegate(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0){
                          if (salesEntry == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderEntryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 1) {
                          if (salesRecord == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) =>  OrderRecordScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 2) {
                          if (salesInvoice == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderInvoiceListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                       else if (index == 3){
                          if (salesEntry == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const SalesEntryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 4) {
                          if (salesRecord == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) =>  SalesRecordScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 5) {
                          if (salesInvoice == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const SalesInvoiceListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 6) {
                          if (productList == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const ProductListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 7) {
                          if (categoryList == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CategoryListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 8) {
                          if (customerEntry == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        // else if (index == 9) {
                        //   if (customerList == "true" || userType=="m"|| userType== "a") {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerListScreen()));
                        //   } else {
                        //     showWarningDialog(context);
                        //   }
                        // }
                        // else if (index == 10) {
                        //   Navigator.push(context,MaterialPageRoute(builder: (context) =>  MyProfileScreen()));
                        // }
                        else if (index == 9) {
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  LogInPage()));
                        }
                        else if(index == 10) {
                           if (attendanceRecord == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) => const AttendanceReportScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else {
                           //if (attendanceRecord == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) => const BiometricAuthScreen()));
                          // } else {
                          //   showWarningDialog(context);
                          // }
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: Colors.teal.shade50,
                            child: ClipOval(
                              child: SizedBox(
                                width: 45.w,
                                height: 45.h,
                                child: Padding(
                                  padding: EdgeInsets.all(5.r),
                                  child: customImgHPC(dashboardItems[index]['image']),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          customTextHPCT(dashboardItems[index]['name']),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



































///=======main old=====code
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:barishal_surgical/auth/global_logout.dart';
// import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_list_screen.dart';
// import 'package:barishal_surgical/screens/modules/order_module_screens/order_entry_screen.dart';
// import 'package:barishal_surgical/screens/modules/order_module_screens/order_record_screen.dart';
// import 'package:barishal_surgical/utils/all_textstyle.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../drawer_section/drawer_menu.dart';
// import '../screens/modules/administration_module_screens/category_list_screen.dart';
// import '../screens/modules/administration_module_screens/customer_entry_screen.dart';
// import '../screens/modules/administration_module_screens/my_profile_screen.dart';
// import '../screens/modules/administration_module_screens/product_list_screen.dart';
// import '../screens/modules/order_module_screens/order_invoice_list_screen.dart';
// import '../screens/modules/sales_module_screens/sales_entry_screen.dart';
// import '../screens/modules/sales_module_screens/sales_invoice_list_screen.dart';
// import '../screens/modules/sales_module_screens/sales_record_screen.dart';
// import '../screens/modules/sales_module_screens/stock_list_screen.dart';
// import '../utils/const_model.dart';
// import 'dart:core';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   SharedPreferences? sharedPreferences;
//   Future<void> _initializeData() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     userType = "${sharedPreferences?.getString('userType')}";
//     salesEntry = '${sharedPreferences?.getString("sales")}';
//     salesInvoice = '${sharedPreferences?.getString("salesinvoice")}';
//     salesRecord = '${sharedPreferences?.getString("salesrecord")}';
//     customerList = '${sharedPreferences?.getString("customerlist")}';
//     orderEntry = '${sharedPreferences?.getString("order_entry")}';
//     orderRecord = '${sharedPreferences?.getString("orderRecord")}';
//     customerEntry = '${sharedPreferences?.getString("customer")}';
//     productList = '${sharedPreferences?.getString("productlist")}';
//     categoryList = '${sharedPreferences?.getString("category")}';
//     currentStock = '${sharedPreferences?.getString("currentStock")}';
//     attendanceEntry = '${sharedPreferences?.getString("attendanceEntry")}';
//     attendanceRecord = '${sharedPreferences?.getString("attendanceRecord")}';
//     visitEntry = '${sharedPreferences?.getString("visitEntry")}';
//     visitRecord = '${sharedPreferences?.getString("visitEntryRecord")}';
//   }
//   String? userType = "";
//   String? salesEntry;
//   String? salesRecord;
//   String? salesInvoice;
//   String? orderEntry;
//   String? orderRecord;
//   String? customerList;
//   String? customerEntry;
//   String? productList;
//   String? categoryList;
//   String? currentStock;
//   String? attendanceEntry;
//   String? attendanceRecord;
//   String? visitEntry;
//   String? visitRecord;

//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   int? totatOrdValue = 0;
//   String? routName;

//   ///late Position currentPosition;
//   String? currentAddress;
//   String fullAddress = "";
//   bool isRouteAvailable = true;
//   String? latitude;
//   String? longitude;

//   Future<void> _getLocation() async {
//     /// Check permission
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//     }
//     /// Get current location
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       latitude = position.latitude.toString();
//       longitude = position.longitude.toString();
//     });
//     print("latitude=====$latitude  longitude=====$longitude");
//   }
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     _getLocation();
//     _initializeData();
//     // TODO: implement initState
//     super.initState();
//     _scrollController = ScrollController();
//   }
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//   @override
//   Future<void> didChangeDependencies() async {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         leadingWidth: 25.0.w,
//         leading: GestureDetector(
//           onTap: () {
//             scaffoldKey.currentState?.openDrawer();
//           },
//           child: Padding(
//               padding: EdgeInsets.only(left: 8.0.w),
//               child: Icon(Icons.menu, color: Colors.white, size: 25.0.sp)),
//         ),
//         elevation: 0.0,
//         backgroundColor: Colors.teal.shade900,
//         title: Row(
//           children: [
//             Text("Magic Corporation",style: TextStyle(fontSize: 18.5.sp,color: Colors.white,fontWeight: FontWeight.w700),overflow: TextOverflow.ellipsis),
//           ],
//         ),
//         actions: [
//           Row(
//             children: [
//               Column(
//                 children: [
//                    CircleAvatar(
//                     radius: 15.0.r,
//                     backgroundImage: NetworkImage(
//                         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNq-fhMeQRIAFfcfgPFaQDO8yTQ_SOW1-6raA_0HgiiKDJTV0TkDiojPT98h40g8T4FAk&usqp=CAU'),
//                   ),
//                   Center(
//                     child: Text(
//                       "${sharedPreferences?.getString('userName')}",
//                       style: TextStyle(
//                           fontSize: 12.0.sp,
//                           overflow: TextOverflow.ellipsis,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(width: 10.0.w),
//               PopupMenuButton(
//                 child: Container(
//                   height: 20.0.h,
//                   width: 30.0.w,
//                   alignment: Alignment.center,
//                   child: Icon(Icons.arrow_drop_down, color: Colors.white, size: 25.0.sp),
//                 ),
//                 onSelected: (value) {
//                   if (value == 0) {
//                   } else {
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Dialog(
//                             child: Container(
//                               height: 160.0.h,
//                               width: double.infinity,
//                               padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 5.0.w,bottom: 10.0.h),
//                               decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15.0.r)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                    Padding(
//                                     padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                                     child: Text("Logout...!",
//                                       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
//                                     ),
//                                   ),
//                                    Padding(
//                                     padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                                     child: Text("Are you sure want to Logout?",
//                                         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0.sp)),
//                                   ),
//                                   SizedBox(height: 25.0.h),
//                                   Align(
//                                     alignment: Alignment.center,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Container(
//                                             height: 28.0.h,
//                                             width: 60.0.w,
//                                             decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0.r)),
//                                             child: Center(child: Text("NO", style: AllTextStyle.saveButtonTextStyle)),
//                                           ),
//                                         ),
//                                         SizedBox(width: 10.0.w),
//                                         InkWell(
//                                           onTap: () async {
//                                             LogoutService.fetchLogout();
//                                            },
//                                           child: Container(
//                                             height: 28.0.h,
//                                             width: 60.0.w,
//                                             decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0.r)),
//                                             child: Center(child: Text("YES", style: AllTextStyle.saveButtonTextStyle)),
//                                           ),
//                                         ),
//                                         SizedBox(width: 10.0.w),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                   }
//                 },
//                 itemBuilder: (BuildContext bc) {
//                   return [
//                     PopupMenuItem(
//                       height: 25.0.h,
//                       value: 1,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Icon(Icons.logout_outlined,size: 16.0.r),
//                           Text("Logout", style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                   ];
//                 },
//               )
//             ],
//           ),
//           SizedBox(width: 5.0.w)
//         ],
//       ),
//       drawer: DrawerDemoPage(
//         name: "",
//         phon: "",
//         photo: "",
//         addreess: "",
//         lateValue:latitude,
//         LongitValue: longitude,
//       ),
//       body: Container(
//         padding: EdgeInsets.only(top: 10.0.h,left: 15.0.w,right: 15.0.w),
//         child: SingleChildScrollView(
//           controller: _scrollController,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Order Module :",style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: Colors.indigo.shade900)),
//               Container(
//                 height: 110.h,
//                 padding: EdgeInsets.only(top:5.0.h,bottom: 5.0.h),
//                 child: GridView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: orderModuleItems.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 6.0.w,
//                       mainAxisSpacing: 6.0.h,
//                       mainAxisExtent: 85.h
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     return GestureDetector(
//                       onTap: () {
//                         if(index==0){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OrderEntryScreen()));
//                           // setState(() {
//                           //   if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                           //     if(userType == 'c'){
//                           //      // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OrderListScreen()));
//                           //     }else{
//                           //       // Navigator.push(context, MaterialPageRoute(builder: (context) =>  OutletList(
//                           //       //   totatOrderValue: totatOrdValue,
//                           //       //   routName: routName,
//                           //       // ))).then((value){
//                           //       //   Provider.of<UserDataProvider>(context,listen: false).getUserData(context);
//                           //       //   setState(() {
//                           //       //
//                           //       //   });
//                           //       // });
//                           //     }
//                           //   }
//                           //   else{
//                           //     showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           //   }
//                           // });
//                         }
//                         else if( index==1){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  OrderRecordScreen()));
//                           // if(orderRecord == "true"|| userType=="m"|| userType== "a"){
//                           //   //Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderRecordScreen()));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                         else{
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderInvoiceListScreen()));
//                           // if(attendanceEntry == "true"|| userType=="m"|| userType== "a"){
//                           //   //Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceEntry(latiduteValue: latitude,LongitudeValue: longitude)));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                       },
//                       child: Card(
//                         elevation: 9.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color:Colors.teal.shade200,
//                             borderRadius: BorderRadius.circular(10.0.r),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 5.0.w),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Center(
//                                   child: Transform.rotate(
//                                     angle: pi / 4,
//                                     child: Container(
//                                       width: 30.w,
//                                       height: 30.h,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(color: Colors.black),
//                                       ),
//                                       child: Center(
//                                         child: Transform.rotate(
//                                           angle: -pi / 4,
//                                           child: Padding(
//                                             padding: EdgeInsets.all(5.0.r),
//                                             child: Image.asset("${orderModuleItems[index]["image"]}"),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                  SizedBox(height: 6.0.h),
//                                  Text('${orderModuleItems[index]["name"]}',textAlign: TextAlign.center,style: TextStyleeCard().MyTextStyle,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }, // Number of items in the grid
//                 ),
//               ),
//               Text("Sales Module :",style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: Colors.indigo.shade900)),
//               Container(
//                 height: 110.h,
//                 padding: EdgeInsets.only(top:5.0.h,bottom: 5.0.h),
//                 child: GridView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: salesModuleItems.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 6.0.w,
//                       mainAxisSpacing: 6.0.h,
//                       mainAxisExtent: 85.h
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     return GestureDetector(
//                       onTap: () {
//                         if(index==0){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SalesEntryScreen()));
//                           // setState(() {
//                           //   if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                           //     if(userType == 'c'){
//                           //      // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OrderListScreen()));
//                           //     }else{
//                           //       // Navigator.push(context, MaterialPageRoute(builder: (context) =>  OutletList(
//                           //       //   totatOrderValue: totatOrdValue,
//                           //       //   routName: routName,
//                           //       // ))).then((value){
//                           //       //   Provider.of<UserDataProvider>(context,listen: false).getUserData(context);
//                           //       //   setState(() {
//                           //       //
//                           //       //   });
//                           //       // });
//                           //     }
//                           //   }
//                           //   else{
//                           //     showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           //   }
//                           // });
//                         }
//                         else if( index==1){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordScreen()));
//                           // if(orderRecord == "true"|| userType=="m"|| userType== "a"){
//                           //   //Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderRecordScreen()));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                         else{
//                           //Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesInvoiceScreen()));
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesInvoiceListScreen()));
//                         }
//                         //   if(salesInvoice == "true"|| userType=="m"|| userType== "a"){
//                         //    Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesInvoiceScreen()));
//                         //   }
//                         //   else{
//                         //     showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                         //   }
//                         // }
//                       },
//                       child: Card(
//                         elevation: 9.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                              color: Colors.blue.shade200,
//                             borderRadius: BorderRadius.circular(10.0.r),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 5.0.w),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // SizedBox(
//                                 //     height: 30.0.h,width: 30.0.w,
//                                 //     child: CircleAvatar(
//                                 //       backgroundColor: Colors.white,
//                                 //       radius: 20,
//                                 //         child: Padding(
//                                 //           padding: const EdgeInsets.all(8.0),
//                                 //           child: Image.asset("${salesModuleItems[index]["image"]}"),
//                                 //         ))),
//                                 Center(
//                                   child: Transform.rotate(
//                                     angle: pi / 4,
//                                     child: Container(
//                                       width: 30.w,
//                                       height: 30.h,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(color: Colors.black),
//                                       ),
//                                       child: Center(
//                                         child: Transform.rotate(
//                                           angle: -pi / 4,
//                                           child: Padding(
//                                             padding: EdgeInsets.all(5.0.r),
//                                             child: Image.asset("${salesModuleItems[index]["image"]}"),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                  SizedBox(height: 6.0.h),
//                                 Text('${salesModuleItems[index]["name"]}',textAlign: TextAlign.center,style: TextStyleeCard().MyTextStyle,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }, // Number of items in the grid
//                 ),
//               ),
//               Text("Administration Module : ",style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: Colors.indigo.shade900)),
//               Container(
//                 height: 270.h,
//                 padding: EdgeInsets.only(top:10.0.h,bottom: 10.0.h),
//                 child: GridView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: administrationItems.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 6.0.w,
//                       mainAxisSpacing: 6.0.h,
//                       mainAxisExtent: 85.h
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     return GestureDetector(
//                       onTap: () {
//                         if(index==0){
//                           setState(() {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ProductListScreen()));

//                             // if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                             //   if(userType == 'c'){
//                             //    // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OrderListScreen()));
//                             //   }else{
//                             //     // Navigator.push(context, MaterialPageRoute(builder: (context) =>  OutletList(
//                             //     //   totatOrderValue: totatOrdValue,
//                             //     //   routName: routName,
//                             //     // ))).then((value){
//                             //     //   Provider.of<UserDataProvider>(context,listen: false).getUserData(context);
//                             //     //   setState(() {
//                             //     //
//                             //     //   });
//                             //     // });
//                             //   }
//                             // }
//                             // else{
//                             //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                             // }
//                           });
//                         }
//                         else if( index==1){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CategoryListScreen()));

//                           // if(orderRecord == "true"|| userType=="m"|| userType== "a"){
//                           //   //Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderRecordScreen()));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                         else if(index==2){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CustomerEntryScreen()));

//                           // if(salesInvoice == "true"|| userType=="m"|| userType== "a"){
//                           //  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AllOrderInvoicePage()));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                         else if( index==3){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  CustomerListScreen()));
//                           //
//                           //
//                           // if(salesEntry == "true"|| userType=="m"|| userType== "a"){
//                           //  // Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryPage()));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                         // else if(index==4){
//                         //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  VisitEntryScreen()));
//                         //   // if(salesRecord == "true"|| userType=="m"|| userType== "a"){
//                         //   //   //Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                         //   // }
//                         //   // else{
//                         //   //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                         //   // }
//                         // }
//                         // else if(index==5){
//                         //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  VisitHistoryScreen()));
//                         //   // if(salesInvoice == "true"|| userType=="m"|| userType== "a"){
//                         //   // //  Navigator.push(context, MaterialPageRoute(builder: (context) => const AllSalesInvoicePage()));
//                         //   // }
//                         //   // else{
//                         //   //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                         //   // }
//                         // }
//                         // else if(index==6){
//                         //   Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceEntryScreen()));
//                         //   // if(productList == "true"|| userType=="m"|| userType== "a"){
//                         //   //  // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
//                         //   // }
//                         //   // else{
//                         //   //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                         //   // }
//                         // }
//                         else if(index==4){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfileScreen()));
//                           // if(categoryList == "true"|| userType=="m"|| userType== "a"){
//                           //  // Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryListScreen()));
//                           // }
//                           // else{
//                           //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                           // }
//                         }
//                         else {
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return Dialog(
//                                   child: Container(
//                                     height: 160.0.h,
//                                     width: double.infinity,
//                                     padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 5.0.w,bottom: 10.0.h),
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(15.0.r)
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                                           child: Text("Logout...!",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp)),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                                           child: Text("Are you sure want to Logout?",style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0.sp)),
//                                         ),
//                                         SizedBox(height: 25.0.h),
//                                         Align(
//                                           alignment: Alignment.center,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                             children: [
//                                               InkWell(
//                                                 onTap: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Container(
//                                                   height: 28.0.h,
//                                                   width: 60.0.w,
//                                                   decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0.r)),
//                                                   child:Center(child: Text("NO", style: AllTextStyle.saveButtonTextStyle)),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 10.0.w),
//                                               InkWell(
//                                                 onTap: () async {
//                                                   LogoutService.fetchLogout();
//                                                 },
//                                                 child: Container(
//                                                   height: 28.0.h,
//                                                   width: 60.0.w,
//                                                   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0.r)),
//                                                   child: Center(child: Text("YES", style: AllTextStyle.saveButtonTextStyle)),
//                                                 ),
//                                               ),
//                                               SizedBox(width: 10.0.w),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                              );
//                           });
//                         }
//                       },
//                       child: Card(
//                         elevation: 9.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0.r),
//                              color: Color(0xff7CFFD0)
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 5.0.w),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Center(
//                                   child: Transform.rotate(
//                                     angle: pi / 4,
//                                     child: Container(
//                                       width: 30.w,
//                                       height: 30.h,
//                                       decoration: BoxDecoration(
//                                        color: Colors.white,
//                                         border: Border.all(color: Colors.black),
//                                       ),
//                                       child: Center(
//                                         child: Transform.rotate(
//                                           angle: -pi / 4,
//                                           child: Padding(
//                                             padding: EdgeInsets.all(5.0.r),
//                                             child: Image.asset("${administrationItems[index]["image"]}"),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 4.0.h),
//                                 Text('${administrationItems[index]["name"]}',textAlign: TextAlign.center,style: TextStyleeCard().MyTextStyle,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }, // Number of items in the grid
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomSheet: Container(
//         padding: EdgeInsets.symmetric(vertical:10.0.h),
//         height: 50.0.h,
//         color:  Colors.teal.shade900,
//         child:  Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));

//                 // if(currentStock == "true"|| userType=="m"|| userType== "a"){
//                 //  // Navigator.push(context, MaterialPageRoute(builder: (context) => const StockListScreen()));
//                 // }
//                 // else{
//                 //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                 // }
//               },
//               child: SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Icon(Icons.home,color: Colors.white,size: 18.0.r),
//                     Text("Home", style: TextStyle(fontSize: 11.0.sp, fontWeight: FontWeight.w900, color: Colors.white)),
//                   ],
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => StockListScreen()));
//                 // if(currentStock == "true"|| userType=="m"|| userType== "a"){
//                 //  // Navigator.push(context, MaterialPageRoute(builder: (context) => const StockListScreen()));
//                 // }
//                 // else{
//                 //   showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                 // }
//               },
//               child: SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Icon(Icons.category,color: Colors.white,size: 18.0.r),
//                     Text("Stock", style: TextStyle(fontSize: 11.0.sp, fontWeight: FontWeight.w900, color: Colors.white)),
//                   ],
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if(salesEntry == "true"|| userType=="m"|| userType== "a"){
//                     if(userType == 'c'){
//                       //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OrderListScreen()));
//                     }else{
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) =>  OutletList(
//                       //   totatOrderValue: totatOrdValue,
//                       //   routName: routName,
//                       // ))).then((value){
//                       //   Provider.of<UserDataProvider>(context,listen: false).getUserData(context);
//                       //   setState(() {
//                       //   });
//                       // });
//                     }
//                   }
//                   else{
//                     showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//                   }
//                 });
//               },
//               child: SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Icon(Icons.add_box_outlined,color: Colors.white,size: 18.0.r),
//                     Text("Order",
//                       style: TextStyle(
//                         fontSize: 11.0.sp,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                       ),),
//                   ],
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Dialog(
//                         child: Container(
//                           height: 160.0.h,
//                           width: double.infinity,
//                           padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 5.0.w,bottom: 10.0.h),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(15.0.r)
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                                Padding(
//                                 padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                                 child: Text("Logout...!",
//                                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
//                                 ),
//                               ),
//                                Padding(
//                                 padding:
//                                 EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                                 child: Text(
//                                   "Are you sure want to Logout?",
//                                   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0.sp),
//                                 ),
//                               ),
//                               SizedBox(height: 25.0.h),
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Container(
//                                         height: 28.0.h,
//                                         width: 60.0.w,
//                                         decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0.r)),
//                                         child:Center(child: Text("NO", style: AllTextStyle.saveButtonTextStyle)),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10.0.w),
//                                     InkWell(
//                                       onTap: () async {
//                                         LogoutService.fetchLogout();
//                                       },
//                                       child: Container(
//                                         height: 28.0.h,
//                                         width: 60.0.w,
//                                         decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0.r)),
//                                         child: Center(child: Text("YES", style: AllTextStyle.saveButtonTextStyle)),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10.0.w),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     });
//               },
//               child: SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                      Icon(Icons.logout, color: Colors.white,size: 18.0.r),
//                      Text("Logout",
//                       style: TextStyle(fontSize: 11.0.sp, fontWeight: FontWeight.w900, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showCustomDialog(BuildContext context, String title, String message) {
//   showDialog(context: context,
//     builder: (context) {
//       return AlertDialog(title: Text(title),
//         content: Text(message, style:TextStyle(fontSize: 16.5.sp)),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }
