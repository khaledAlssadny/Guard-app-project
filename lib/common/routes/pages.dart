import 'package:flutter/material.dart';
import '../../pages/Contact/bindings.dart';
import 'package:get/get.dart';
import '../../pages/Contact/index.dart';
import '../../pages/Welcome/index.dart';
import '../../pages/application/index.dart';
import '../../pages/message/photoview/index.dart';
import '../../pages/profile/index.dart';
import '../../pages/message/Chat/index.dart';
import '../../pages/sign_in/index.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      //binding which represents the dependencies will run first then the UI which is thw Welcome page
      name: AppRoutes.INITIAL,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      /* middlewares: [
          RouteWelcomeMiddleware(priority: 1),
        ]*/
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    /*
      middlewares: [
        RouteWelcomeMiddleware(priority: 1),
      ],
    ),*/
    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      // middlewares: [
      //    RouteAuthMiddleware(priority: 1),
      // ],
    ),

    // 最新路由
    // 首页
    GetPage(
        name: AppRoutes.Contact,
        page: () => ContactPage(),
        binding: ContactBinding()),
    //消息
    /*GetPage(
        name: AppRoutes.Message,
        page: () => MessagePage(),
        binding: MessageBinding()),
    //我的
    */
    GetPage(
        name: AppRoutes.Me,
        page: () => ProfilePage(),
        binding: ProfileBinding()),
    //聊天详情

    GetPage(
        name: AppRoutes.Chat, page: () => ChatPage(), binding: ChatBinding()),

    GetPage(
        name: AppRoutes.Photoimgview,
        page: () => PhotoImageView(),
        binding: PhotoImageViewBinding()),
  ];
}
