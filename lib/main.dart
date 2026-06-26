import '/./common/routes/routes.dart';
import '/./common/services/services.dart';
import '/./common/store/config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'common/store/user.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*Get package is used to register an instance of the StorageService class with the application's dependency injection system by calling Get.putAsync<StorageService>(() => StorageService().init()). 
  The putAsync() method is used here because init() is an asynchronous method that needs to be awaited before the instance is registered. 
  This code initializes the SharedPreferences instance in the StorageService class and returns the instance, which is then registered with the dependency injection system.
  Similarly, an instance of the ConfigStore class is registered with the dependency injection system using Get.put<ConfigStore>(ConfigStore()).
   */
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserStore>(UserStore());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //GetMaterialApp is an extension of MaterialApp provided by the get package.
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        //home: Center(child: Container(child: Text("sha8al"))),
      ),
    );
  }
}
