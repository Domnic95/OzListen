import 'dart:convert';

import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:com.ozlisten.ozlistenapp/stripe/config.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/example_scaffold.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/loading_button.dart';

class PaymentSheetScreenWithCustomFlow extends StatefulWidget {
  @override
  _PaymentSheetScreenState createState() => _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreenWithCustomFlow> {
  int step = 0;

  var emptyControlBuilder2;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Payment Sheet',
      tags: ['Custom Flow'],
      children: [
        Stepper(
          controlsBuilder: null,
          // controlsBuilder: emptyControlBuilder,
          currentStep: step,
          steps: [
            Step(
              title: Text('Init payment'),
              content: LoadingButton(
                onPressed: initPaymentSheet,
                text: 'Init payment sheet',
              ),
            ),
            Step(
              title: Text('Select payment method'),
              content: LoadingButton(
                onPressed: presentPaymentSheet,
                text: 'Select payment method',
              ),
            ),
            Step(
              title: Text('Confirm payment'),
              content: LoadingButton(
                onPressed: confirmPayment,
                text: 'Pay now',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await createTestPaymentSheet();

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Enable custom flow
          customFlow: true,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          // Extra options
          testEnv: true,
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          merchantCountryCode: 'DE',
        ),
      );
      setState(() {
        step = 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        step = 2;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment option selected'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  Future<void> confirmPayment() async {
    bool lp = true;
    String methodName = 'confirmPayment PaymentSheetScreenCustomFlow';
    p('-->129 start', '-------', methodName, lp);
    try {
      // 4. Confirm the payment sheet.
      await Stripe.instance.confirmPaymentSheetPayment();

      setState(() {
        step = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {

        p('-->151 error from stripe', e.error.localizedMessage, methodName, lp);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        p('-->151 error ', e, methodName, lp);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> createTestPaymentSheet() async {
    bool lp = true;
    String methodName = 'confirmPayment PaymentSheetScreenCustomFlow';
    p('-->129 start', '-------', methodName, lp);
    final url = Uri.parse('$kApiUrl/payment-sheet');
    final response = await http.post(
      url,
      headers: {
        'authorization': 'Bearer $skTest',
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: json.encode({
        'a': 'a',
      }),
    );
    final body = json.decode(response.body);
    p('-->173 body', body, methodName, lp);
    if (body['error'] != null) {
      throw Exception('Error code: ${body['error']}');
    }

    return body;
  }
}

final Widget Function(BuildContext _, {VoidCallback onStepCancel, VoidCallback onStepContinue}) emptyControlBuilder = (
  _, {
  VoidCallback onStepContinue,
  VoidCallback onStepCancel,
}) =>
    Container();
