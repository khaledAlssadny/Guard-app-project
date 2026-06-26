import '/./common/values/colors.dart';
import '/./common/widgets/app.dart';
import '/./pages/Contact/widgets/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'add_user.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Text(
      "Contact",
      style: TextStyle(
        color: AppColors.primaryBackground,
        fontFamily: 'Varela',
        fontSize: 20.0,
      ),
    ));
  }

// we make it bool to know if the email we entered added of not , if added we use this result to make somthing for ui

  _addChatUserDialog() {
    String email = '';
    // Future<bool> result = Future.value(false);

    Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.person_add,
              color: Color(0xff9d45c7),
              size: 28,
            ),
            Text('  Add User'),
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            hintText: 'Email Id',
            prefixIcon: const Icon(Icons.email, color: Color(0xff9d45c7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xff9d45c7), fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              Get.back();
              if (email.isNotEmpty) {
                await controller.addChatUser(email).then((value) {
                  if (!value) {
                    Get.snackbar('Error', 'User does not exist!');
                    // result = Future.value(false);
                  } else {
                    // result = result = Future.value(true);
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xff9d45c7), fontSize: 16),
            ),
          ),
        ],
      ),
    );
    //to know the result from adding email or not
    // return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: ContactList(), // use Obx here
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Get.to(AddUserScreen());
          },
          backgroundColor: Color(0xFF9D45C7), // Change the hex color value here
          child: const Icon(Icons.add_comment_rounded),
        ));
  }
}
