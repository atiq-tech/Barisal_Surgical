import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllTextStyle {
  static TextStyle searchTypeTxtStyle = TextStyle(
    fontSize: 14.0.sp,
    color: Color(0xFF424242),
    fontWeight: FontWeight.w400,
  );

  ///table headline
  static TextStyle tableHeadTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  ///Product name
  static  TextStyle productNameTextStyle =  TextStyle(
    color: Colors.grey.shade300,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp
  );

  ///table headline
  static TextStyle cashStatementHeadingTextStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xff707488),
  );

  static TextStyle attendTrueTextStyle = TextStyle(
      fontSize: 14.sp,
      color: Colors.teal,
      fontWeight: FontWeight.w600,
    );

  static TextStyle attendDateTextStyle = TextStyle(
    fontSize: 14.sp,
    color: const Color(0xFF1271B0),
    fontWeight: FontWeight.bold,
  );

  ///no found/records
  static TextStyle nofoundTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w500,
  );

  ///subTotal
  static const TextStyle subTotalTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  ///date style
  static TextStyle dateFormatStyle = TextStyle(
      fontSize: 13.0.sp,
      color: Colors.grey.shade800,
      fontWeight: FontWeight.w400
  );

  ///subTotal Value
  static  TextStyle menuHeadTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 14.0.sp,
  );

  static  TextStyle profileTextStyle = TextStyle(
      color: Colors.blueGrey,
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w500
  );

  ///==module Head style==
  static  TextStyle moduleHeadTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0.sp,
      fontWeight: FontWeight.bold
  );

  ///save button style
  static TextStyle saveButtonTextStyle = TextStyle(
      letterSpacing: 1.0.w,
      color: Colors.white,
      fontWeight: FontWeight.w500
  );

  ///textField head style
  static  TextStyle textFieldHeadStyle = TextStyle(color: Colors.grey.shade800);

  ///dropDownlist Style
  static  TextStyle dropDownlistStyle = TextStyle(
      fontSize: 13.0.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade700);

  ///dropDownlist Style
  static  TextStyle textValueStyle = TextStyle(fontSize: 12.5.sp, color: Color.fromARGB(255, 126, 125, 125));
}

/// decoration
class ContDecoration{
  static  BoxDecoration contDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey, width: 0.5.w),
    borderRadius: BorderRadius.circular(5.0.r),
  );
}

/// textField inputborder
class TextFieldInputBorder{
  static OutlineInputBorder focusEnabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
    borderRadius: BorderRadius.circular(5.0.r),
  );
}

getTextstyle(){
  return TextStyle(
      backgroundColor:  Colors.blue[100],
      color: Colors.black,
      decoration: TextDecoration.underline,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      fontSize: 16.0.sp
  );
}

getHLTextstyle() {
  return  TextStyle(
      color: Colors.deepPurple.shade900,
      fontWeight: FontWeight.w800,
      fontSize: 16.0.sp
  );
}
SizedBox sizedBoxH = SizedBox(height: 10.0.h);
SizedBox sizedBoxW = SizedBox(width: 10.0.w);

 ///===Warning Dialog===
showWarningDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('⚠️ Warning'),
        content: Text(
          "It is not authorized for you to access this page!",
          style: TextStyle(fontSize: 16.5.sp),
        ),
        actions: <Widget>[
          Container(
            height: 30.h,
            decoration:BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0.w),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      );
    },
  );
}
///====gridview
SliverGridDelegateWithFixedCrossAxisCount customGridDelegate({
  int crossAxisCount = 3,
  double mainAxisSpacing = 10.0,
  double crossAxisSpacing = 6.0,
  double mainAxisExtent = 105.0,
}) {
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: mainAxisSpacing,
    crossAxisSpacing: crossAxisSpacing,
    mainAxisExtent: mainAxisExtent,
  );
}
///===customImageHPC=customImgHPC
Widget customImgHPC(String imagePath, {double height = 45, double width = 45}) {
  return Image(
    image: AssetImage(imagePath),
    height: height,
    width: width,
  );
}
///===customTextHPageCardTitle=customTHPCT
Widget customTextHPCT(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 10.5.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}

///===top data title style
Widget customStaticTextWidget({
  required String text,
  Color textColor = Colors.yellow,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.bold,
  TextAlign textAlign = TextAlign.center,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
    ),
  );
}

Widget customMultilineTextWidget({
  required String text,
  Color textColor = Colors.yellow,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.bold,
  TextAlign textAlign = TextAlign.center,
  int maxLines = 2,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
    ),
    maxLines: maxLines,
    overflow: overflow,
  );
}
///======tob Value
Widget customTopValueText({
  required String data,
  Color textColor = Colors.yellow,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.bold,
  TextAlign textAlign = TextAlign.center,
  int maxLines = 2,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    data.isNotEmpty ? double.parse(data).toStringAsFixed(0) : '0',
    textAlign: textAlign,
    style: TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
    ),
    maxLines: maxLines,
    overflow: overflow,
  );
}

DataColumn customDataColumn(String label) {
  return DataColumn(
    label: Expanded(
      child: Center(
        child: Text(
          label,
          style: AllTextStyle.tableHeadTextStyle,
        ),
      ),
    ),
  );
}
