import 'package:flutter/material.dart';
import '/./common/services/services.dart';
import '/./common/values/values.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

/*The ConfigStore class contains methods and properties for getting and setting information such as the application's version number, language settings, and whether the application has been opened for the first time. It also uses the StorageService class to persist this information across app sessions.*/
class ConfigStore extends GetxController {
  /*
  The to getter method is defined as static and returns the singleton instance of the ConfigStore class by calling the Get.find() method.
  The Get.find() method searches for the nearest instance of the ConfigStore class in the widget tree and returns it.
  By using this getter method, other classes and widgets can easily access the same instance of the ConfigStore class without needing to create a new instance or pass it through constructor parameters. 
  This promotes code reusability and helps to keep the state management organized.
  */
  static ConfigStore get to =>
      Get.find(); // static getter method in the ConfigStore class

  bool isFirstOpen = false;
  PackageInfo? _platform;
  String get version => _platform?.version ?? '-';
  bool get isRelease => bool.fromEnvironment("dart.vm.product"); //what's this
  Locale locale = Locale('en', 'US');
  List<Locale> languages = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
  ];

  @override
  void onInit() {
    super.onInit();
    // a boolean flag that is used to determine whether the application is being opened for the first time or not.
    isFirstOpen = StorageService.to.getBool(STORAGE_DEVICE_FIRST_OPEN_KEY);
  }

  Future<void> getPlatform() async {
    _platform = await PackageInfo.fromPlatform();
  }

  //This method is used to set a flag in the application's storage system, indicating that the user has already opened the application for the first time.
  Future<bool> saveAlreadyOpen() {
    //The boolean value is saved in the shared preferences using the setBool() method of the StorageService class.
    //When the method saveAlreadyOpen() is called, it sets the boolean value of true for the key STORAGE_DEVICE_FIRST_OPEN_KEY in the shared preferences using the setBool() method of the StorageService class.
    return StorageService.to.setBool(STORAGE_DEVICE_FIRST_OPEN_KEY, true);
  }

  void onInitLocale() {
    var langCode = StorageService.to.getString(STORAGE_LANGUAGE_CODE);
    if (langCode.isEmpty) return;
    var index = languages.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) return;
    locale = languages[index];
  }

  void onLocaleUpdate(Locale value) {
    locale = value;
    Get.updateLocale(value);
    StorageService.to.setString(STORAGE_LANGUAGE_CODE, value.languageCode);
  }
}
