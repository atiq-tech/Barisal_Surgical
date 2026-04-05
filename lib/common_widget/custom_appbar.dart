import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Size get preferredSize {
    return Size.fromHeight(50.0.h);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Icon(Icons.arrow_back, size: 22.0.r, color: Colors.white),
      ),
      elevation: 0.0,
      backgroundColor: AppColors.appColor,
      title: Text(title,
        style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
