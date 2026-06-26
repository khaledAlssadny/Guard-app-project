// this class will be for the UI
//GetView will be used to access the controller and it's properties
import '/./pages/Welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '/./pages/sign_in/log_in/log_in.dart';

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
                                  width: 250,
                                  height: 60,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(LoginPage());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xffe1bee7),
                                                Color(0xff7b1fa2)
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Center(
                                        child: Text(
                                          'Sign in',
                                          style: GoogleFonts.robotoCondensed(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  /*ElevatedButton(
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
                                  ),*/
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
                        size: Size.square(9),
                        activeSize: Size(18, 9),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        activeColor: Color(
                            0xff9d45c7), // Set the active dot color to black
                        color:
                            Colors.black, // Set the inactive dot color to black
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
