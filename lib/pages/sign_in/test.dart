/*
class WelcomePage extends GetView<WelcomeController> {
  @override
  Widget build(BuildContext context) {
    //I will make onBoarding Screen here
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Obx(() => SizedBox(
              width: 360.w, //360
              height: 780.w,
              //780
              child: Stack(
                alignment: Alignment
                    .bottomCenter, //align stack child widgets at the bottom center of the screen.
                children: [
                  PageView(
                    scrollDirection: Axis.horizontal,
                    reverse: false,
                    onPageChanged: (index) {
                      controller.changePage(index);
                    },
                    controller: PageController(
                        initialPage:
                            0, //value of 0 means the first page will be displayed by default.
                        keepPage: false,
                        viewportFraction: 1),
                    pageSnapping: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/photo1.jpg"))),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                // fit: BoxFit.fill,
                                image: AssetImage("assets/images/photo2.jpg"))),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                // fit: BoxFit.fill,
                                image: AssetImage("assets/images/photo3.jpg"))),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                                bottom: 90,
                                child: SizedBox(
                                  width: 150,
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.handleSignIn();
                                    },
                                    child: const Text("Login",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Roboto')),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        side: MaterialStateProperty.all(
                                            const BorderSide(
                                                color: Colors.white))),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      bottom: 70,
                      child: DotsIndicator(
                        position: controller.state.index.value.toDouble(),
                        dotsCount: 3,
                        reversed: false,
                        mainAxisAlignment: MainAxisAlignment.center,
                        decorator: DotsDecorator(
                            size: Size.square(
                                9), //means that each dot will have a width and height of 9 pixels.
                            activeSize: Size(18,
                                9), // means that the currently active dot will have a width of 18 pixels and a height of 9 pixels.
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ))
                ],
              ),
            )));
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////


// this class will be for the UI
//GetView will be used to access the controller and it's properties
import '././common/style/color.dart';
import '././common/values/shadows.dart';
import '././common/widgets/app.dart';
import '././common/widgets/button.dart';
import '././pages/Contact/widgets/contact_list.dart';
import '././pages/Welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../common/values/colors.dart';
import 'index.dart';

//In Flutter development, the GetView class is a type of widget provided by the Get package that is used to create stateless widgets that depend on a specific controller or service.
//This allows the SignInPage widget to access the properties and methods of the SignInController class.
class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Text(
      "Contact",
      style: TextStyle(
          color: AppColors.primaryBackground,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // print(controller.state.contactList.length);
    return Scaffold(
      appBar: _buildAppBar(),
      body: ContactList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Doneeeeeeeeeeeeeeeee");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
}



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
                  data);
                  */
