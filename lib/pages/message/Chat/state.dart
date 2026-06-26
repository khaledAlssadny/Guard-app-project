import '/./common/entities/entities.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

// all the variables related to WelcomeController will separatly declered here
class ChatState {
  RxList<Msgcontent> msgContentList = <Msgcontent>[].obs;
  var to_uid = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_location = "Unknown".obs;
}
