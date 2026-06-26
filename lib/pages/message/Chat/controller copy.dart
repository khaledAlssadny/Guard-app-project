/*
import '././common/style/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '././common/entities/entities.dart';
import '././common/routes/names.dart';
import '././common/store/store.dart';
import '././common/widgets/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:record_mp3/record_mp3.dart';
import '../../../common/style/utils/security.dart';
import 'audioController.dart';
import 'chatProvider.dart';
import 'index.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceController extends GetxController {
  VoiceController();
  AudioController audioController = Get.put(AudioController());
  ChatProvider chatProvider = Get.put(ChatProvider(
      firebaseFirestore: FirebaseFirestore.instance,
      firebaseStorage: FirebaseStorage.instance));
//vars
  String recordFilePath = '';
  RxBool isRecording = false.obs;
  RxBool isSending = false.obs;
  RxString audioURL = ''.obs;
  String total = '';
  TextEditingController messageController = TextEditingController();
  String groupChatId = "";
  String currentUserId = "";
  final ScrollController _scrollController = ScrollController();
  //methods
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      isRecording.value = true;
      RecordMp3.instance.start(recordFilePath, (type) {
        // You can perform any necessary logic here when recording starts
      });
    } else {
      // Handle the case when permission is not granted
    }
  }

  void stopRecord() async {
    bool stop = RecordMp3.instance.stop();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    var ap = AudioPlayer();
    await ap.play(AssetSource("Notification.mp3"));
    ap.onPlayerComplete.listen((a) {});
    if (stop) {
      audioController.isRecording.value = false;
      audioController.isSending.value = true;
      await uploadAudio();
    }
  }

  void uploadAudio() async {
    isSending.value = true;
    UploadTask uploadTask = chatProvider.uploadAudio(
      File(recordFilePath),
      "audio/${DateTime.now().millisecondsSinceEpoch.toString()}",
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      audioURL.value = await snapshot.ref.getDownloadURL();
      String strVal = audioURL.value.toString();
      isSending.value = false;
      onSendMessage(strVal, TypeMessage.audio, duration: total);
    } on FirebaseException catch (e) {
      isSending.value = false;
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type, {String? duration = ""}) {
    if (content.trim().isNotEmpty) {
      messageController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.data.id.toString(),
          duration: duration!);
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }
}
*/