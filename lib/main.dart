import 'dart:developer' as devlog;
import 'dart:io';

import 'package:cui_timetable/controllers/csv/csv_controller.dart';
import 'package:cui_timetable/controllers/database/database_controller.dart';
import 'package:cui_timetable/controllers/developer/developer_controller.dart';
import 'package:cui_timetable/controllers/firebase/firebase_controller.dart';
import 'package:cui_timetable/controllers/freerooms/freerooms_controller.dart';
import 'package:cui_timetable/controllers/home/home_controller.dart';
import 'package:cui_timetable/firebase_options.dart';
import 'package:cui_timetable/style.dart';
import 'package:cui_timetable/views/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  final loc = await getApplicationDocumentsDirectory();
  Hive.init(loc.path.toString());

  final box = await Hive.openBox('info');
  box.put('updated', false);
  print(box.get('updated'));
}

Future<void> main() async {
  await _initialized();
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

Future<void> _initialized() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  devlog.log("Firebase Initialized...", name: 'FIREBASE');

  final loc = await getApplicationDocumentsDirectory();
  Hive.init(loc.path.toString());
  // final box = await Hive.openBox('info');
  // box.put('version', 1);

  devlog.log("Hive Initialized...", name: 'HIVE');

  // Initialize the important Controllers
  //* ============================================ //
  Get.put(FirebaseController()); //! Criticial to load first
  Get.put(DatabaseController()); // ! 2
  Get.put(HomeController());
  Get.put(FreeRoomsController());
  // final startUpController = Get.put(StartUpController()); // *2
  // Get.put(StartUpController()); // *2
  Get.put(DeveloperController()); // *3
  // Get.put(CsvController());
  //* ============================================ //

  // print(DateFormat.yMMMd]().format(DateTime.now()));
  // final box = await Hive.openBox('CS Mr. Ahmad Shaf');
  // print(box.values.toList().where((element) => element[2] == "2"));

  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    print('not connected');
  }
}

/// Root Widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: lightTheme(context),
        title: 'CUI TIMETABLE',
        debugShowCheckedModeBanner: false,
        home: SafeArea(top: false, child: Home()));
  }
}
