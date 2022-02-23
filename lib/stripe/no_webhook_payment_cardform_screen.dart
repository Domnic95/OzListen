import 'dart:convert';

import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/config.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/example_scaffold.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/loading_button.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/response_card.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/utils.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NoWebhookPaymentCardFormScreen extends StatefulWidget {
  String email;
  double amount;
  NoWebhookPaymentCardFormScreen({Key key, this.email, this.amount});
  @override
  _NoWebhookPaymentCardFormScreenState createState() =>
      _NoWebhookPaymentCardFormScreenState();
}

class _NoWebhookPaymentCardFormScreenState
    extends State<NoWebhookPaymentCardFormScreen> {
  final controller = CardFormEditController();

  String firstname;
  String lastname;
  String email;
  String mobile_no;

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      // title: 'Card Form',
      // tags: ['No Webhook'],
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        CardFormField(
          controller: controller,
        ),
        LoadingButton(
          onPressed:
              controller.details.complete == true ? _handlePayPress : null,
          text: 'Pay',
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => controller.focus(),
                child: Text('Focus'),
              ),
              SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => controller.blur(),
                child: Text('Blur'),
              ),
              
            ],
          ),
        ),
        Divider(),
        SizedBox(height: 20),
        ResponseCard(
          response: controller.details.toJson().toPrettyString(),
        )
      ],
    );
  }


  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  profile_data() async {

    bool lp = true;
    String methodName = 'profile_data NoWebhookPaymentCardformScreen.dart';
    String token = await getStringValue('token');
    if(token.isEmpty){
      return;
    }
    Map data = {'token': token};
    p('-->106 profileData', data, methodName, lp);
    final response = await http.post(Uri.parse(FETCH_PROFILE),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    p('-->114 response.statusCode', response.statusCode, methodName, lp);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->117 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        firstname = resposne["firstname"];
        lastname = resposne["lastname"];
        email = resposne["email"];
        mobile_no = resposne["mobile_no"];

      } else {
        print("${resposne['msg']}");
      }
    }else{
      print("Not 200 state");
      showSnackBar("Server error");
    }
    p('-->128 firstname', lastname, methodName, lp);
    p('-->128 lastname', firstname, methodName, lp);
    p('-->128 email', email, methodName, lp);
    p('-->128 mobile_no', mobile_no, methodName, lp);
  }

  Future<void> _handlePayPress() async {
    if (!controller.details.complete) {
      return;
    }
    // get profile data from the server
    await profile_data();

    try {
      // 1. Gather customer billing information (ex. email)

      final billingDetails = BillingDetails(
        email: email,
        phone: mobile_no,
        name: firstname + lastname,
      ); // real data

      // 2. Create payment method
      final paymentMethod =
          await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
        billingDetails: billingDetails,
      ));

      // 3. call API to create PaymentIntent
      final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd', // real data
        items: [
          {'id': 'id'}
        ],
      );

      if (paymentIntentResult['error'] != null) {
        // Error during creating or confirming Intent
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        // Payment succedeed

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Success!: The payment was confirmed successfully!')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        // 4. if payment requires action calling handleCardAction
        final paymentIntent = await Stripe.instance
            .handleCardAction(paymentIntentResult['clientSecret']);

        // todo handle error
        /*if (cardActionError) {
        Alert.alert(
        `Error code: ${cardActionError.code}`,
        cardActionError.message
        );
      } else*/

        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          // 5. Call API to confirm intent
          await confirmIntent(paymentIntent.id);
        } else {
          // Payment succedeed
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: ${paymentIntentResult['error']}')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId);
    if (result['error'] != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Success!: The payment was confirmed successfully!')));
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    String paymentIntentId,
  }) async {
    final url = Uri.parse('$kApiUrl/charge-card-off-session');
    final response = await http.post(
      url,
      headers: {
        'authorization': 'Bearer $skTest',
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    bool useStripeSdk,
    String paymentMethodId,
    String currency,
    List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse('$kApiUrl/payment_intents');
    final response = await http.post(
      url,
      headers: {
        'authorization': 'Bearer $skTest',
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'amount':widget.amount,
        'items': items
      }),
    );
    return json.decode(response.body);
  }
}
