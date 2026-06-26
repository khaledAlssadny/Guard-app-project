// this class will be for the UI
//GetView will be used to access the controller and it's properties
import 'package:flutter/material.dart';
import 'controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'log_in/log_in.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

//In Flutter development, the GetView class is a type of widget provided by the Get package that is used to create stateless widgets that depend on a specific controller or service.
//This allows the SignInPage widget to access the properties and methods of the SignInController class.
class SignInPage extends GetView<SignInController> {
  var _emailController = TextEditingController();
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneController = TextEditingController();
  String? profileImage;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
  }

  final SignInController controller = Get.put(SignInController());
  var image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(9), // Add padding to the container,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            Container(
              width: 200.w,
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Obx(() {
                        if (controller.image.value.isEmpty) {
                          return Container(
                            width: 150.w,
                            height: 150,
                            child: GestureDetector(
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xff9d45c7),
                                    width: 3,
                                  ),
                                ),
                                child: Icon(Icons.person,
                                    color: Color(0xff9d45c7)),
                              ),
                              onTap: () async {
                                await controller.pickImage();
                              },
                            ),
                          );
                        } else {
                          return GestureDetector(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: FileImage(controller.MyImage),
                            ),
                            onTap: () async {
                              await controller.pickImage();
                              profileImage = controller.image.value;
                            },
                          );
                        }
                      }),
                      IconButton(
                        onPressed: () async {
                          await controller.pickImage();
                          profileImage = controller.image.value;
                        },
                        icon: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xff9d45c7),
                          child: Icon(Icons.camera_alt_outlined,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xff9d45c7), width: 2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xff9d45c7), width: 2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xff9d45c7), width: 2)),
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
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xff9d45c7), width: 2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone',
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
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  bool isEmailValid =
                      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(email);
                  bool isPasswordValid = password.length >= 6;
                  bool hasPhoto =
                      profileImage != null && profileImage!.isNotEmpty;

                  if (!isEmailValid) {
                    Get.snackbar(
                        'Invalid Email', 'Please enter a valid email address');
                    return;
                  }

                  if (!isPasswordValid) {
                    Get.snackbar('Invalid Password',
                        'Password should be 6 characters or more');
                    return;
                  }

                  if (!hasPhoto) {
                    Get.snackbar('Missing Photo', 'Please select a photo');
                    return;
                  }

                  String photoUrl = profileImage!;

                  SignInController.instance.signUp(
                    name: _nameController.text.trim(),
                    email: email,
                    password: password,
                    phone_: _phoneController.text.trim(),
                    photourl: photoUrl,
                  );
                  Get.to(LoginPage());
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xffe1bee7), Color(0xff7b1fa2)]),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'sign up',
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a member?',
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(LoginPage());
                  },
                  child: Text(
                    'sign in here',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.amber[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "-------------or-------------",
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h, left: 50.w, right: 50.w),
              child: ElevatedButton.icon(
                onPressed: () => controller.handleSignIn(),
                icon: Image.asset(
                  'assets/images/google_logo.png', // Add your Google logo here
                  height: 24.h,
                  width: 24.w,
                ),
                label: Text(
                  "Sign up with Google",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 2,
                ),
              ),
            )

            // Padding(
            //     padding: EdgeInsets.only(top: 10.h, left: 50.w, right: 50.w),
            //     child: SignInButton(
            //       Buttons.GoogleDark,
            //       text: "Sign up with Google",
            //       onPressed: () => controller.handleSignIn(),
            //     ))
          ],
        ),
      ),
    );
  }
}
