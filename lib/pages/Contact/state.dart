import 'dart:async';

import '/./common/entities/entities.dart';
import 'package:get/get.dart';

/*
This class is likely used in a state management architecture to keep track of the state of the contact list in a Flutter app. By wrapping these properties in reactive objects, any changes to them can automatically trigger UI updates throughout the app.
*/
class ContactState {
  //count is an RxInt object, meaning it's a reactive integer value that can be observed and reacted to whenever it's changed. In this case, it's initialized to 0.
  var count = 0.obs;
  var rebuild = 0.obs;
  //contactList is an RxList object that can hold a list of UserData objects.
  //it's also a reactive object that can be observed and reacted to whenever it's changed.
  //ya3ny zy ma al count Rxint 3lashan hwa observable fa al contactList RxList 3lashan observable
  // kan momken a5leha var 3ady bardo

  RxList<UserData> contactList = <UserData>[].obs;
}

/*
[
  UserData(
    name: 'John Doe',
    email: 'johndoe@example.com',
    phone: '555-1234'
  ),
  UserData(
    name: 'Jane Smith',
    email: 'janesmith@example.com',
    phone: '555-5678'
  ),
  UserData(
    name: 'Bob Johnson',
    email: 'bobjohnson@example.com',
    phone: '555-9876'
  )
]

In this example, the contactList object is a list of UserData objects representing three different contacts, each with a name, email address, and phone number. 
This list can be modified and observed by the application as needed.

 */
