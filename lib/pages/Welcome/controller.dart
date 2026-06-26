import '/./common/routes/names.dart';
import '/./pages/Welcome/state.dart';
import 'package:get/get.dart';

import '../../common/store/config.dart';

class WelcomeController extends GetxController {
  final state = WelcomeState();

  WelcomeController();
  changePage(int index) async {
    state.index.value = index;
  }

  handleSignIn() async {
    await ConfigStore.to
        .saveAlreadyOpen(); //set the STORAGE_DEVICE_FIRST_OPEN_KEY to true
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
