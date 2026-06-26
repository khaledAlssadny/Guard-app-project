import 'package:get/get.dart';
import 'package:get/get.dart';

// all the variables related to WelcomeController will separatly declered here
class WelcomeState {
  var index = 0
      .obs; //When a variable is made reactive using obs, any changes to its value automatically trigger a rebuild of any widgets that are observing it.
}
