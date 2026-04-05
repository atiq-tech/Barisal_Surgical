import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:motion_toast/motion_toast.dart';

class Utils{
  static loadingDialog(
      BuildContext context, {bool barrierDismissible = false}) {
    showCustomDialog(context,
      child: SizedBox(
        height: 100.0.h,
        child: Center(child: CircularProgressIndicator()),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static bool _isDialogShowing(BuildContext context) => ModalRoute.of(context)?.isCurrent != true;
  static void closeDialog(BuildContext context) {
    if (_isDialogShowing(context)) {
      Navigator.pop(context);
    }
  }

  static showSpinKitLoad(){
    return SpinKitDoubleBounce(
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.grey : Colors.white,
          ),
        );
      },
      size: 40.0.r,
    );
  }

  static void closeKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
  static String formatFrontEndDate(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else {
      dateTime = date;
    }
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String formatBackEndDate(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else {
      dateTime = date;
    }
    return DateFormat('y-MM-dd').format(dateTime);
  }
  ///............ Toast Message ............
  static void toastMsg(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0.sp
    );
  }

  static void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return _AnimatedTopSnackBar(
          message: message,
          onDismiss: () => overlayEntry.remove(),
        );
      },
    );
    overlay.insert(overlayEntry);
  }

  static void errorSnackBar(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 10.0.w,vertical: 12.0.h),
          content: Center(child: Text(errorMsg, style: const TextStyle(color: Colors.white))),
        ),
      );
  }

  static void showSnackBar(BuildContext context, String msg,
      [Color textColor = Colors.teal]) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16.0.w,vertical: 16.0.w),
        content: Center(child: Text(msg, style: TextStyle(color: textColor))));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSnackBarWithAction(
      BuildContext context, String msg, VoidCallback onPress,{String actionText = 'Active',Color textColor = Colors.black,}) {
    final snackBar = SnackBar(
      content: Text(msg, style: TextStyle(color: textColor)),
      action: SnackBarAction(
        label: actionText,
        textColor: Colors.white,
        onPressed: onPress,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future showCustomDialog(BuildContext context, {Widget? child, bool barrierDismissible = false}) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
                child: child,
              );
            }
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffF10000),
          title:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Icon(Icons.warning_rounded, color: Colors.white,size: 40.r),
            Text(message, style: AllTextStyle.saveButtonTextStyle),
          ],),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Card(
                elevation: 5,
                 child: Container(
                  height: 25.r,width: 60.w,
                  decoration: BoxDecoration(
                  color: Color(0xffe06666),
                  borderRadius: BorderRadius.circular(3.r)), child: Center(
                 child: Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message, {Color backgroundColor = const Color.fromARGB(255, 4, 108, 156)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        content: Center(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

static void showMotionToast(
    BuildContext context, {
    required String title,
    required String description,
    IconData icon = Icons.info,
    Color? primaryColor,
    Color? secondaryColor,
    Alignment toastAlignment = Alignment.topCenter,
    AnimationType animationType = AnimationType.slideInFromRight,
    double? height,
    double? width,
    Duration duration = const Duration(seconds: 3),
  }) {
    MotionToast(
      icon: icon,
      primaryColor: primaryColor ?? const Color.fromARGB(255, 2, 77, 117),
      secondaryColor: secondaryColor ??Color.fromARGB(255, 0, 255, 34),
      title: Text(title,style: const TextStyle(color: Color.fromARGB(255, 0, 255, 34), fontWeight: FontWeight.bold)),
      description: Text(description,style: const TextStyle(color: Colors.white)),
      toastAlignment: toastAlignment,
      animationType: animationType,
      height: height ?? 80.h,
      width: width ?? 300.w,
      displayBorder: false,
      animationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 1000),
      toastDuration: duration,
    ).show(context);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return "";
    }
    return split(" ").map((element) =>
    "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}").join(" ");
  }
}

class _AnimatedTopSnackBar extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _AnimatedTopSnackBar({
    required this.message,
    required this.onDismiss,
  });

  @override
  State<_AnimatedTopSnackBar> createState() => _AnimatedTopSnackBarState();
}

class _AnimatedTopSnackBarState extends State<_AnimatedTopSnackBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    Future.delayed(Duration(seconds: 3), () {
      _controller.reverse().then((value) => widget.onDismiss());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40.h,
      left: 20.w,
      right: 20.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12.r,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


