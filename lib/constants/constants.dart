import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Constants {
  static Color themeColor = const Color.fromARGB(255, 45, 122, 104);
  static Color iconsColor = const Color(0xFFaf9e6a);
  static Color itemColor = const Color.fromARGB(255, 86, 88, 87);

  static double fontSize = 24;
  static double lineHeight = 1.8;
  static String fcmToken = '';
  static const String regularFontFamily = 'Jazeera-Regular';
  static const String boldFontFamily = 'Jazeera-Bold';
  static const String imageURLPrefix =
      'https://almoterfy.com/upload_list/thumbs/';
  static const String sliderImageURLPrefix =
      'https://almoterfy.com/upload_list/source/';
  static const String shareAppText = 'ارسل بواسطة تطبيق (المطيرفي)\n';
  static PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  static bool changeCategory = false;
  static bool refreshNews = false;
  static bool hasbookmark = false;
  static bool connectToInternet = true;
  static List<dynamic> bookMarkContent = [];
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

connected() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      debugPrint('connected');
      Constants.connectToInternet = true;
    }
  } on SocketException catch (_) {
    debugPrint('not connected');
    Constants.connectToInternet = false;
  }
}
