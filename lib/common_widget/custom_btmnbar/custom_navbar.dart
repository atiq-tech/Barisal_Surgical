import 'package:barishal_surgical/screens/modules/administration_module_screens/customer_list_screen.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_entry_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/auth/login_screen.dart';
import 'package:barishal_surgical/screens/modules/administration_module_screens/my_profile_screen.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/sales_entry_screen.dart';
import 'package:barishal_surgical/splash_seccen/home_page.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

class BottomNavigationBarView extends StatefulWidget {
  final int initialIndex;

  const BottomNavigationBarView({super.key, this.initialIndex = 2});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  // String? officeStartTime;
  // Timer? startTimer;

  // void getCompanyProfile() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     final response = await Dio().get(
  //       "${baseUrl}get_company_profile",
  //       options: Options(headers: {
  //         "Content-Type": "application/json",
  //         'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //         "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       var data = response.data is List ? response.data[0] : response.data;

  //       setState(() {
  //         officeStartTime = data['start_time'] ?? "";
  //       });

  //       /// START AUTO TIME CHECK EVERY 1 SECOND
  //       startAutoStartTimeChecker();
  //     }
  //   } catch (e) {
  //     print("Error fetching company profile: $e");
  //   }
  //   print("get_company_profile-------office startTime======$officeStartTime");
  // }

  late int _currentIndex;
  String user = "";
  String? userType = "";
  // bool? attendanceInStatus;
  // bool? attendanceOutStatus;
  // SharedPreferences? sharedPreferences;

  // Future<void> _initializeData() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   user = "${sharedPreferences?.getString('user')}";
  //   userType = "${sharedPreferences?.getString('userType')}";
  //   attendanceInStatus = sharedPreferences?.getBool('attendanceInStatus');

  //   /// App closed অবস্থায় Start Time আগে পার হয়ে গেলে redirect
  //   if (officeStartTime != null && officeStartTime!.isNotEmpty) {
  //     _checkStartTimeImmediately(officeStartTime!);
  //   }

  //   setState(() {});
  // }

  // /// ⭐ AUTO RUN EVERY 1 SECOND — START TIME CHECK
  // void startAutoStartTimeChecker() {
  //   if (startTimer != null) return; // prevent multiple timers

  //   startTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (officeStartTime != null && officeStartTime!.isNotEmpty) {
  //       _checkStartTime(officeStartTime!);
  //     }
  //   });
  // }

  // /// ⭐ REDIRECT WHEN START TIME PASSED (App open থাকাকালীন)
  // void _checkStartTime(String startTimeStr) async {
  //   try {
  //     DateTime now = DateTime.now();
  //     DateFormat format = DateFormat("HH:mm:ss");
  //     DateTime start = format.parse(startTimeStr);

  //     DateTime startToday = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       start.hour,
  //       start.minute,
  //       start.second,
  //     );

  //     String todayDate = "${now.year}-${now.month}-${now.day}";
  //     String? lastRedirectDate =
  //         sharedPreferences?.getString('alreadyRedirectedDate');

  //     final difference = now.difference(startToday).inSeconds;

  //     if (difference >= 0 && lastRedirectDate != todayDate) {
  //       await sharedPreferences?.setString('alreadyRedirectedDate', todayDate);

  //       startTimer?.cancel(); // stop timer after redirect

  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const LogInPage()),
  //           (route) => false,
  //         );
  //       });
  //     }
  //   } catch (e) {
  //     print("Error parsing startTime: $e");
  //   }
  // }

  // /// ⭐ App off অবস্থায় চেক (App open হলে একবারে redirect)
  // void _checkStartTimeImmediately(String startTimeStr) async {
  //   try {
  //     DateTime now = DateTime.now();
  //     DateFormat format = DateFormat("HH:mm:ss");
  //     DateTime start = format.parse(startTimeStr);

  //     DateTime startToday = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       start.hour,
  //       start.minute,
  //       start.second,
  //     );

  //     String todayDate = "${now.year}-${now.month}-${now.day}";
  //     String? lastRedirectDate =
  //         sharedPreferences?.getString('alreadyRedirectedDate');

  //     final difference = now.difference(startToday).inSeconds;

  //     if (difference >= 0 && lastRedirectDate != todayDate) {
  //       await sharedPreferences?.setString(
  //           'alreadyRedirectedDate', todayDate);

  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const LogInPage()),
  //           (route) => false,
  //         );
  //       });
  //     }
  //   } catch (e) {
  //     print("Error parsing startTime immediately: $e");
  //   }
  // }

  // /// Token check
  // Future<void> _checkToken() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   final token = sharedPreferences?.getString('token');

  //   if (token == null || token.isEmpty) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LogInPage()),
  //         (route) => false,
  //       );
  //     });
  //   }
  // }

  @override
  void initState() {
    // getCompanyProfile();
    // _initializeData();
    // _checkToken();
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // @override
  // void dispose() {
  //   startTimer?.cancel();
  //   super.dispose();
  // }

  /// Logout
  fetchLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}logout";

    final response = await Dio().post(link,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          "Cookie": "laravel_session=${sharedPreferences.getString('sessionId')}",
        }));

    var item = response.data;

    if (item["status"] == true) {
      sharedPreferences.clear();
      GetStorage().erase();
      var box = await Hive.openBox('profile');
      box.clear();
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LogInPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SalesEntryScreen(),
      CustomerListScreen(),
      HomePage(),
      //StockListScreen(),
      OrderEntryScreen(),
      MyProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 0),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          child: pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: CurvedNavigationBar(
          index: _currentIndex,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: AppColors.appColor,
          color: AppColors.appColor,
          height: 50.h,
          animationDuration: const Duration(milliseconds: 700),

          items: <Widget>[
            _buildNavItem(
                icon: Icons.shopping_cart_checkout,
                text: "Sales",
                isSelected: _currentIndex == 0),
            _buildNavItem(
                icon: Icons.groups,
                text: "Customer",
                isSelected: _currentIndex == 1),
            _buildNavItem(
                icon: Icons.home,
                text: "Home",
                isSelected: _currentIndex == 2),
            _buildNavItem(
                icon: Icons.shop,
                text: "Order",
                isSelected: _currentIndex == 3),
            _buildNavItem(
                icon: Icons.person,
                text: "Profile",
                isSelected: _currentIndex == 4),
          ],

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String text,
    required bool isSelected,
  }) {
    return SizedBox(
      height: 30.h,
      width: 65.w,
      child: Padding(
        padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(icon, size: 12.r, color: Colors.white),
              Text(text,
                  style: TextStyle(color: Colors.white, fontSize: 9.5.sp)),
            ],
          ),
        ),
      ),
    );
  }
}

























// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:anz_medical/auth/login_page.dart';
// import 'package:anz_medical/auth/profile_screen.dart';
// import 'package:anz_medical/home_page.dart';
// import 'package:anz_medical/modules/order_module/screens/order_entry_screen.dart';
// import 'package:anz_medical/modules/sales_module/screens/sales_entry_screen.dart';
// import 'package:anz_medical/modules/sales_module/screens/stock_report_screen.dart';
// import 'package:anz_medical/utils/animation_snackbar.dart';
// import 'package:anz_medical/utils/app_colors.dart';
// import 'package:anz_medical/utils/const_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hive/hive.dart';

// class BottomNavigationBarView extends StatefulWidget {
//   final int initialIndex;

//   const BottomNavigationBarView({super.key, this.initialIndex = 2});

//   @override
//   State<BottomNavigationBarView> createState() => _BottomNavigationBarViewState();
// }

// class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   ///=== Logout
//   fetchLogout() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String link = "${baseUrl}logout";

//     final response = await Dio().post(link,
//         options: Options(headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
//           "Cookie": "laravel_session=${sharedPreferences.getString('sessionId')}",
//         }));

//     var item = response.data;
//     print("user logout======$item");

//     if (item["status"] == true) {
//       sharedPreferences.clear();
//       GetStorage().erase();
//       var box = await Hive.openBox('profile');
//       box.clear();
//       CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => const LogInPage()),
//         (route) => false,
//       );
//     } else {
//       print("something went wrong");
//     }
//   }

//   /// Smoothly navigate to new index with slide animation
//   void navigateToIndex(int index) {
//     Navigator.pushReplacement(
//       context,
//       PageRouteBuilder(
//         transitionDuration: const Duration(seconds: 5),
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             BottomNavigationBarView(initialIndex: index),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(1.0, 0.0); // Slide from right
//           const end = Offset.zero;
//           const curve = Curves.easeInOut;

//           final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           return SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> pages = [
//       OrderEntryScreen(),
//       const SalesEntryScreen(),
//       const HomePage(),
//       StockReportScreen(),
//       ProfileScreen(),
//     ];

//     return Scaffold(
//       body: pages[_currentIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         index: _currentIndex,
//         backgroundColor: Colors.transparent,
//         buttonBackgroundColor:AppColors.appColor,
//         color: AppColors.appColor,
//         height: 45.h,
//         items: <Widget>[
//           _buildNavItem(
//             icon: Icons.shopping_cart_checkout,
//             text: "Order",
//             isSelected: _currentIndex == 0,
//           ),
//           _buildNavItem(
//             icon: Icons.wallet_giftcard_outlined,
//             text: "Sales",
//             isSelected: _currentIndex == 1,
//           ),
//           _buildNavItem(
//             icon: Icons.home,
//             text: "Home",
//             isSelected: _currentIndex == 2,
//           ),
//           _buildNavItem(
//             icon: Icons.category,
//             text: "Stock",
//             isSelected: _currentIndex == 3,
//           ),
//           _buildNavItem(
//             icon: Icons.person,
//             text: "Profile",
//             isSelected: _currentIndex == 4,
//           ),
//         ],
//         onTap: (index) async {
//           navigateToIndex(index);
//         },
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required IconData icon,
//     required String text,
//     required bool isSelected,
//   }) {
//     return SizedBox(
//       height: 35.h,
//       width: 65.w,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 18.r, color: Colors.white),
//               //if (!isSelected)
//               Text(text,style: TextStyle(color: Colors.white, fontSize: 9.5.sp)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
