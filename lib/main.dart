import 'dart:io';

import 'package:almoterfy/constants/constants.dart';
import 'package:almoterfy/db/badr_database.dart';
import 'package:almoterfy/notif/firebase_notification_service.dart';
import 'package:almoterfy/screens/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_api_availability/google_api_availability.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await checkGooglePlayServices().timeout(const Duration(seconds: 10));
  }
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: const AlmoterfyNews()),
  );
}

class AlmoterfyNews extends StatefulWidget {
  const AlmoterfyNews({super.key});

  @override
  State<AlmoterfyNews> createState() => _AlmoterfyNewsState();
}

class _AlmoterfyNewsState extends State<AlmoterfyNews> {
  InitializeDB initializeDB = InitializeDB();

  _getContent() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      Constants.fontSize = pref.getDouble("fontsize") ?? 17;
      Constants.lineHeight = pref.getDouble("lineheight") ?? 1.8;
    });
  }

  @override
  initState() {
    _getContent();
    initializeDB.initDb();
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      Constants.packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}

Future<void> checkGooglePlayServices() async {
  GooglePlayServicesAvailability availability = await GoogleApiAvailability
      .instance
      .checkGooglePlayServicesAvailability();

  if (availability != GooglePlayServicesAvailability.success) {
    debugPrint('Google Play Services not available: $availability');

    debugPrint(
        'Google Play Services is not available: ${availability.toString()}');
  } else {
    debugPrint('Google Play Services is available.');

    try {
      await Firebase.initializeApp().timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Firebase init failed or timed out: $e');
    }

    FirebaseMessaging.onBackgroundMessage(handleFirebaseBackgroundMessage);

    await FirebaseNotificationService().initializeNotifications();
  }
}
