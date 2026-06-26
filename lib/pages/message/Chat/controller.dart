import '/./common/style/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '/./common/entities/entities.dart';
import '/./common/store/store.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../common/style/utils/security.dart';
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

class ChatController extends GetxController {
  ChatController();
  ChatState state = ChatState();
  var doc_id = null;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      await uploadFile();
    } else {
      print("No image selected");
    }
  }

  Future getImgUrl(String name) async {
    final spaceref = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceref.getDownloadURL();
    return str ?? "";
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
        uid: user_id, content: url, type: "image", addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");
      textController
          .clear(); //once adding is done now we can clear the textController
      Get.focusScope
          ?.unfocus(); //unfocus() is a method provided by the FocusScopeNode class in Flutter, which removes the focus from the currently focused widget in the focus scope.
    });
    await db
        .collection("message")
        .doc(doc_id)
        .update({"last_msg": "[image]", "last_time": Timestamp.now()});

    // Msgcontent
  }

  Future uploadFile() async {
    if (_photo == null) return;
    //  final fileName = getRandomString (15) +extension (_photo!.path);
    final fileName = getRandomString(15) + (_photo!.path ?? "");
    try {
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);
      await ref
          .putFile(_photo!)
          .snapshotEvents
          .listen((TaskSnapshot event) async {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            String imgUrl = await getImgUrl(fileName);
            sendImageMessage(imgUrl);
            // Do something with the imgUrl, like saving it to a database or displaying it to the user
            break;
          default:
            break;
        }
      });
    } catch (e) {
      print("There's an error $e");
    }
  }

  @override
  // to grab the data from contactcontroller
  void onInit() {
    super.onInit();
    var data = Get
        .parameters; // grab all the parameters that being passed to this route
    doc_id = data['doc_id'];
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());
    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");
      textController
          .clear(); //once adding is done now we can clear the textController
      Get.focusScope
          ?.unfocus(); //unfocus() is a method provided by the FocusScopeNode class in Flutter, which removes the focus from the currently focused widget in the focus scope.
    });
    await db
        .collection("message")
        .doc(doc_id)
        .update({"last_msg": sendContent, "last_time": Timestamp.now()});
  }

  @override
  void onReady() {
    //listen to messages changes
    super.onReady();
    var messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msgcontent, options) =>
              msgcontent.toFirestore(),
        )
        .orderBy("addtime", descending: true);
    state.msgContentList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        // to listen to any kind of changes
        switch (change.type) {
          case DocumentChangeType.added: //new data is added
            if (change.doc.data() != null) {
              state.msgContentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (error) => print("Listen failes:$error"));
    //getLocation();
  }
/*
  getLocation() async {
    try {
      var user_location = await db
          .collection("users")
          .where("id", isEqualTo: state.to_uid.value)
          .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore())
          .get();
    } catch (e) {
      print("We have error $e");
    }
  }*/
}
