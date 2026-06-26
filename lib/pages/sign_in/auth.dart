/*import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/log_in.dart';
import 'package:firebase/welcome.dart';*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/routes/names.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('Yes has data');
          Navigator.pushNamed(context, AppRoutes.Application);
        } else {
          print('No data!!!!!!!!');
          Navigator.pushNamed(context, AppRoutes.INITIAL);
        }
        return Scaffold(
            body: Container(
          child: Text('hey there'),
        ));
      },
    );
  }
}




















/*
class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            Navigator.pushNamed(context, AppRoutes.Application);
          } else {
            Navigator.pushNamed(context, AppRoutes.INITIAL);
            //AppRoutes.INITIAL
          }
        }),
      ),
    );
  }
}

*/