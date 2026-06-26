import 'dart:convert';
import 'dart:developer';
import '/./common/entities/entities.dart';
import '/./common/store/store.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../sign_in/controller.dart';

class ContactController extends GetxController {
  ContactController();
  static ContactController instance = Get.find();
  final ContactState state =
      ContactState(); //state is an object of the ContactState class
  static final db = FirebaseFirestore.instance;

  var userbase;
  var me = "KzTSYhTqqzMKlGuPH8TdJQeZtv63";

  //these variables and methods needed for smartRefresher widget in view
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  void onLoading() {
    asyncLoadAllData().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  void onRefresh() {
    asyncLoadAllData().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData to_userdata) async {
    var from_messages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: SignInController.token)
        .where("to_uid", isEqualTo: to_userdata.id)
        .get();

    var to_messages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: to_userdata.id)
        .where("to_uid", isEqualTo: SignInController.token)
        .get();
//here
    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      String profile =
          await UserStore.to.getProfile(); // this one should return a string
      UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(
          jsonDecode(profile)); //convrtng user data into object

      var msgdata = Msg(
        //we will use this object to send the data to firebase
        from_uid: userdata.accessToken,
        to_uid: to_userdata.id,
        from_name: userdata.displayName,
        to_name: to_userdata.name,
        from_avatar: userdata.photoUrl,
        to_avatar: to_userdata.photourl,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0, // as 2users never talked together before
      );
      db
          .collection(
              "message") // law al user lsa gded fa al collection dah hyt3ml fe al firebase law awl mara
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg
                  .toFirestore() //in this case this section will be called to convert the object into map and will add the userdata using the add method
              )
          .add(msgdata)
          .then((value) {
        // this value should have information about the document id which we will grab
        Get.toNamed("/chat", parameters: {
          "doc_id": value.id,
          "to_uid":
              to_userdata.id ?? "", // the person that I want to send a message
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? ""
        }); // navigates to the route named /chat
      }); //as usual hast5dmo 3lashan maynf3sh ab3t object ll firebase wa lazm ab3t json data la al firebase
    } else {
      if (from_messages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": from_messages.docs.first
              .id, //The ID of the first document in the from_messages query result. This document contains information about the conversation between the two users.
          "to_uid": to_userdata.id ??
              "", // the person that I want to send a message i.e. The ID of the user that the logged-in user wants to send a message to. This ID is provided by the to_userdata parameter passed to the goChat() method.
          "to_name": to_userdata.name ??
              "", // The name of the user that the logged-in user wants to send a message to.
          "to_avatar": to_userdata.photourl ??
              "" // The photo URL of the user that the logged-in user wants to send a message to.
        });
      }
      if (to_messages.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": to_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? ""
        });
      }
    }
  }

  Future<String> getDocId() async {
    var userBase = await db
        .collection('users')
        .where("email", isEqualTo: SignInController.myEmail)
        //SignInController.user1.myEmail
        .get();
    var docSnapshot = userBase.docs.first;
    print('${docSnapshot.id}');
    return docSnapshot.id;
  }

  Future<List<UserData>> getUserBase(String docId) async {
    var userBase = await db
        .collection('users')
        .doc(docId) //docId
        .collection('my_users')
        .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userdata, options) => userdata.toFirestore())
        .get();

    return userBase.docs.map((doc) => doc.data()).toList();
  }

  Future<void> asyncLoadAllData() async {
    var docId = await getDocId();
    print('Document ID: $docId');

    var userBase = await getUserBase(docId);
    state.contactList.clear();
    state.contactList.addAll(userBase);
    // for (var doc in userbase.docs) {
    //   state.contactList.add(doc.data());
  }

  Future<bool> addChatUser(String identifier) async {
    var data = await db
        .collection('users')
        .where("email", isEqualTo: identifier)
        .get();

    if (data.docs.isEmpty) {
      data = await db
          .collection('users')
          .where("phone", isEqualTo: identifier)
          .get();
    }

    if (data.docs.isNotEmpty) {
      var docSnapshot = data.docs.first;
      var _data = docSnapshot.data();

      log('User exists: ${data.docs.first.data()}');
      print(SignInController.myEmail);

      await db
          .collection('users')
          .where('email', isEqualTo: SignInController.myEmail)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        querySnapshot.docs.forEach((doc) {
          print(doc.id);
          db
              .collection('users')
              .doc(doc.id)
              .collection('my_users')
              .doc(data.docs.first.id)
              .set({});
          db
              .collection('users')
              .doc(doc.id)
              .collection('my_users')
              .doc(data.docs.first.id)
              .update(_data);
        });
      });

      await asyncLoadAllData();
      return true;
    } else {
      return false;
    }
  }
}
