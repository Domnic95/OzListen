
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HtmlScaffold(
          url: ROOT_ONLY + 'help#app',
          title: 'Help Pages')));
}

class HtmlScaffold extends StatefulWidget {
  String url;
  String title;

  HtmlScaffold({Key key, this.url, this.title})
      : super(key: key);

  static Route route(String url, String title) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            MaterialApp(
                debugShowCheckedModeBanner:false,
                home: HtmlScaffold(url: url, title: title)));
  }

  @override
  _HtmlScaffoldState createState() => _HtmlScaffoldState();
}

class _HtmlScaffoldState extends State<HtmlScaffold> {
  WebViewController webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.url;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
