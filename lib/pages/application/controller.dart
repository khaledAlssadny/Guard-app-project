
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/values/colors.dart';

import 'index.dart';

/*
This code initializes an instance of the GoogleSignIn class from the google_sign_in package in Flutter. The GoogleSignIn class provides functionality for signing in with a Google account in Flutter apps.
The scopes parameter specifies a list of OAuth 2.0 scopes that the app requests authorization for from the user during sign-in. In this case, the only scope requested is openid, which is an OpenID Connect authentication protocol that allows users to authenticate with an app using their Google account.
*/

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handPageChanged(int index) {
    state.page = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    tabTitles = ['Chat', 'Contact', 'Profile'];
    bottomTabs = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.message,
            color: AppColors.thirdElementText,
          ), // Icon
          activeIcon: Icon(
            Icons.message,
            color: AppColors.secondaryElementText,
          ),
          label: 'Chat',
          backgroundColor: AppColors.primaryBackground),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.contact_page,
            color: AppColors.thirdElementText,
          ), // Icon
          activeIcon: Icon(
            Icons.contact_page,
            color: AppColors.secondaryElementText,
          ),
          label: 'Contact',
          backgroundColor: AppColors.primaryBackground),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: AppColors.thirdElementText,
          ), // Icon
          activeIcon: Icon(
            Icons.person,
            color: AppColors.secondaryElementText,
          ),
          label: 'Person',
          backgroundColor: AppColors.primaryBackground),
    ];
    pageController = PageController(initialPage: state.page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
