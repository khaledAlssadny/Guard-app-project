import 'package:get/get.dart';
// all the variables related to WelcomeController will separatly declered here

class ApplicationState {
  final _page = 0.obs;
  int get page => _page.value;

  set page(value) => _page.value = value;
}
