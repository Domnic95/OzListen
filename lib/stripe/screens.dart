import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/no_webhook_payment_cardform_screen.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/no_webhook_payment_screen.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/payment_sheet_screen.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/payment_sheet_screen_custom_flow.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/themes.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/webhook_payment_screen.dart';

import 'custom_card_payment_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ExampleSection()) ;

}

class ExampleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool expanded;

  const ExampleSection({
    Key key,
    this.title,
    this.children,
    this.expanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: NoWebhookPaymentCardFormScreen());
  }
}