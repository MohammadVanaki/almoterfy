import 'package:almoterfy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final String url;
  const PrivacyPolicyPage({
    super.key,
    required this.url,
  });

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
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
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
