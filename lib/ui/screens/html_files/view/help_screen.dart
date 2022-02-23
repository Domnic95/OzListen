import 'dart:async';

import 'package:com.ozlisten.ozlistenapp/utils/remote_address.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatefulWidget{

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => HelpScreen(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return HelpScreenState();
  }

}
class HelpScreenState extends State<HelpScreen>{
  WebViewController webViewController;
  @override
  initState(){
    super.initState();
  }
// https://www.forte-analytics.com/help#app

  @override
  Widget build(BuildContext context) {
    String baseUrl = RemoteAddress.base;
    String url = baseUrl + "help#app";
    return Center(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'HelpScreen',
                onMessageReceived: (JavascriptMessage message) {
                })
          ]),
          onWebViewCreated: (WebViewController w) {
            webViewController = w;
          },
        )
    );
  }

}