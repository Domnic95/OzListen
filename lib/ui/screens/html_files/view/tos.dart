import 'dart:async';

import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/utils/remote_address.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TosPage extends StatefulWidget{

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => TosPage(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return TosPageState();
  }

}
class TosPageState extends State<TosPage>{
  WebViewController webViewController;
  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = RemoteAddress.tos;
    String url = baseUrl;
    return Scaffold(
      appBar: AppBar(title: Text('Terms of Service'),
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