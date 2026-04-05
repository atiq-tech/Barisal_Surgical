import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'drawer_menu.dart';

// ignore: must_be_immutable, camel_case_types
class Custom_List_Tile extends StatelessWidget {
  Custom_List_Tile({
    super.key,
    required this.imagePath,
    required this.icon_name,
  });

  // asset image path
  final String imagePath;
  String? icon_name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      height: 26.h,
      width: double.infinity,
      child: Row(
        children: [
          Image.asset(imagePath,width: 16.w,height: 16.h,fit: BoxFit.contain),
          SizedBox(width: 10.w),
          Text('$icon_name', style: TextStylee().MyTextStyle),
        ],
      ),
    );
  }
}
