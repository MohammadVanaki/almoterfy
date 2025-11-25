import 'package:almoterfy/constants/constants.dart';
import 'package:almoterfy/screens/about_page.dart';
import 'package:almoterfy/screens/privacy_policy_page.dart';
import 'package:almoterfy/screens/bookmark_page.dart';
import 'package:almoterfy/screens/news_list_page.dart';
import 'package:almoterfy/screens/search_page.dart';
import 'package:almoterfy/screens/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 1;
  static const List iconList = [
    'settings',
    'house',
    'search',
  ];
  final List<String> drawerItemText = [
    "الرئيسية",
    "المفضله",
    "من نحن",
    "اتصل بنا",
    "سياسة الخصوصية",
    "مشاركة التطبيق",
  ];
  final List drawerItemIcon = [
    'house',
    'bookmark',
    'info',
    'envelope-open',
    'confidential-discussion',
    'share',
  ];
  List<Widget> pages() {
    return [
      // ignore: prefer_const_constructors
      SettingPage(),
      // ignore: prefer_const_constructors
      NewsListPag(),
      // BookMarkPage(),
      SearchPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.themeColor,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              './Assets/images/logo-almoterfy.png',
              fit: BoxFit.cover,
              width: 100,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset(
                './Assets/svgs/bars-staggered.svg',
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 24,
                height: 24,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: IndexedStack(
          index: _bottomNavIndex,
          children: pages(),
        ),
        drawer: Drawer(
          width: 300,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Constants.themeColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        './Assets/images/logo-almoterfy.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(
                        drawerItemIcon.length,
                        (index) => DrawerItems(
                          title: drawerItemText[index],
                          icon: drawerItemIcon[index],
                          tag: index,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  Text(
                    "الاصدار: 1.0",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: Constants.regularFontFamily,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      // English comment: Handle tap to launch the URL
                      onTap: () => _launchUrl('https://dijlah.org'),
                      child: RichText(
                        text: TextSpan(
                          text: 'Powered by ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          children: const [
                            TextSpan(
                              // English comment: Highlight the brand name with color and bold style
                              text: 'DIjlah IT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                isActive
                    ? './Assets/fill/${iconList[index]}.svg'
                    : './Assets/svgs/${iconList[index]}.svg',
                colorFilter: ColorFilter.mode(
                    isActive ? Constants.themeColor : Colors.black,
                    BlendMode.srcIn),
              ),
            );
          },
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(
            () {
              _bottomNavIndex = index;
            },
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

class DrawerItems extends StatelessWidget {
  final String title;
  final String icon;
  final int tag;
  const DrawerItems({
    super.key,
    required this.title,
    required this.icon,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        debugPrint(tag.toString());
        switch (tag) {
          case 0:
            Scaffold.of(context).closeDrawer();
            break;
          case 1:
            Navigator.push(
              context,
              PageTransition(
                child: const BookMarkPage(),
                type: PageTransitionType.bottomToTop,
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              PageTransition(
                child: const AboutPage(),
                type: PageTransitionType.bottomToTop,
              ),
            );
            break;
          case 3:
            final Email email = Email(
              recipients: ['info@almoterfy.com'],
              isHTML: false,
            );

            await FlutterEmailSender.send(email);
            break;
          case 4:
            Navigator.push(
              context,
              PageTransition(
                child: const PrivacyPolicyPage(
                  url: 'https://almoterfy.com/privacy_policy.html',
                ),
                type: PageTransitionType.bottomToTop,
              ),
            );
            break;
          case 5:
            final box = context.findRenderObject() as RenderBox?;
            Share.share(
              "أدعوك للاطلاع على تطبيق (${Constants.packageInfo.appName}) وذلك عبر الرابط التالي: \n https://play.google.com/store/apps/details?id=${Constants.packageInfo.packageName}",
              subject: "المشاركة ضمن:",
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            );

            break;

          default:
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10).copyWith(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            SvgPicture.asset(
              './Assets/svgs/${icon}.svg',
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontFamily: Constants.regularFontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
