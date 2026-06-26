// declare the dependnies

import '/./pages/message/controller.dart';
import '/./pages/profile/controller.dart';

import 'package:get/get.dart';
import '../Contact/controller.dart';
import 'index.dart';

//Bindings are used to declare the dependencies for a specific screen or route in the application.
class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    //When a controller or service is registered using Get.lazyPut, it is not initialized until it is actually needed.
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
