import 'dart:io';

import 'package:almoterfy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.themeColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("AppBar back pressed");
                Navigator.pop(context);
              },
              child: SvgPicture.asset('./Assets/svgs/angle-left.svg',
                  color: Colors.white, width: 24, height: 24),
            ),
            Image.asset(
              './Assets/images/logo-almoterfy.png',
              fit: BoxFit.cover,
              width: 100,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "المطيرفي يمزج بين الأخبار والمواضيع الدينية والاجتماعية والرياضية والاجتماعية ومقالات لكبار الكتاب، حرصا على إرضاء قراءها بتنوع اهتماماته بجانب المواد الخبرية التي تتفق مع مبادئ الموضوعية والتنوير والوسطية ونحرص على اللحمة الوطنية، يعتمد موقع المطيرفي على الابتكار والأشكال الحديثة المعتمدة على التفاعل وتحويل المعلومات إلى مواد جذابة، إضافة الفيديو والصوتيات المميزة، كما نحرص أيضا على تقديم خدمات التواصل الاجتماعي بدعوات الأفراح والحوادث والوفيات.",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
            height: 2.0,
            fontFamily: Constants.regularFontFamily,
          ),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: Platform.isAndroid
              ? MediaQuery.of(context).viewPadding.bottom
              : 0,
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            // border: Border.top: BorderSide(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  './Assets/svgs/envelope-open.svg',
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _launchUrl('mailto:info@almoterfy.com');
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  './Assets/svgs/twitter-alt.svg',
                  colorFilter:
                      ColorFilter.mode(Colors.blue[400]!, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _launchUrl('https://x.com/AbdullaJassimaa');
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  './Assets/svgs/telegram.svg',
                  colorFilter:
                      ColorFilter.mode(Colors.blue[300]!, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _launchUrl('https://t.me/Almoterfy');
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  './Assets/svgs/whatsapp.svg',
                  colorFilter:
                      ColorFilter.mode(Colors.green[500]!, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _launchUrl('https://wa.me/966505913494');
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  './Assets/svgs/facebook.svg',
                  colorFilter:
                      ColorFilter.mode(Colors.blue[800]!, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _launchUrl('https://www.facebook.com/moterfy.almoterfy/');
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  './Assets/svgs/instagram.svg',
                  colorFilter:
                      ColorFilter.mode(Colors.pink[600]!, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  _launchUrl('https://www.instagram.com/ab.dulla4567/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl(_url) async {
  debugPrint('--------------------------------------------');
  if (!await launchUrl(Uri.parse(_url))) {
    throw Exception('Could not launch $_url');
  }
}
