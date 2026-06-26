import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final ContactController myController = Get.put(ContactController());
  final TextEditingController _emailController = TextEditingController();
  String? errorMessage;
  void _addUser(String currentUserEmail, String newUserEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Retrieve current user data
    DocumentSnapshot<Object?> currentUserSnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);

    if (!currentUserSnapshot.exists) {
      print('Current user with email $currentUserEmail does not exist.');
      return;
    }

    // Retrieve new user data
    DocumentSnapshot<Object?> newUserSnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: newUserEmail)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);

    if (!newUserSnapshot.exists) {
      print('User with email $newUserEmail does not exist.');
      return;
    }

    // Add new user to current user's my_users subcollection
    String currentUserId = currentUserSnapshot.id;
    Map<String, dynamic> newUserData =
        newUserSnapshot.data() as Map<String, dynamic>;
    await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('my_users')
        .doc(newUserSnapshot.id)
        .set(newUserData);

    print(
        'New user with email $newUserEmail added to current user\'s my_users.');

    setState(() {
      errorMessage = null;
    });

    // Add current user to new user's my_users subcollection
    String newUserId = newUserSnapshot.id;
    Map<String, dynamic> currentUserData =
        currentUserSnapshot.data() as Map<String, dynamic>;
    await firestore
        .collection('users')
        .doc(newUserId)
        .collection('my_users')
        .doc(currentUserId)
        .set(currentUserData);

    print(
        'Current user with email $currentUserEmail added to new user\'s my_users.');

    // Clear the email field after adding the user
    _emailController.clear();

    // Show a pop-up dialog indicating that the user has been added successfully
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Added'),
          content: Text('The user $newUserEmail has been added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',style: GoogleFonts.robotoCondensed(
                  color: Color(0xff9d45c7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),),
            ),
          ],
        );
      },
    );
    await myController.asyncLoadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        backgroundColor: Color(0xff9d45c7),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          /*children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'User Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String currentUserEmail =
                    FirebaseAuth.instance.currentUser!.email!;
                String newUserEmail = _emailController.text.trim();

                _addUser(currentUserEmail, newUserEmail);
              },
              child: Text('Add User'),
            ),
          ],*/
          children: [
            SizedBox(
              height: 100,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'User Email',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xff9d45c7),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xff9d45c7),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Colors.red,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email';
                } else if (errorMessage != null) {
                  return errorMessage;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  errorMessage = null;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed:() {
            String currentUserEmail =
            FirebaseAuth.instance.currentUser!.email!;
            String newUserEmail = _emailController.text.trim();

            _addUser(currentUserEmail, newUserEmail);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white),
                ),
                primary: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffe1bee7), Color(0xff7b1fa2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 60,
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child:

                         Text(
                      'Add user',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
