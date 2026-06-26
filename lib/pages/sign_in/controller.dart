import 'dart:io';
// import 'package:emergency/common/entities/entities.dart';
// import 'package:emergency/common/routes/names.dart';
// import 'package:emergency/common/store/store.dart';
// import 'package:emergency/common/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../common/entities/user.dart';
import '../../common/routes/names.dart';
import '../../common/store/user.dart';
import '../../common/widgets/toast.dart';
import 'index.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '././common/entities/entities.dart';
import '././common/routes/names.dart';
import '././common/store/store.dart';
import '././common/widgets/toast.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

/*
This code initializes an instance of the GoogleSignIn class from the google_sign_in package in Flutter.
The GoogleSignIn class provides functionality for signing in with a Google account in Flutter apps.
The scopes parameter specifies a list of OAuth 2.0 scopes that the app requests authorization for from the user during sign-in. 
In this case, the only scope requested is openid, which is an OpenID Connect authentication protocol that allows users to authenticate with an app using their Google account.
*/
GoogleSignIn _googleSignIn = GoogleSignIn();

// scopes: <String>['openid'],
// clientId:
//     "1060321377308-h3valkgap834gehp69d2pgiinmm5do28.apps.googleusercontent.com"

class SignInController extends GetxController {
  final state = SignInState();
  SignInController();
  static SignInController instance = Get.find();
  final db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  static var user1;
  var _emailController = TextEditingController();
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmpasswordController = TextEditingController();
  late final XFile? file;
  var MyImage;
  static var myEmail;
  static var token;

  String? profileImage;
  var image = ''.obs;

  ImagePicker picker = ImagePicker();
  selectImageFromGallery() async {
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    profileImage = file!.path;
    if (file != null) {
      return file;
    } else {
      return '';
    }
  }

//chat gpt
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = pickedFile.path;
      MyImage = File(image.value);
      // Do something with the image
      return MyImage;
    }
  }

  selectImageFromCamera() async {
    final XFile? file =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  // var picker = ImagePicker();

  /*Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }*/

  /*void register(String email, password) {
    auth.createUserWithEmailAndPassword(email: email, password: password);
  }*/

  Future signUp(
      {required String name,
      required String email,
      required String password,
      required String phone_,
      required String photourl}) async {
    bool passwordConfirmid() {
      if (password == password) {
        return true;
      } else {
        return false;
      }
    }

    if (passwordConfirmid()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        myEmail = value.user!.email;
        token = value.user!.uid;
        String displayName = name;
        String? email = value.user!.email;
        String id = value.user!.uid;
        String photoUrl = photourl;
        String phone = phone_;
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.email = email;
        userProfile.accessToken = id;
        userProfile.displayName = displayName;
        userProfile.photoUrl = photoUrl;
        userProfile.phone = phone;
        UserStore.to.saveProfile(userProfile);
        var userbase = await db
            .collection("users")
            .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userdata, options) =>
                    userdata.toFirestore())
            .where("id", isEqualTo: id)
            .get();
        if (userbase.docs.isEmpty) {
          final data = UserData(
              id: id,
              name: displayName,
              email: email,
              photourl: photoUrl,
              phone: phone,
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now());
          //add data
          await db
              .collection("users")
              .withConverter(
                  // for mapping Firestore data to the UserData class.
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) =>
                      userdata.toFirestore())
              .add(data);
          toastInfo(msg: "Sign up Success");
        }

        print("from sign up : email is $myEmail");
        print("from sign up : token is $token");

        /*userCreate(
            name: name,
            id: value.user!.uid,
            email: email,
            phone: phone,
            photourl: photourl);*/
      }).catchError((e) {
        toastInfo(msg: "Sign up error");
        print('there is an error while create user' + e.toString());
      });
      // Navigator.of(context).pushNamed('auth');
    }
  }
/*
  Future<void> userCreate({
    required String? name,
    required String? id,
    required String? email,
    required String? phone,
    String? photourl,
    String? location,
    String? fcmtoken,
    Timestamp? addtime,
  }) async {
    UserData model = UserData(
      name: name,
      id: id,
      email: email,
      phone: phone,
      photourl: photourl ?? "",
      location: location ?? "",
      fcmtoken: fcmtoken ?? "",
      addtime: Timestamp.now(),
    );
    await db.collection("users").doc(id).set(model.toFirestore()).then((value) {
      print('success create data');
    }).catchError((e) {
      print('error while create data $e');
    });
  }
  */
  /*void openLoginScreen() {
    Navigator.of(context).pushReplacementNamed('loginScreen');
  }*/

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
  }

  Future<void> handleSignIn() async {
    try {
      //First, the function calls the signIn() method of the _googleSignIn object,
      //which displays a native Google sign-in flow and returns a GoogleSignInAccount object containing the user's basic profile information.
      var user = await _googleSignIn.signIn();
      print('_____googleSignIn.signIn() : $user ');
      user1 = user;
      myEmail = user1.email;
      // token = UserStore.to.token;
      // print("from google sign in : Email is $myEmail");
      // print("from google sign in : token is $token");

      //If the user successfully signs in, the signIn() method returns a non-null GoogleSignInAccount object, and the function extracts the user's display name or email address from the displayName property or the email property of the GoogleSignInAccount object, respectively.
      // so, "user" is a variable that represents the user object returned by Google Sign-In after the user has successfully authenticated.
      //The if statement checks whether user is not null, which means that the user has signed in successfully.
      if (user != null) {
        //credentials include a username and password combination
        //When a user signs in with Google, their credentials are first obtained using the user.authentication
        //This returns a GoogleAuthCredential object that contains an access token and an ID token
        final _gAuthentication = await user.authentication;
        print('_____user.authentication : $_gAuthentication');
        print('_gAuthentication.idToken : ${_gAuthentication.idToken}');
        print('_gAuthentication.accessToken : ${_gAuthentication.accessToken}');
        //retrieves the authentication object from the user object by calling await user.authentication. The authentication object contains the idToken and accessToken properties that are needed to create a credential.
        final _credential = GoogleAuthProvider.credential(
            //The GoogleAuthProvider.credential method creates a credential object that combines the idToken and accessToken properties from the authentication object.
            idToken: _gAuthentication.idToken,
            accessToken: _gAuthentication.accessToken);
        await FirebaseAuth.instance.signInWithCredential(
            _credential); //sign in the user to Firebase Authentication with the credential object as By signing in with this credential, Firebase Authentication can verify that the user is who they claim to be and grant them access to the app.

        // we have an object returning from the google api
        String displayName = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? "";

        //I will did the following step in order to save the user information in our device
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.email = email;
        userProfile.accessToken = id;
        userProfile.displayName = displayName;
        userProfile.photoUrl = photoUrl;
        //This line is calling the saveProfile method of an instance of the UserStore class, which is obtained using UserStore.to.
        // .to is actually a getter method that returns a singleton instance of the UserStore class.
        // By using UserStore.to, we are accessing a globally available instance of the UserStore controller.
        UserStore.to.saveProfile(userProfile);
        var userbase =
            await db // this line retrieves the user's information from the Firestore collection users where the id field is equal to the user's id
                .collection("users")
                .withConverter(
                    // to map Firestore data to the UserData class, which provides a way to convert Firestore documents into an object that can be used in Dart code.
                    // for mapping Firestore data to the UserData class.
                    fromFirestore: UserData.fromFirestore,
                    toFirestore: (UserData userdata, options) =>
                        userdata.toFirestore())
                .where("id", isEqualTo: id)
                .get();
        if (userbase.docs.isEmpty) {
          // if the userbase document list is empty, it means the user is logging in for the first time, so a new document is created with the user's information.
          final data = UserData(
              // create a new instance of UserData with the user's information.
              id: id,
              name: displayName,
              email: email,
              photourl: photoUrl,
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now());
          await db
              .collection("users")
              .withConverter(
                  // for mapping Firestore data to the UserData class.
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) =>
                      userdata.toFirestore())
              .add(
                  data); // add the data instance as a new document in the users collection.
        }
        /*A toast message is a brief message that appears on the screen for a short period of time to inform the user about the result of an action or to provide feedback. It is usually displayed in a small pop-up window near the bottom of the screen and disappears after a few seconds. */
        toastInfo(
            msg:
                "Login Success"); //- show a toast message indicating that the user has successfully logged in.
        ///Contact
        Get.offAndToNamed(AppRoutes.Application);
      } else {
        // Get.offAndToNamed(AppRoutes.Application);
      }
    } catch (e) {
      toastInfo(msg: "Login error");
      print('erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      print(e.toString());
    }
  }

  /*This code sets up a listener that listens to changes in the authentication state of the current user. It uses the authStateChanges() method provided by the FirebaseAuth class to listen for changes in the current user's authentication state. */
  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        //If the user is currently logged out, i.e., user == null,
        //then the code prints a message "user is currently logged out".
        print("user is currently logged out");
      } else {
        print("user is logged in ");
      }
    });
  }
}
