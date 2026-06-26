// declare the dependnies

import 'package:get/get.dart';
import 'index.dart';

//Bindings are used to declare the dependencies for a specific screen or route in the application.
class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    //When a controller or service is registered using Get.lazyPut, it is not initialized until it is actually needed.
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
