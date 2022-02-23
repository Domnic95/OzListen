
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(PaymentScreen());
}

// payment_screen.dart
class PaymentScreen extends StatelessWidget {
  Map<String, String> _paymentSheetData = {
    'customer': '',
    'paymentIntent': '',
    'ephemeralKey':''
  };

  Future<void> checkout() async {
    /// retrieve data from the backend
    // final paymentSheetData = backend.fetchPaymentSheetData();

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      applePay: true,
      googlePay: true,
      style: ThemeMode.dark,
      testEnv: true,
      merchantCountryCode: 'USA',
      merchantDisplayName: 'OZListen',
      customerId: _paymentSheetData['customer'],
      paymentIntentClientSecret: _paymentSheetData['paymentIntent'],
      customerEphemeralKeySecret: _paymentSheetData['ephemeralKey'],
    ));

    await Stripe.instance.presentPaymentSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,
      title:Text('Stripe demo', style:TextStyle(color: Colors.white),)),
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: checkout,
                child: const Text('Checkout', style:TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

