import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';

class CommonTypeAheadField<T> extends StatelessWidget {
  final TextEditingController controller;
  final List<T> suggestionList;
  final String hintText;
  final String? selectedValueId;
  final Function(String?) onValueIdChanged;
  final String Function(T) displayText;
  final String Function(T) valueId;
  final bool enabled;

  const CommonTypeAheadField({
    super.key,
    required this.controller,
    required this.suggestionList,
    required this.hintText,
    required this.selectedValueId,
    required this.onValueIdChanged,
    required this.displayText,
    required this.valueId,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      decoration: ContDecoration.contDecoration,
      child: TypeAheadField<T>(
        controller: controller,
        builder: (context, fieldController, focusNode) {
          return TextField(
            controller: fieldController,
            focusNode: focusNode,
            enabled: enabled,
            style: AllTextStyle.textValueStyle,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom:5.h, left: 5.0.w),
              isDense: true,
              hintText: hintText,
              hintStyle: AllTextStyle.textValueStyle,
              suffixIcon: selectedValueId == null || selectedValueId == '' || fieldController.text == ''
                  ? null
                  : GestureDetector(
                      onTap: () {
                        controller.clear();
                        fieldController.clear();
                        onValueIdChanged(null);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.r),
                        child: Icon(Icons.close, size: 16.r),
                      ),
                    ),
              suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(5.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            onTap: () {
              if (selectedValueId != null &&
                  selectedValueId != '' &&
                  selectedValueId != 'null') {
                controller.clear();
                fieldController.clear();
                onValueIdChanged(null);
              }
            },
          );
        },
        suggestionsCallback: (pattern) async {
          return Future.delayed(const Duration(milliseconds: 300), () {
            return suggestionList
                .where((item) =>
                    displayText(item).toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          });
        },
        itemBuilder: (context, T suggestion) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Text(
              displayText(suggestion),
              style: TextStyle(fontSize: 12.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
        onSelected: (T suggestion) {
          controller.text = displayText(suggestion);
          onValueIdChanged(valueId(suggestion));
        },
      ),
    );
  }
}