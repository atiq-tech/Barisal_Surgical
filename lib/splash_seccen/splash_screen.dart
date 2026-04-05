import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barishal_surgical/auth/login_screen.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:barishal_surgical/main.dart';
import 'package:barishal_surgical/utils/app_colors.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final token = sharedPreferences.getString('token');
      if (token != null) {
        // if (sharedPreferences.getBool('attendanceInStatus') == true) {
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const BottomNavigationBarView()),(route) => false,
          );
        //}
        //  else {
        //   Navigator.pushAndRemoveUntil(context,
        //     MaterialPageRoute(builder: (_) => const AttendanceAbsencePage()),(route) => false,
        //   );
        // }
      } else {
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (_) => const LogInPage()),(route) => false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'images/brsgcl.png',
                width: 220.w,
                height: 220.h,
              ),
            ),
            SizedBox(height: 10.h),
            ScaleTransition(
              scale: _animation,
              child: Text(
                "Barisal Surgical",
                style: GoogleFonts.limelight(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: AppColors.appColor,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
