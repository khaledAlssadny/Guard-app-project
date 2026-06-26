import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '/./common/entities/entities.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../common/values/colors.dart';
import '../controller.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({Key? key}) : super(key: key);
  Widget BuildListItem(UserData item) {
    return Container(
      child: InkWell(
        //InkWell widget is used to provide visual feedback when the button is tapped.
        onTap: () {
          if (item.id != null) {
            controller.goChat(item);
            print("ssssssssssssssssssssss");
          }
        },
        child: Row(
            // we need row because we will show user photo and name for every user
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
                child: SizedBox(
                  //The SizedBox widget is used to give a fixed size to its child widget. In the provided code, SizedBox is used to give a fixed width and height of 54.w to the Container widget that contains a user photo.
                  width: 54.w,
                  height: 54.w,
                  child: CachedNetworkImage(imageUrl: "${item.photourl}"),
                ),
              ),
              Container(
                width: 250.w,
                padding: EdgeInsets.only(
                    top: 15.w, left: 0.w, right: 0.w, bottom: 0.w),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffe5efe5)))),
                child: Row(children: [
                  SizedBox(
                    width: 200.w,
                    height: 72.w,
                    child: Text(
                      item.name ?? "",
                      style: TextStyle(
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.bold,
                          color: AppColors.thirdElement,
                          fontSize: 16.sp),
                    ),
                  )
                ]),
              )
            ]),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              var item = controller.state.contactList[index];
              return BuildListItem(item);
            }, childCount: controller.state.contactList.length)),
          )
        ],
      ),
    );
  }
}


/*
@override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              var item = controller.state.contactList[index];
              return BuildListItem(item);
            }, childCount: controller.state.contactList.length)),
          )
        ],
      ),
    );
  }
  */