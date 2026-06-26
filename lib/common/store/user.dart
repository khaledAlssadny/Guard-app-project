import 'dart:convert';
import '/./common/entities/entities.dart';
import '/./common/services/services.dart';
import '/./common/values/values.dart';
import 'package:get/get.dart';

class UserStore extends GetxController {
  /*Here, Get.find() is a method of the Get package that retrieves a controller instance from the dependency injection container. When to is called, it returns the UserStore instance that was previously registered with the dependency injection container.*/
  static UserStore get to => Get.find();

  // 是否登录
  final _isLogin = false
      .obs; // an observable boolean property that is used to track whether the user is currently logged in or not
  // 令牌 token
  String token =
      ''; //is a string property that holds the authentication token for the user
  // 用户 profile
  final _profile = UserLoginResponseEntity().obs;

  bool get isLogin => _isLogin.value;
  UserLoginResponseEntity get profile => _profile.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
  }

  // 保存 token
  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  // 获取 profile
  Future<String> getProfile() async {
    if (token.isEmpty) return "";
    // var result = await UserAPI.profile();
    // _profile(result);
    // _isLogin.value = true;
    return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
  }

  // 保存 profile
  /*
  The method takes a UserLoginResponseEntity object as a parameter,
   representing the user's login response, and saves it to the device's storage using the StorageService
  */
  Future<void> saveProfile(UserLoginResponseEntity profile) async {
    _isLogin.value =
        true; //value is  set to true, indicating that the user is currently logged in.
    //The jsonEncode method is used to convert the object to a JSON string before saving it to the storage.
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
    //access token is the user id that I got from the firebase
    setToken(profile
        .accessToken!); //passing in the user's access token as an argument. This method sets the access token in a shared preferences instance, allowing the token to be accessed by other parts of the app.
  }

  // 注销
  Future<void> onLogout() async {
    // if (_isLogin.value) await UserAPI.logout();
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
    _isLogin.value = false;
    token = '';
  }
}
