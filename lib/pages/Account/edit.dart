import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateUserNameScreen extends StatefulWidget {
  final String userId;

  UpdateUserNameScreen({required this.userId});

  @override
  _UpdateUserNameScreenState createState() => _UpdateUserNameScreenState();
}

class _UpdateUserNameScreenState extends State<UpdateUserNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _photoUrl;
  bool _isEditing = false;

  void _updateUserNameAndPhoneNumber() async {
    String newName = _nameController.text;
    String newPhoneNumber = _phoneController.text;
    String newEmail = _emailController.text;

    // Update the user's name and phone number in the Firestore database
    await _firestore
        .collection('users')
        .doc(widget.userId)
        .update({'name': newName, 'phone': newPhoneNumber, 'email': newEmail});

    // Display a success message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Name and Phone Number Updated'),
        content:
            Text('Your name and phone number have been updated successfully.'),
        actions: [
          TextButton(
            child: Text('OK',style: GoogleFonts.robotoCondensed(
                color: Color(0xff9d45c7),
                fontWeight: FontWeight.bold,
                fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(widget.userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['name'];
        _phoneController.text = userData['phone'];
        _emailController.text = userData['email'];
        _photoUrl = userData['photourl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_photoUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(_photoUrl!),
                  radius: 50.0,
                ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'New Name',
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
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'New Phone Number',
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
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'New Email Address',
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
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isEditing
                    ? _updateUserNameAndPhoneNumber
                    : () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 0),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
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
                      child: Text(
                        _isEditing ? 'Save' : 'Edit',
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
      ),


    );
  }
}
