// this class will be for the UI
//GetView will be used to access the controller and it's properties
// ignore_for_file: prefer_const_constructors

import '/./pages/Contact/index.dart';
import '/./pages/message/index.dart';
import '/./pages/profile/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../common/values/colors.dart';
import 'controller.dart';

//In Flutter development, the GetView class is a type of widget provided by the Get package that is used to create stateless widgets that depend on a specific controller or service.
class ApplicationPage extends GetView<ApplicationController> {
  @override
  Widget build(BuildContext context) {
    Widget _buildPageView() {
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handPageChanged,
        // ignore: prefer_const_literals_to_create_immutables
        //ContactPage(),
        children: [MessagePage(), ContactPage(), ProfilePage()],
      );
    }

    Widget _buildBottenNavigatienBar() {
      return Obx(() => BottomNavigationBar(
            items: controller.bottomTabs,
            currentIndex: controller.state.page,
            type: BottomNavigationBarType.fixed,
            onTap: controller.handleNavBarTap,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedItemColor: AppColors.tabBarElement,
            selectedItemColor: AppColors.thirdElementText,
          ));
    }

    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottenNavigatienBar(),
    );
  }
}
