import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
the StorageService class is a simple wrapper around SharedPreferences that provides methods for setting and getting values with keys in the SharedPreferences data store.
The init method initializes the SharedPreferences instance,
and the setString, setBool, and setList methods store values with corresponding keys. 
The getString, getBool, and getList methods retrieve values with corresponding keys,
and the remove method removes the value corresponding to a key from SharedPreferences.
*/ 

/*
SharedPreferences is a simple key-value storage system provided by the Flutter framework for storing small amounts of data, such as user preferences and application settings. 
It allows developers to store and retrieve data persistently across different sessions of the app.
the StorageService class uses SharedPreferences to store and retrieve user profile information such as the access token, display name, email, and photo URL. 
This information is saved in the SharedPreferences data store using corresponding keys, and can be retrieved and used later when required.
By using SharedPreferences, this data can persist even if the app is closed or the device is restarted.
The data stored by SharedPreferences is saved in an XML file in the app's data directory on the device.
*/
class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
/*
The setString method in the StorageService class takes two parameters, key and value, and returns a Future that completes with a bool indicating whether the operation was successful or not.

 */
  Future<bool> setString(String key, String value) async {
    //The await keyword is used to wait for the setString method to complete and return a bool value indicating whether the operation was successful or not.
    return await _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
}
