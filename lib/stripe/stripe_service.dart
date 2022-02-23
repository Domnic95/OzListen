import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

const STRIPEKEY =
    "pk_test_51Is2ovSEgPBacCbZl6DOM5CXl6NOL4o0liVOvczw84sIQm0uca6lXBsP9D74mq1Y20Qwf89uTV392trU4Bt5Ygpb00JjUeCJv2";

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  StripeService();
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${STRIPEKEY}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    Stripe.publishableKey = STRIPEKEY;
    Stripe.merchantIdentifier = "Test";
  }

  static makePayment(CardDetails cardDetails) async {
    await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);
    // try {
    final billingDetails = BillingDetails(
      email: 'email@stripe.com',
      phone: '+48888000888',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    );
    final paymentMethod =
        await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
      billingDetails: billingDetails,
    ));

    final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
      useStripeSdk: true,
      paymentMethodId: paymentMethod.id,
      currency: 'usd', // mocked data
      items: [
        {'id': 'id'}
      ],
    );
    if (paymentIntentResult['error'] != null) {
      // Error during creating or confirming Intent
      print("error......" + paymentIntentResult['error'].toString());
      return;
    }
    if (paymentIntentResult['clientSecret'] != null &&
        paymentIntentResult['requiresAction'] == null) {
      // Payment succedeed

      print('Success!: The payment was confirmed successfully!');
      return;
    }
    // } catch (e) {
    //   print("error......" + e.toString());
    // }
  }

  static Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    bool useStripeSdk,
    String paymentMethodId,
    String currency,
    List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse('https://api.stripe.com/pay-without-webhooks');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${STRIPEKEY}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items
      }),
    );
    return json.decode(response.body);
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency, CardDetails card}) async {
    try {
      await Stripe.instance.dangerouslyUpdateCardDetails(card);
      var paymentMethod = await Stripe.instance.createPaymentMethod(
        PaymentMethodParams.card(
          setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
          billingDetails: BillingDetails(),
        ),
      );
      // callNoWebhookPayEndpointMethodId()
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await Stripe.instance.confirmPayment(
        paymentIntent['client_secret'],
        PaymentMethodParams.card(
          setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
          billingDetails: BillingDetails(),
        ),
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl),
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
