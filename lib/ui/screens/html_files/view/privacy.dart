import 'dart:async';

import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/utils/remote_address.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyHtmlPage extends StatefulWidget{

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => PrivacyHtmlPage(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return PrivacyHtmlPageState();
  }

}
class PrivacyHtmlPageState extends State<PrivacyHtmlPage>{
  WebViewController webViewController;
  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = RemoteAddress.privacy;
    String url = baseUrl;
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy'),
          backgroundColor: primaryColor,),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: {
                JavascriptChannel(
                    name: 'HtmlScaffold',
                    onMessageReceived: (JavascriptMessage message) {})
              },
              onWebViewCreated: (WebViewController w) {
                webViewController = w;
              },
            )),
      ),
    );
  }

}