
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/auth/global_logout.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/attendance_report_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/category_list_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_list_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/my_profile_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/product_list_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/visit_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/sales_entry_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/sales_invoice_list_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/sales_record_screen.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_list_tile.dart';

// ignore: must_be_immutable
class DrawerDemoPage extends StatefulWidget {
  DrawerDemoPage({super.key,
  required  this.name,
  required  this.lateValue,
  required  this.LongitValue 
  });
  String ? name;
  String? lateValue;
  String? LongitValue;

  @override
  State<DrawerDemoPage> createState() => _DrawerDemoPageState();
}

class _DrawerDemoPageState extends State<DrawerDemoPage> {
  String? userImage = "";
  String? userType = "";
  String isImage = "";
  String isColor = "";
  String isSize = "";
  String role = "";
 ///sale
  String? salesEntry;
  String? salesRecord;
  String? stockReport;
  String? orderEntry;
  String? customerLedger;
  String? supplierLedger;
  String? saleInvoice;
  String? orderRecord;
  String? pendingOrder;
  String? deliveryOrder;
  String? customerPayment;
  String? supplierPayment;
  String? cashTrReport;
  String? bankTrReport;
  String? customerEntry;
  String? customerDue;
  String? salesInvoice;
  String? customerList;
  String? productList;
  String? categoryList;
  String? currentStock;
  String? attendanceEntry;
  String? attendanceRecord;
  String? visitEntry;
  String? visitRecord;

  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isColor= "${sharedPreferences?.getString('is_color')}";
    isSize= "${sharedPreferences?.getString('is_size')}";
    userImage = "${sharedPreferences?.getString('userImage')}";
    isImage = "${sharedPreferences?.getString('image')}";
    role = "${sharedPreferences?.getString('role')}";
    userType = "${sharedPreferences?.getString('userType')}";
    setState(() {
      isImage = "${sharedPreferences?.getString('image')}";
    });

   ///sales
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
    print("userType===$userType");
    print("salesEntry===$salesEntry");
    print("salesRecord===$salesRecord");
    print("stockReport===$stockReport");
    print("orderEntry===$orderEntry");
    print("orderRecord===$orderRecord");
    print("pendingOrder===$pendingOrder");
    print("deliveryOrder===$deliveryOrder");
    print("customerPayment===$customerPayment");
    print("supplierPayment===$supplierPayment");
    print("customerLedger===$customerLedger");
    print("supplierLedger===$supplierLedger");
    print("cashTrReport===$cashTrReport");
    print("bankTrReport===$bankTrReport");
  }
  
  bool isClick = false;
  bool isClick1 = false;
  bool isClick2 = false;
  bool isClick3 = false;
  bool isClick4 = false;
  bool isClick5 = false;
  bool isClick6 = false;
  bool isClick7 = false;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
              height: 180.h,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.appColor,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left:5.w, top:5.h,bottom: 15.h),
                    decoration: BoxDecoration(
                      color:AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.h,
                          decoration: BoxDecoration(shape: BoxShape.circle,
                            border: Border.all(color: Colors.white,width: 2.w),
                          ),
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundImage: (userImage != null && userImage!.isNotEmpty && userImage != 'null')
                            ? NetworkImage("$imageBaseUrl${userImage!}")
                            : const NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNq-fhMeQRIAFfcfgPFaQDO8yTQ_SOW1-6raA_0HgiiKDJTV0TkDiojPT98h40g8T4FAk&usqp=CAU',
                           ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          SizedBox(
                          width: 150.w, 
                          child: Text(
                            "${widget.name}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Text(
                      "Barisal Surgical",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
             color: AppColors.appColor,
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Dashboard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
            )),
            SizedBox(height: 5.h),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(salesEntry == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  SalesEntryScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath: "images/salesEntry.png", icon_name: "Sales Entry")),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(salesRecord == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath:"images/srecord.png", icon_name: "Sales Record")),
              const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(saleInvoice == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesInvoiceListScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath:"images/sInvc.png", icon_name: "Sales Invoice")),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(productList == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath:"images/productlist.png", icon_name: "Product List")),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                 if(categoryList == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryListScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath: "images/catelist.png", icon_name: "Category List")),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(customerEntry == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerEntryScreen()));
                }
                else{
                  showWarningDialog(context);
                }
                },
              child: Custom_List_Tile(imagePath: "images/ccentry.png", icon_name: "Customer Entry")),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(customerList == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath: "images/customerlist.png", icon_name: "Customer List")),
               const Divider(height: 1.0,thickness: 1.0,),
          const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                // if(pendingOrder == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfileScreen()));
                // }
                // else{
                //   showWarningDialog(context);
                // }
              },
              child: Custom_List_Tile(imagePath: "images/mpofile.png", icon_name: "My Profile")),
               const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                if(attendanceRecord == "true"|| userType=="m"|| userType== "a"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AttendanceReportScreen()));
                }
                else{
                  showWarningDialog(context);
                }
              },
              child: Custom_List_Tile(imagePath: "images/attend.png", icon_name: "Attendance Report")),
                     const Divider(height: 1.0,thickness: 1.0,),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const VisitEntryScreen()));
                // if(attendanceRecord == "true"|| userType=="m"|| userType== "a"){
                //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  const VisitEntryScreen()));
                // }
                // else{
                //   showWarningDialog(context);
                // }
              },
              child: Custom_List_Tile(imagePath: "images/visite.png", icon_name: "Visit Entry")),
          const Divider(height: 1.0,thickness: 1.0,),
          
          InkWell(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 160.0,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 5.0,bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                              EdgeInsets.only(left: 8.0, top: 10.0),
                              child: Text(
                                "Logout...!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0),
                              ),
                            ),
                            const Padding(
                              padding:
                              EdgeInsets.only(left: 8.0, top: 10.0),
                              child: Text(
                                "Are you sure want to Logout?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0),
                              ),
                            ),
                            const SizedBox(height: 25.0),
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
                                      height: 35.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0)),
                                      child: const Center(
                                          child: Text(
                                            "NO",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      LogoutService.fetchLogout(context);
                                    },
                                    child: Container(
                                      height: 35.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0)),
                                      child: const Center(
                                          child: Text("YES",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
           child: Custom_List_Tile(imagePath: "images/logout.png", icon_name: "Logout")),
          const Divider(height: 1.0,thickness: 1.0),
        ],
      ),
    );
  }
}
class TextStylee{
  // ignore: non_constant_identifier_names
  TextStyle MyTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ) ;
}















// import 'package:dio/dio.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:barishal_surgical/utils/all_textstyle.dart';
// import 'package:barishal_surgical/utils/utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../auth/global_function.dart';
// import '../splash_seccen/home_page.dart';
// import '../utils/const_model.dart';
// import 'custom_list_tile.dart';

// // ignore: must_be_immutable
// class DrawerDemoPage extends StatefulWidget {
//   DrawerDemoPage({super.key,required this.addreess,required  this.name,required  this.phon,required  this.photo,required  this.lateValue,required  this.LongitValue });
//   String ? name,phon,photo ,addreess;
//   String? lateValue; String? LongitValue;

//   @override
//   State<DrawerDemoPage> createState() => _DrawerDemoPageState();
// }

// class _DrawerDemoPageState extends State<DrawerDemoPage> {
//   SharedPreferences? sharedPreferences;
//   Future<void> _initializeData() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     userName = "${sharedPreferences?.getString('userName')}";
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
//     setState(() {
//     });
//   }
//   String? userName = "";
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

//   fetchLogout(BuildContext context) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String link = "${baseUrl}logout";
//     try {
//       final response = await Dio().get(link,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
//             "Authorization": "Bearer ${sharedPreferences.getString("token")}",
//           }));
//       var item = response.data;
//       if (item['success'] == true) {
//         if (context.mounted) {
//           Utils.showMotionToast(
//           context,
//           title: "${item["message"]}!",
//           description: "Welcome to the Login Page",
//           icon: Icons.check_circle,
//           duration: const Duration(seconds: 3),
//         );
//         }
//         Future.delayed(Duration(seconds: 1), () {
//           if (context.mounted) {
//             AuthHelper.userLogout();
//           }
//         });
//       } else {
//         if(item['status'] == 401) {
//           AuthHelper.userLogout();
//         }
//       }
//     } catch (e) {
//       print("Logout Error: $e");
//     }
//   }
//   // fetchLogout() async {
//   //   SharedPreferences? sharedPreferences;
//   //   sharedPreferences = await SharedPreferences.getInstance();
//   //   String link = "${baseUrl}logout";
//   //   final response = await Dio().get(link,
//   //       options: Options(headers: {
//   //         "Content-Type": "application/json",
//   //         'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
//   //         "Authorization": "Bearer ${sharedPreferences.getString("token")}",
//   //       }));
//   //   print("logout token====${sharedPreferences.getString("token")}");
//   //   var item = response.data;
//   //   print("invalid token response===== $item");
//   //   if (item['success'] == true) {
//   //     sharedPreferences.clear();
//   //     GetStorage().erase();
//   //     var box = await Hive.openBox('profile');
//   //     box.clear();
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //         backgroundColor: Colors.green.shade900,
//   //         content: Center(child: Text("${item["message"]}",style:TextStyle(color: Colors.white)))));
//   //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LogInPage()),(route) => false);
//   //   }else{
//   //     sharedPreferences.clear();
//   //     GetStorage().erase();
//   //     var box = await Hive.openBox('profile');
//   //     box.clear();
//   //     print("something went wrong");
//   //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LogInPage()),(route) => false);
//   //   }
//   // }

//   bool isClick = false;
//   bool isClick1 = false;
//   bool isClick2 = false;
//   bool isClick3 = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _initializeData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.teal.shade800,
//       child: ListView(
//         scrollDirection: Axis.vertical,
//         padding: EdgeInsets.zero,
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height/4.5,
//             width: double.infinity,
//             color: Colors.teal.shade900,
//             padding: EdgeInsets.only(left: 10.0.w,top: 10.0.h),
//             child: Column(
//               children: [
//                 SizedBox(height: 5.0.h),
//                 Container(
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100.0.r)),
//                   child: CircleAvatar(
//                     radius: 30.0.r,
//                     backgroundImage: NetworkImage(
//                         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNq-fhMeQRIAFfcfgPFaQDO8yTQ_SOW1-6raA_0HgiiKDJTV0TkDiojPT98h40g8T4FAk&usqp=CAU'),
//                   ),
//                 ),
//                 SizedBox(height: 5.0.h),
//                 Text("$userName",
//                   style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w600, color: Colors.white),
//                 ),
//                 RichText(
//                     text: TextSpan(
//                         text: "Magic Corporation",
//                         style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             launch("${baseUrl}Login");
//                           })),
//               ],
//             ),
//           ),
//           SizedBox(height: 5.0.h),
//            InkWell(
//              onTap: (){
//                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
//              },
//             child: CustomListTile(icon: Icons.dashboard, icon_name: "Dashboard")),
//           SizedBox(height: 5.0.h),
//           Container(height: 1.0.h,color: Colors.white),
//           GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               setState(() {
//                 isClick1 = !isClick1;
//                 isClick2 = false;
//                 isClick3 = false;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 0.0.w,vertical: 5.0.h),
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   SizedBox(height: 4.0.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 10.0.w,bottom: 8.0.h),
//                         child: Row(
//                          children: [
//                           SizedBox(width: 10.0.w),
//                             Text("Order Module",style: AllTextStyle.moduleHeadTextStyle),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Visibility(
//                     visible: isClick1,
//                     child: Column(
//                         children: List.generate(orderModuleItems.length, (index) {
//                           return GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               if(index==0){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               } else if(index == 1){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   // Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }
//                               else {
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }
//                             },
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Container(height: 1.0.h,color: Colors.white),
//                                       Container(
//                                           color:index==0? Colors.cyan.shade900.withOpacity(0.9):
//                                           index==1? Colors.blue.shade900.withOpacity(0.4):
//                                           Colors.cyan.shade900.withOpacity(0.9),
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(left: 10.0,top: 7.0,bottom: 7.0,right: 10.0),
//                                             child: Row(
//                                               children: [
//                                                 index ==0?Icon(Icons.card_giftcard,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index ==1?Icon(Icons.library_add_check_outlined,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 Icon(Icons.reorder_outlined,size: 16.0.r,color: Colors.lightGreenAccent),
//                                                 SizedBox(width: 10.0.w),
//                                                 Text(orderDrawerList[index],style: AllTextStyle.saveButtonTextStyle),
//                                               ],
//                                             ),
//                                           )),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },)
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(height: 1.0.h,color: Colors.white),
//           GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               setState(() {
//                 isClick2 = !isClick2;
//                 isClick1 = false;
//                 isClick3 = false;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 3.0.h),
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   SizedBox(height: 4.0.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(padding: EdgeInsets.only(left: 10.0.w, bottom: 8.0.h),
//                         child: Row(
//                           children: [
//                             SizedBox(width: 10.0.w),
//                             Text("Sales Module", style: AllTextStyle.moduleHeadTextStyle),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Visibility(
//                     visible: isClick2,
//                     child: Column(
//                       children: List.generate(salesDrawerList.length, (index) {
//                         return GestureDetector(
//                           behavior: HitTestBehavior.opaque,
//                           onTap: () {
//                             if (index == 0) {
//                               if (orderEntry == "true" || userType == "m" || userType == "a") {
//                                 // Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryPage()));
//                               } else {
//                                 showWarningDialog(context, "It is not authorized for you to access this page!");
//                               }
//                             } else if (index == 1) {
//                               if (orderEntry == "true" || userType == "m" || userType == "a") {
//                                 /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                               } else {
//                                 showWarningDialog(context, "It is not authorized for you to access this page!");
//                               }
//                             }
//                             else{
//                               if (orderEntry == "true" || userType == "m" || userType == "a") {
//                                 /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                               } else {
//                                 showWarningDialog(context, "It is not authorized for you to access this page!");
//                               }
//                             }
//                           },
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(height: 1.0.h, color: Colors.white),
//                                     Container(
//                                       color: index == 0 ? Colors.blue.shade900.withOpacity(0.2)
//                                       : index == 1 ? Colors.green.shade900.withOpacity(0.2)
//                                       : Colors.blue.shade900.withOpacity(0.2),
//                                       child: Padding(
//                                         padding: EdgeInsets.only(left: 10.0.w, top: 7.0.h, bottom: 7.0.h, right: 10.0.w),
//                                         child: Row(
//                                           children: [
//                                             index == 0 ? Icon(Icons.point_of_sale_sharp, size: 16.0.r, color: Colors.lightGreenAccent):
//                                             index == 1 ? Icon(Icons.receipt, size: 16.0.r, color: Colors.lightGreenAccent):
//                                             Icon(Icons.receipt_long, size: 16.0.r, color: Colors.lightGreenAccent),
//                                             SizedBox(width: 10.0.w),
//                                             Text(salesDrawerList[index], style: AllTextStyle.saveButtonTextStyle),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(height: 1.0.h,color: Colors.white),
//           GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               setState(() {
//                 isClick3 = !isClick3;
//                 isClick1 = false;
//                 isClick2 = false;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 0.0.w,vertical: 3.0.h),
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   SizedBox(height: 4.0.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 10.0.w,bottom: 8.0.h),
//                         child: Row(
//                           children: [
//                             SizedBox(width: 10.0.w),
//                             Text("Administration Module", style: AllTextStyle.moduleHeadTextStyle),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Visibility(
//                     visible: isClick3,
//                     child: Column(
//                         children: List.generate(administrationDrawerList.length, (index) {
//                           return GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               if(index==0){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               } else if(index == 1){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 2){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 3){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 4){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 5){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 6){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 7){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }else if(index == 8){
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                   /// Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }
//                               else {
//                                 if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//                                 }
//                                 else{
//                                   showWarningDialog(context, "It is not authorized for you to access this page!");
//                                 }
//                               }
//                             },
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Container(height: 1.0.h,color: Colors.white),
//                                       Container(
//                                           color:index==0? Colors.cyan.shade900.withOpacity(0.9):
//                                           index==1? Colors.blue.shade900.withOpacity(0.4):
//                                           index==2? Colors.cyan.shade900.withOpacity(0.9):
//                                           index==3? Colors.blue.shade900.withOpacity(0.4):
//                                           index==4? Colors.cyan.shade900.withOpacity(0.9):
//                                           index==5? Colors.blue.shade900.withOpacity(0.4):
//                                           index==6? Colors.cyan.shade900.withOpacity(0.9):
//                                           Colors.blue.shade900.withOpacity(0.4),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 10.0.w,top: 7.0.h,bottom: 7.0.h,right: 10.0.w),
//                                             child: Row(
//                                               children: [
//                                                 index==0? Icon(Icons.production_quantity_limits,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index==1? Icon(Icons.category,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index==2? Icon(Icons.person,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index==3? Icon(Icons.groups,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index==4? Icon(Icons.visibility_outlined,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index==5? Icon(Icons.view_sidebar,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 index==6? Icon(Icons.add_box_sharp,size: 16.0.r,color: Colors.lightGreenAccent):
//                                                 Icon(Icons.perm_contact_cal_sharp,size: 16.0.r,color: Colors.lightGreenAccent),
//                                                 SizedBox(width: 10.0.w),
//                                                 Text(administrationDrawerList[index],style:AllTextStyle.saveButtonTextStyle),
//                                               ],
//                                             ),
//                                           )),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },)
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ///
//         //   InkWell(
//         //       onTap: (){
//         //         Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(),));
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.home, icon_name: "Home Page")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(orderEntry == "true"|| userType=="m"|| userType== "a"){
//         //           if(userType == 'c'){
//         //            // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OrderListScreen(
//         //             //)));
//         //           }else{
//         //             // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OutletList(
//         //             //   totatOrderValue: "",
//         //             //   routName: "",
//         //             // ))).then((value){
//         //             //   Provider.of<UserDataProvider>(context,listen: false).getUserData(context);
//         //             //   setState(() {
//         //             //   });
//         //             // });
//         //           }
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.border_all, icon_name: "Order Entry")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(orderRecord == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderRecordScreen()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.pending, icon_name: "Order Record")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(salesInvoice == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => const AllOrderInvoicePage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //         },
//         //       child: Custom_List_Tile(icon: Icons.inbox_rounded, icon_name: "Order Invoice")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(salesEntry == "true"|| userType=="m"|| userType== "a"){
//         //          // Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryPage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //         },
//         //       child: Custom_List_Tile(icon: Icons.sim_card_alert_sharp, icon_name: "Sales Entry")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(salesRecord == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecordPage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.library_books, icon_name: "Sales Record")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(salesInvoice == "true"|| userType=="m"|| userType== "a"){
//         //          // Navigator.push(context, MaterialPageRoute(builder: (context) => const AllSalesInvoicePage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.insert_invitation_outlined, icon_name: "Sales Invoice")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(productList == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.production_quantity_limits, icon_name: "Product List")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //  InkWell(
//         //       onTap: (){
//         //         if(categoryList == "true"|| userType=="m"|| userType== "a"){
//         //          // Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryListScreen()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //         },
//         //       child: Custom_List_Tile(icon: Icons.category, icon_name: "Category List")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(customerEntry == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerEntryPage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //         },
//         //       child: Custom_List_Tile(icon: Icons.dashboard_customize_outlined, icon_name: "Customer Entry")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         // InkWell(
//         //       onTap: (){
//         //         if(customerList == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListPage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.list_alt_outlined, icon_name: "Customer List")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(visitEntry == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const VisitEntryPage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.visibility, icon_name: "Visit Entry")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(visitRecord == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const VisitHistoryPage()));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.visibility, icon_name: "Visit History")),
//         //   Divider(height: 1.0.h,thickness: 1.0.h),
//         //   InkWell(
//         //       onTap: (){
//         //         if(attendanceEntry == "true"|| userType=="m"|| userType== "a"){
//         //           //Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceEntry(latiduteValue: "${widget.lateValue}",LongitudeValue: "${widget.LongitValue}")));
//         //         }
//         //         else{
//         //           showCustomDialog(context, '⚠️Warning', 'It is not authorized for you to access this page!');
//         //         }
//         //       },
//         //       child: Custom_List_Tile(icon: Icons.library_add_check_outlined, icon_name: "Attendance Entry")),
//           Container(height: 1.0.h,color: Colors.white),
//           SizedBox(height: 3.0.h),
//           InkWell(
//             onTap: () {
//               Navigator.pop(context);
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Dialog(
//                       child: Container(
//                         height: 160.0.h,
//                         width: double.infinity,
//                         padding: EdgeInsets.only(top: 10.0.h, left: 10.0.w, right: 5.0.w,bottom: 10.0.h),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15.0.r)
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                              Padding(
//                               padding:EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                               child: Text("Logout...!",
//                                 style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0.sp),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 8.0.w, top: 10.0.h),
//                               child: Text(
//                                 "Are you sure want to Logout?",
//                                 style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.0.sp),
//                               ),
//                             ),
//                             SizedBox(height: 25.0.h),
//                             Align(
//                               alignment: Alignment.center,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Container(
//                                       height: 28.0.h,
//                                       width: 60.0.w,
//                                       decoration: BoxDecoration(color:  Colors.indigo,borderRadius: BorderRadius.circular(5.0.r)),
//                                       child: Center(child: Text("NO", style: AllTextStyle.saveButtonTextStyle)),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.0.w),
//                                   InkWell(
//                                     onTap: () async {
//                                       fetchLogout(context);
//                                     },
//                                     child: Container(
//                                       height: 28.0.h,
//                                       width: 60.0.w,
//                                       decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.0.r)),
//                                       child:Center(child: Text("YES", style: AllTextStyle.saveButtonTextStyle)),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.0.w),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                });
//             },
//            child: CustomListTile(icon: Icons.logout_outlined, icon_name: "Logout")),
//           SizedBox(height: 3.0.h),
//           Container(height: 1.0.h,color: Colors.white),
//         ],
//       ),
//     );
//   }
// }
// // drawer list text
// class TextStylee{
//   TextStyle MyTextStyle=GoogleFonts.abhayaLibre(
//     fontSize: 14.0.sp,
//     fontWeight: FontWeight.w900,
//     letterSpacing: 1.w,
//     color: Colors.white,
//   ) ;
// }
// class TextStyleeCard{
//   TextStyle MyTextStyle=GoogleFonts.abhayaLibre(
//     fontSize: 12.5.sp,
//     fontWeight: FontWeight.w900,
//     color: Colors.black,
//   ) ;
// }

// // drawer list text
// class ServiceTextStyle{
//   TextStyle MyTextStyle=GoogleFonts.abhayaLibre(
//     fontSize: 16.0.sp,
//     fontWeight: FontWeight.w900,
//     color: Colors.black,
//   ) ;
// }
// void showWarningDialog(BuildContext context, String message) {
//   showDialog(context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('⚠️ Warning'),
//         content: Text(message, style: TextStyle(fontSize: 16.5.sp)),
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


