import 'dart:convert';

import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/config.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/example_scaffold.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/loading_button.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/response_card.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/utils.dart';


class WebhookPaymentScreen extends StatefulWidget {
  double amount;
  String email;
  WebhookPaymentScreen({Key key, this.email, this.amount});

  @override
  _WebhookPaymentScreenState createState() => _WebhookPaymentScreenState();
}

class _WebhookPaymentScreenState extends State<WebhookPaymentScreen> {
  CardFieldInputDetails _card;
  String _email;
  bool _saveCard = false;


  @override
  initState(){
    super.initState();
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Card Field',
      // tags: ['With Webhook'],
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
      /*  TextFormField(
          initialValue: _email,
          decoration: InputDecoration(hintText: 'Email', labelText: 'Email'),
          onChanged: (value) {
            setState(() {
              _email = value;
            });
          },
        ),
        SizedBox(height: 20),*/
        CardField(
          onCardChanged: (card) {
            setState(() {
              _card = card;
            });
          },
        ),
        /*SizedBox(height: 20),
        CheckboxListTile(
          value: _saveCard,
          onChanged: (value) {
            setState(() {
              _saveCard = value;
            });
          },
          title: Text('Save card during payment'),
        ),*/
        LoadingButton(
          onPressed: _handlePayPress,
          text: 'Pay',
        ),
        SizedBox(height: 20),
        if (_card != null)
          ResponseCard(
            response: _card.toJson().toPrettyString(),
          ),
      ],
    );
  }

  Future<void> _handlePayPress() async {
    bool lp = true;
    String methodName = '_handlePayPress WebhookPaymentScreen';
    p('-->85 start', '------------', methodName, lp);
    if (_card == null) {
      return;
    }

    p('-->92 before 1. fetchPaymentIntentClientSecret', '------------', methodName, lp);
    // 1. fetch Intent Client Secret from backend
    final clientSecret = await fetchPaymentIntentClientSecret();

    p('-->92 before 2. BillingDetails', '------------', methodName, lp);
    // 2. Gather customer billing information (ex. email)
    final billingDetails = BillingDetails(
      email: widget.email,
      // phone: '+48888000888',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    ); // mocked data for tests

    p('-->92 before 3. PaymentMethodParams', '------------', methodName, lp);
    // 3. Confirm payment with card details
    // The rest will be done automatically using webhooks
    // ignore: unused_local_variable
    final paymentIntent = await Stripe.instance.confirmPayment(
      clientSecret['clientSecret'],
      PaymentMethodParams.card(
        billingDetails: billingDetails,
        setupFutureUsage:
            _saveCard == true ? PaymentIntentsFutureUsage.OffSession : null,
      ),
    );
    p('-->120 paymentIntent.status', paymentIntent.status.toString(), methodName, lp);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Success!: The payment was confirmed successfully!')));
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    bool lp = true;
    String methodName = 'fetchPaymentIntentClientSecret WebhookPaymentScreen';
    final url = Uri.parse('$kApiUrl/payment_intents');

    Map data = {
      'amount': '2000',
      'currency':'eur',
      'payment_method_types[]': 'card'};
    final response = await http.post(
      url,
      headers: {
        'authorization': 'Bearer $skTest',
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
    );
    String resp = json.decode(response.body).toString();
    printWrapped(resp);
    p('-->148 resp', resp, methodName, lp);
    return json.decode(response.body);
  }


}
