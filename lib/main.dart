import 'dart:developer' as devlog;

import 'package:cui_timetable/app/routes/app_pages.dart';
import 'package:cui_timetable/app/theme/light_theme_for_large_screens.dart';
import 'package:cui_timetable/app/theme/light_theme_for_small_screens.dart';
import 'package:cui_timetable/app/utilities/location/loc_utilities.dart';
import 'package:cui_timetable/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  await _initialized();

  runApp(const MyApp());
}

Future<void> _initialized() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await LocationUtilities.initialize();

  await Firebase.initializeApp(
    name: 'cui-timetable',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  devlog.log("Firebase Initialized...", name: 'FIREBASE');

  Hive.init(LocationUtilities.defaultpath);
  devlog.log("Hive Initialized...", name: 'HIVE');
}

/// Root Widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 380) {
          return GetMaterialApp(
            theme: lightThemeForSmallScreens(context),
            defaultTransition: Transition.cupertino,
            transitionDuration: const Duration(milliseconds: 300),
            title: 'CUI TIMETABLE',
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
        } else {
          return GetMaterialApp(
            theme: lightThemeForLargeScreens(context),
            defaultTransition: Transition.cupertino,
            transitionDuration: const Duration(milliseconds: 300),
            title: 'CUI TIMETABLE',
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
        }
      },
    );
  }
}
