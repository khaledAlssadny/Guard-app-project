import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/./common/values/values.dart';

///  AppBar
AppBar transparentAppBar({
  Widget? title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    /* backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 141, 48, 180),
          Color.fromARGB(255, 166, 112, 232),
          Color.fromARGB(255, 131, 123, 232),
          Color.fromARGB(255, 104, 132, 231),
        ],transform: GradientRotation(90)),
      ),
    ),*/
    backgroundColor: Color(0xff9d45c7),
    elevation: 0.0,
    centerTitle: true,
    /* leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),*/
    title: title != null ? Center(child: title) : null,
    leading: leading,
    actions: actions,
  );
}

/// 10像素 Divider
Widget divider10Px({Color bgColor = AppColors.secondaryElement}) {
  return Container(
    height: 10.w,
    decoration: BoxDecoration(
      color: bgColor,
    ),
  );
}
