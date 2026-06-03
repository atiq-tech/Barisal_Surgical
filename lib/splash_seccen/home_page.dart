import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/attendance_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_payment_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/visit_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/visit_history_screen.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_invoice_list_screen.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_record_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/customer_due_list_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/customer_payment_due_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/customer_payment_history_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/ecp_sales_report_screen.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:barishal_surgical/auth/global_logout.dart';
import 'package:barishal_surgical/auth/login_screen.dart';
import 'package:barishal_surgical/drawer_section/drawer_menu.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_list_screen.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? userType = "";
  String? userName = "";
  String? employeeCode = "";
  String? salesEntry;
  String? salesRecord;
  String? salesInvoice;
  String? orderEntry;
  String? orderRecord;
  String? customerList;
  String? customerEntry;
  String? customerDue;
  String? productList;
  String? categoryList;
  String? currentStock;
  String? attendanceEntry;
  String? customerPaymentPage;
  String? visitEntry;
  String? visitList;
  String? saveAttendance;
  String? ecpWiseSalesReport;
  String? empWiseCusPayDue;
  
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    employeeCode = "${sharedPreferences?.getString('employeeCode')}";
    userType = "${sharedPreferences?.getString('userType')}";
    salesEntry = '${sharedPreferences?.getString("sales")}';
    salesInvoice = '${sharedPreferences?.getString("salesinvoice")}';
    salesRecord = '${sharedPreferences?.getString("salesrecord")}';
    customerList = '${sharedPreferences?.getString("customerlist")}';
    orderEntry = '${sharedPreferences?.getString("order_entry")}';
    orderRecord = '${sharedPreferences?.getString("orderRecord")}';
    customerEntry = '${sharedPreferences?.getString("customer")}';
    customerDue = '${sharedPreferences?.getString("customerDue")}';
    productList = '${sharedPreferences?.getString("productlist")}';
    categoryList = '${sharedPreferences?.getString("category")}';
    currentStock = '${sharedPreferences?.getString("currentStock")}';
    attendanceEntry = '${sharedPreferences?.getString("attendanceEntry")}';
    customerPaymentPage = '${sharedPreferences?.getString("customerPaymentPage")}';
    visitEntry = '${sharedPreferences?.getString("visitEntry")}';
    visitList = '${sharedPreferences?.getString("visitList")}';
    saveAttendance = '${sharedPreferences?.getString("saveAttendance")}';
    ecpWiseSalesReport = '${sharedPreferences?.getString("ecpWiseSalesReport")}';
    empWiseCusPayDue = '${sharedPreferences?.getString("empWiseCusPayDue")}';
  } 

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
    _getLocation();
    _initializeData();
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
                    radius: 13.0.r,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNq-fhMeQRIAFfcfgPFaQDO8yTQ_SOW1-6raA_0HgiiKDJTV0TkDiojPT98h40g8T4FAk&usqp=CAU'),
                  ),
                  Center(
                    child: Text(
                      "${sharedPreferences?.getString('userName')}",
                      style: TextStyle(
                          fontSize: 11.0.sp,
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
                          if (orderEntry == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const OrderEntryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 1) {
                          if (orderRecord == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) =>  OrderRecordScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 2) {
                          if (orderRecord == "true" || userType=="m"|| userType== "a") {
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
                         else if (index == 6){
                          if (ecpWiseSalesReport == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const ECPSalesReportScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 7) {
                          if (productList == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const ProductListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 8) {
                          if (customerPaymentPage == "true" || userType == "m" || userType == "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerPaymentEntryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 9) {
                         if (customerPaymentPage == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerPaymentHistoryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 10) {
                         if (empWiseCusPayDue == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerPaymentDueScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 11) {
                          if (customerDue == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerDueListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if (index == 12) {
                          if (customerList == "true" || userType=="m"|| userType== "a") {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const CustomerListScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if(index == 13) {
                           if (visitEntry == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) => const VisitEntryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                         else if(index == 14) {
                           if (visitList == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) => const VisitHistoryScreen()));
                          } else {
                            showWarningDialog(context);
                          }
                        }
                        else if(index == 15) {
                           if (saveAttendance == "true" || userType=="m"|| userType== "a") {
                           Navigator.push(context,MaterialPageRoute(builder: (context) => AttendanceEntryScreen(employeeCode: employeeCode!)));
                          } else {
                            showWarningDialog(context);
                          }
                        }else {
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  LogInPage()));
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
