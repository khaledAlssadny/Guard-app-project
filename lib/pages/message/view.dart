import '../../../common/widgets/app.dart';
import '../../../pages/message/Chat/widgets/message_list.dart';
import '../../../common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'index.dart';

class MessagePage extends GetView<MessageController> {
  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Text("Message",
            style: TextStyle(
                color: AppColors.primaryBackground,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: MessageList(),
    );
  }
}
