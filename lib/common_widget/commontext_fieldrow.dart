import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';

class CommonTextFieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final int maxLines; 

  const CommonTextFieldRow({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.maxLines = 1, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: maxLines > 1? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6,child: Text(label,style: AllTextStyle.textFieldHeadStyle)),
        const Expanded(flex: 1,child: Text(":")),
        Expanded(
          flex: 14,
          child: SizedBox(
            height: maxLines == 1 ? 25.0.h : null,
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              maxLines: maxLines, 
              style: AllTextStyle.dropDownlistStyle,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AllTextStyle.textValueStyle,
                contentPadding: EdgeInsets.only(left: 5.w, bottom: 6.h),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                enabledBorder: TextFieldInputBorder.focusEnabledBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}