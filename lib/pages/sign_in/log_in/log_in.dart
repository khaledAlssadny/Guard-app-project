import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/entities/user.dart';
import '../../../common/routes/names.dart';
import '../../../common/store/user.dart';
import '../../../common/values/colors.dart';
import '../../../common/widgets/app.dart';
import '../../../common/widgets/toast.dart';
import '../forget_password.dart';
import '../view.dart';
import '../controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
import '/./pages/sign_in/index.dart';

class LoginPage extends GetView<SignInController> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  final db = FirebaseFirestore.instance;

  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Text("Log in",
            style: TextStyle(
                color: AppColors.primaryBackground,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600)));
  }

  Future signIn(String email, password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        /* .then((value) {
      SignInController.myEmail = value.user!.email;
      SignInController.token = value.user!.uid;
      
      print('From SignIn() : ${value.user!.email}');
      print("from sign in : email is ${SignInController.myEmail}");
      print("from sign in : token is ${SignInController.token}");
      Get.toNamed(AppRoutes.Application);
    });*/
        .then((value) async {
      SignInController.myEmail = value.user!.email;
      SignInController.token = value.user!.uid;
      String? displayName = value.user!.displayName;
      String? email = value.user!.email;
      String id = value.user!.uid;
      String? photoUrl = value.user!.photoURL;
      String? phone = value.user!.phoneNumber;
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

        /*QueryDocumentSnapshot userDocument = userbase.docs.first;
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;

        // Access the field value by field name
        var phoneNumber = userData['email'];

        print(phoneNumber + 'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
        toastInfo(msg: "Login Success");*/
      }
      print("From SignIn() : email is ${SignInController.myEmail}");
      print("From SignIn() : token is ${SignInController.token}");
      Get.toNamed(AppRoutes.Application);
    }).catchError((e) {
      toastInfo(msg: "Sign in error");
      print('there is an error while create user' + e.toString());
    });
  }

  final SignInController controller = Get.put(SignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Text(
                    'Sign In',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'welcome back!',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 18, color: Color(0xff9d45c7)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xff9d45c7), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xff9d45c7), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () {
                        signIn(_emailController.text.trim(),
                            _passwordController.text.trim());
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xffe1bee7), Color(0xff7b1fa2)]),
                            /* color: Colors.amber[900],*/
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'sign in',
                            style: GoogleFonts.robotoCondensed(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.robotoCondensed(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not yet a member?',
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(SignInPage());
                        },
                        child: Text(
                          'sign up now',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.amber[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "-------------or-------------",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.h, left: 50.w, right: 50.w),
                    child: ElevatedButton(
                      onPressed: /*controller.handleSignIn()*/
                          () => controller.handleSignIn(),
                      child: Text(
                        "Sign in with Google",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      /* SignInButton(
                        Buttons.GoogleDark,
                        text: "Sign in with Google",
                        onPressed: () => controller.handleSignIn(),
                      )*/

                      /*btnFlatButtonWidget(
                          onPressed: () => controller.handleSignIn(),
                          width: 200.w,
                          height: 55.h,
                          title: "Google Login in")*/
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
