import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePaymentPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => StripePaymentPage(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return StripePaymentPageState();
  }
}

class StripePaymentPageState extends State<StripePaymentPage> {
  WebViewController webViewController;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool lp = true;
    String methodName = 'build StripePay.dart';
    String baseUrl = Uri.parse('assets/stripepay.html') as String;
    String url = baseUrl;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: primaryColor,
      ),
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
                onMessageReceived: (JavascriptMessage message) {
                  p('-->55 message', message.message, 'onMessageReceived', lp);
                })
          },
          onWebViewCreated: (WebViewController w) {
            webViewController = w;
          },
          onPageFinished: (String url) {
            p('-->65 url', url, 'onPageFinished', lp);
            // _redirectToStripe(widget.sessionId);
          },
        )),
      ),
    );
  }
/*
  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';

    try {
      await webViewController.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }*/
}
