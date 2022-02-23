import 'package:com.ozlisten.ozlistenapp/album/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/custom_card_payment_screen.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/dismiss_focus_overlay.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/no_webhook_payment_cardform_screen.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/screens.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/webhook_payment_screen.dart';

import 'custom_card_payment_screen.dart';
// import 'package:stripe_example/.env.dart';

void main() async {
  runApp(StripeMain());
}

class StripeMain extends StatelessWidget {
  String amount;
  Album album;
  StripeMain({Key key, this.amount, this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissFocusOverlay(
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        theme: exampleAppTheme,
        home: CustomCardPaymentScreen(amount:amount, album: album),
      ),
    );
  }
}

final exampleAppTheme = ThemeData(
  colorScheme: ColorScheme.light(
      primary: Color(0xff6058F7), secondary: Color(0xff6058F7)),
  primaryColor: Colors.white,
  appBarTheme: AppBarTheme(elevation: 1),
);
