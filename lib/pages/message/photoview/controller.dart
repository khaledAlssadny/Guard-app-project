import 'package:get/get.dart';
import '/./pages/message/photoview/state.dart';

class PhotoImageViewController extends GetxController {
  final PhotoImageViewState state = PhotoImageViewState();

  @override
  void onReady() {
    super.onReady();
    var data = Get.parameters;
    if (data['url'] != null) {
      state.url.value = data['url']!;
    }
  }
}
