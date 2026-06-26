// declare the dependnies

import '/./pages/Welcome/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

//Bindings are used to declare the dependencies for a specific screen or route in the application.
class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    //When a controller or service is registered using Get.lazyPut, it is not initialized until it is actually needed.
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
