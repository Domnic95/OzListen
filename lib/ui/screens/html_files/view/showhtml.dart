import 'dart:io';

import 'package:com.ozlisten.ozlistenapp/ui/screens/html_files/view/flutter_web_browser.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "https://flutter.io/");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app for Sean'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () => FlutterWebBrowser.warmup(),
                child: Text('Warmup browser website'),
              ),
              RaisedButton(
                onPressed: () => openBrowserTab(),
                child: Text('Open Flutter website'),
              ),
              if (Platform.isAndroid) ...[
                Text('test Android customizations'),
                RaisedButton(
                  onPressed: () {
                    FlutterWebBrowser.openWebPage(
                      url: "https://flutter.io/",
                      customTabsOptions: CustomTabsOptions(
                        colorScheme: CustomTabsColorScheme.dark,
                        toolbarColor: Colors.deepPurple,
                        secondaryToolbarColor: Colors.green,
                        navigationBarColor: Colors.amber,
                        addDefaultShareMenuItem: true,
                        instantAppsEnabled: true,
                        showTitle: true,
                        urlBarHidingEnabled: true,
                      ),
                    );
                  },
                  child: Text('Open Flutter website'),
                ),
              ],
              if (Platform.isIOS) ...[
                Text('test iOS customizations'),
                RaisedButton(
                  onPressed: () {
                    FlutterWebBrowser.openWebPage(
                      url: "https://flutter.io/",
                      safariVCOptions: SafariViewControllerOptions(
                        barCollapsingEnabled: true,
                        preferredBarTintColor: Colors.green,
                        preferredControlTintColor: Colors.amber,
                        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
                        modalPresentationCapturesStatusBarAppearance: true,
                      ),
                    );
                  },
                  child: Text('Open Flutter website'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
