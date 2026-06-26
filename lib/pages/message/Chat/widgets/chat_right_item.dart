import '/./common/routes/names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/entities/msgcontent.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget ChatRightItem(Msgcontent item) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          //used here to overcome overflow issues
          constraints: BoxConstraints(maxHeight: 230.w, minHeight: 40.w),
          child: Container(
              margin: EdgeInsets.only(right: 10.w, top: 0.w),
              padding: EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff9d45c7),
                      Color(0xffc583e3),
                      Color(0xffe1bee7),
                    ],
                    transform: GradientRotation(90),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: item.type == "text"
                  ? Text("${item.content}") //otherwise it will be an image
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 90.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.Photoimgview,
                              parameters: {"url": item.content ?? ""});
                        },
                        child: CachedNetworkImage(
                          imageUrl: "${item.content}",
                        ),
                      ),
                    )),
        )
      ],
    ),
  );
}
