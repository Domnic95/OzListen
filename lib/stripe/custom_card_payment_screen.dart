import 'dart:convert';
import 'dart:developer';

import 'package:com.ozlisten.ozlistenapp/album/album.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/loading_button.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/stripe_service.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomCardPaymentScreen extends StatefulWidget {
  String amount;
  Album album;

  CustomCardPaymentScreen({Key key, this.amount, this.album});

  @override
  _CustomCardPaymentScreenState createState() =>
      _CustomCardPaymentScreenState();
}

class _CustomCardPaymentScreenState extends State<CustomCardPaymentScreen> {
  CardDetails _card = CardDetails();
  bool _saveCard = false;

  TextEditingController _cardController = new TextEditingController();
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _emailAddressController = new TextEditingController();
  TextEditingController _monthController = new TextEditingController();
  TextEditingController _yearController = new TextEditingController();
  TextEditingController _cvcController = new TextEditingController();
  PaymentMethod paymentMethod;

  String stripeTokenString;

  Object email;

  var hintStyle = TextStyle(fontSize: 13);
  var textStyle = TextStyle(fontSize: 16);
  final _form = GlobalKey<FormState>();

  double fieldWidth = 80;

  double contHeight = 60;

  double edge2 = 6.0;

  bool firstTime = true;

  String stripeSecretKey;

  double fontSize = 15.0;

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  Container eraseKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    bool lp = true;
    String methodName = 'build CustomCardPaymentScreen';
    if (firstTime) {
      firstTime = false;
      eraseKeyboard();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Payment through Stripe', style: TextStyle(fontSize: 15)),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: <Widget>[
                buildAlbum(),
                buildAuthor(),
                buildPleaseEnter(context),
                Form(
                  key: _form,
                  child: Column(children: <Widget>[
                    buildUserNameRow(),
                    buildEmailAddressRow(),
                    buildCreditCartRow(),
                    Container(
                      // decoration: buildBoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildMonthRow(),
                          buildYearRow(),
                          buildCVCRow(),
                        ],
                      ),
                    ),
                  ]),
                )
              ]),
            ),
            LoadingButton(
              onPressed: () {
                final card = CardDetails(
                  number: "4242424242424242",
                  cvc: '954',
                  expirationMonth: 6,
                  expirationYear: 25,
                );
                // StripeService.makePayment(card);
                // StripeService.payWithNewCard(
                //     amount: "10", currency: "INR", card: card);
                if (_form.currentState.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  bool b1 = _cardController.text.isEmpty;
                  bool b6 = _fullNameController.text.isEmpty;
                  bool b7 = _emailAddressController.text.isEmpty;
                  bool b2 = _monthController.text.isEmpty;
                  bool b3 = _yearController.text.isEmpty;
                  bool b4 = _cvcController.text.isEmpty;
                  bool b5 = b1 || b2 || b3 || b4 || b6 || b7;
                  if (b5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No field may be empty')));
                  } else {
                    bool c1 = _cardController.text.length != 16;
                    bool c2 = _monthController.text.length > 2;
                    bool c3 = _yearController.text.length > 2;
                    bool c4 = _cvcController.text.length != 3;
                    bool c5 = c1 && c2 && c3 && c4;
                    if (c5) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Wrong length of input data')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing')));
                      p('-->135 before firstTime', '------', methodName, lp);
                      _handlePayPress();
                    }
                  }
                }
                return;
              },
              text: 'Pay \$' + widget.amount,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCVCRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        decoration: buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*
            Text('CVC', style:textStyle),*/
            Container(
              height: contHeight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: fieldWidth,
              child: TextFormField(
                controller: _cvcController,
                validator: (text) {
                  int basicCVC;
                  try {
                    basicCVC = int.parse(text);
                  } catch (e) {
                    print('__CVC__ not number' + e.toString());
                    return 'Empty';
                  }
                  if ((text.length > 3) && text.isNotEmpty) {
                    return "Three digits only";
                  }

                  if ((text.length != 3) && text.isNotEmpty) {
                    return "Three digits only";
                  }
                  return null;
                },
                decoration:
                    InputDecoration(hintText: 'CVC', hintStyle: hintStyle),
                onChanged: (number) {
                  setState(() {
                    _card = _card.copyWith(cvc: number);
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildYearRow() {
    return Padding(
      padding: EdgeInsets.all(edge2),
      child: Container(
        height: 50,
        decoration: buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /* Icon(
            Icons.date_range_outlined,
            size: 34,
          ),*/
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: fieldWidth,
              child: TextFormField(
                controller: _yearController,
                validator: (text) {
                  int basicYear;
                  try {
                    basicYear = int.parse(text);
                  } catch (e) {
                    print('__YEAR__ not number' + e.toString());
                    return 'Empty';
                  }
                  if ((text.length > 2) && text.isNotEmpty) {
                    return "Two digits only";
                  }
                  bool lp = true;
                  String methodName = 'buildYearRow';
                  int yearInt = basicYear + 2000;
                  p('-->208 yearInt', yearInt, methodName, lp);
                  DateTime dt = DateTime.now();
                  p('-->212 dt.year', dt.year, methodName, lp);
                  if ((yearInt < dt.year) && text.isNotEmpty) {
                    return "Wrong year";
                  }
                  return null;
                },
                decoration:
                    InputDecoration(hintText: 'YY', hintStyle: hintStyle),
                onChanged: (number) {
                  setState(() {
                    _card =
                        _card.copyWith(expirationYear: int.tryParse(number));
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMonthRow() {
    return Padding(
      padding: EdgeInsets.all(edge2),
      child: Container(
        height: 50,
        decoration: buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Text('Month', style:textStyle),
            /* Icon(
              Icons.date_range_outlined,
              size: 34,
            ),*/
            // Text('Month', style:textStyle),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: fieldWidth,
              child: TextFormField(
                controller: _monthController,
                validator: (text) {
                  int basicMonth;
                  try {
                    basicMonth = int.parse(text);
                  } catch (e) {
                    print('__MONTH__ not number' + e.toString());
                    return 'Empty';
                  }
                  if ((text.length > 2) && text.isNotEmpty) {
                    return "Two digits only";
                  }
                  if (text.isNotEmpty) {
                    int month = basicMonth;
                    bool b1 = month > 0;
                    bool b2 = month <= 12;
                    bool b3 = b1 && b2;
                    if (!b3 && text.isNotEmpty) {
                      return "Invalid interval";
                    }
                  } else {
                    return "Empty field";
                  }
                  return null;
                },
                decoration:
                    InputDecoration(hintText: 'MM', hintStyle: hintStyle),
                onChanged: (number) {
                  setState(() {
                    _card =
                        _card.copyWith(expirationMonth: int.tryParse(number));
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCreditCartRow() {
    return Padding(
      padding: EdgeInsets.all(edge2),
      child: Container(
        height: 50,
        // color: Colors.red,
        decoration: buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.credit_card_outlined,
              size: 34,
            ),
            // Text('Credit Card \nNumber', style:textStyle),
            Expanded(
              child: Container(
                width: 180,
                // color: Colors.green,
                child: TextFormField(
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Empty';
                    }
                    if ((text.length != 16) && text.isNotEmpty) {
                      return "Sixteen digits exactly";
                    }
                    return null;
                  },
                  controller: _cardController,
                  decoration: InputDecoration(
                      hintText: 'Credit Card Number', hintStyle: hintStyle),
                  onChanged: (number) {
                    setState(() {
                      _card = _card.copyWith(number: number);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserNameRow() {
    return Padding(
      padding: EdgeInsets.all(edge2),
      child: Container(
        // height: 50,
        // color: Colors.red,
        decoration: buildBoxDecoration(),
        /**/ child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Text('Full Name \n(on the card)', style:textStyle),
            Icon(
              Icons.person_outlined,
              size: 34,
            ),
            // Text('Full Name \n(on the card)', style:textStyle),
            Expanded(
              child: Container(
                width: fieldWidth,
                // color: Colors.green,
                child: TextFormField(
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Empty';
                    }
                    final _regex = RegExp(
                      r'^[a-zA-Z0-9 .!#$%&’*+/=?^_`{|}~-]{2,36}$',
                    );

                    if ((_regex.hasMatch(text) != true) && text.isNotEmpty) {
                      return "Incorrect user name";
                    }
                    return null;
                  },
                  controller: _fullNameController,
                  decoration: InputDecoration(
                      hintText: 'Full Name (as on a card)',
                      hintStyle: hintStyle),
                  onChanged: (number) {
                    setState(() {
                      _card = _card.copyWith(number: number);
                    });
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget buildEmailAddressRow() {
    return Padding(
      padding: EdgeInsets.all(edge2),
      child: Container(
        height: 50,
        // color: Colors.red,
        decoration: buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Text('Email \nAddress      ', style:textStyle),
            Icon(
              Icons.email,
              size: 34,
            ),
            Expanded(
              child: Container(
                width: 180,
                // color: Colors.green,
                child: TextFormField(
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Empty';
                    }
                    final _regex = RegExp(
                      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
                    );

                    if ((_regex.hasMatch(text) != true) && text.isNotEmpty) {
                      return "Incorrect email address";
                    }
                    return null;
                  },
                  controller: _emailAddressController,
                  decoration: InputDecoration(
                      hintText: 'Email Address', hintStyle: hintStyle),
                  onChanged: (number) {
                    setState(() {
                      _card = _card.copyWith(number: number);
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildPleaseEnter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
          // color: Colors.red,
          width: MediaQuery.of(context).size.width * 0.8,
          // decoration: buildBoxDecoration(),
          child: Center(
            child: Text(
              'Please enter your \ncredit card details',
              maxLines: 2,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    );
  }

  Padding buildAuthor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Container(
          // color: Colors.red,
          // decoration: buildBoxDecoration(),
          child: Text(
        'Author: ${widget.album.author}',
        maxLines: 2,
        softWrap: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      )),
    );
  }

  Padding buildAlbum() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        // decoration: buildBoxDecoration(),
        child: Text(
          'Album: ${widget.album.title}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 21.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayPress() async {
    bool lp = true;
    String methodName = '_handlePayPress CustomCardPaymentScreen';

    try {
      p('-->127 before stripeToken', '-------', methodName, lp);
      eraseKeyboard();
      await getStripeKeys();
      if (skTest.isNotEmpty) {
        p('-->570 skTest not empty', skTest, methodName, lp);
        // token present, continue with payment
        await stripeToken();
      } else {
        // token not present
        p('-->575 skTest emapty', skTest, methodName, lp);

        showSnackBar("Server error 4");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  getStripeKeys() async {
    bool lp = true;
    String methodName = 'payWithStripe CustomCardPaymentScreen';
    p('-->494  start', '----payWithStripe---', methodName, lp);
    String token = await getStringValue('token') ?? '';
    String finalUrl = STRIPE_KEYS;
    p('-->503 finalUrl getStripeKeys', finalUrl, methodName, lp);
    final url = Uri.parse(finalUrl);
    Map data = {
      'token': token,
      'password': 'agdASD234a3433DS',
    };
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
      );

      p('-->514 response.statusCode', response.statusCode, methodName, lp);
      String resp = response.body.toString();
      p('-->517 response', response, methodName, lp);

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        stripeSecretKey = resposne['stripe_secret_key'] ?? '';
        p('-->422 stripeTokenString', stripeSecretKey, methodName, lp);
        printWrapped('-->608 resp in getStripeKeys = $resp');
        bool skPresent = stripeSecretKey.contains("sk_");
        p('-->604 skPresent', skPresent, methodName, lp);
        if (skPresent) {
          printWrapped('-->237 $resp');
          skTest = stripeSecretKey;
          p('-->610 skTest', skTest, methodName, lp);
          print("==>614 status TRUE");
        } else {
          print("Empty key");
        }
      } else {
        print("Not 200 state");
        showSnackBar("Server error 2");
      }
    } catch (e) {
      print('getStripeKeys error $e');
      print("Please try again!");
    }
  }

  Future<Map<String, dynamic>> stripeToken() async {
    bool lp = true;
    String methodName = 'stripeToken CustomCardPaymentScreen';
    p('-->168 start', '-------', methodName, lp);
    final url = Uri.parse('$kApiUrl/tokens');
    p('-->410 url stripeToken', url, methodName, lp);
    Map data = {
      'card[number]': _cardController.text,
      'card[exp_month]': _monthController.text,
      'card[exp_year]': _yearController.text,
      'card[cvc]': _cvcController.text,
    };
    print(data.toString());
    final response = await http.post(
      url,
      headers: {
        'authorization': 'Bearer $skTest',
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      String resp = response.body.toString();
      p('-->239786 resposne', resposne, methodName, lp);

      stripeTokenString = resposne['id'] ?? '';
      p('-->422 stripeTokenString', stripeTokenString, methodName, lp);
      printWrapped('-->299 resp in stripeToken = $resp');
      // p('-->268 resp', resp, methodName, lp);

      if (stripeTokenString.contains("tok")) {
        printWrapped('-->237 $resp');
        print("-->431status TRUE stripeToken");
        showSnackBar("Token success, continue to payment");
        await payWithStripe();
      } else {
        print("${resposne['msg']}");
        showSnackBar("Error in communication");
      }
    } else {
      print(response.body.toString());
      print("Not 200 state");
      showSnackBar("Server error");
    }
    return json.decode(response.body);
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  emailFromProfileData() async {
    bool lp = true;
    String methodName = 'emailFromProfileData CustomCardPaymentScreen.dart';
    String token = await getStringValue('token');
    if (token.isEmpty) {
      return;
    }
    Map data = {'token': token};
    // p('-->190 profileData', data, methodName, lp);
    final response = await http.post(Uri.parse(FETCH_PROFILE),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    p('-->484 response.statusCode', response.statusCode, methodName, lp);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->487 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        p('-->489 emailFromProfileData status true', '-----', methodName, lp);
        email = resposne["email"];
      } else {
        print("${resposne['msg']}");
      }
    } else {
      print("Not 200 state");
      showSnackBar("Server error email");
    }
    p('-->128 email', email, methodName, lp);
  }

  void _showDialogForLogout(String text) {
    print("KKIHGTOOIJYTJU _showDialogForLogout");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFa7b7bf),
          title: Column(
            children: [
              Row(children: <Widget>[
                const Expanded(child: Text('')),
                IconButton(
                  iconSize: 25.0,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TabContainerBottom(
                                selectedIndex: LOAD_AUDIO,
                              ))),
                ),
              ]),
            ],
          ),
          content: Text(
            'You have successfully paid \$${widget.amount}for the album!',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Helvetica Regular',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Helvetica Regular',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    setAlbum();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabContainerBottom(
                                  selectedIndex: LOAD_AUDIO,
                                )));
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  payWithStripe() async {
    bool lp = true;
    String methodName = 'payWithStripe CustomCardPaymentScreen';
    p('-->494  start', '----payWithStripe---', methodName, lp);
    String token = await getStringValue('token') ?? '';
    await emailFromProfileData();
    String name = Uri.encodeComponent(_fullNameController.text);

    p('-->592 name payWithStripe', name, methodName, lp);
    String finalUrl = STRIPE;
    p('-->503 finalUrl payWithStripe', finalUrl, methodName, lp);
    final url = Uri.parse(finalUrl);
    Map data = {
      'token': token,
      'name': name,
      'email': _emailAddressController.text,
      'item_price': (double.parse(widget.amount) * 100).toInt().toString(),
      'stripeToken': stripeTokenString,
      'album_id': widget.album.id,
      // 'currency': "USD"
    };
    log(data.toString());

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
      );

      p('-->514 response.statusCode', response.statusCode, methodName, lp);
      String resp = response.body.toString();
      p('-->517 response', response, methodName, lp);
      print(resp.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        String message = resposne['msg'];
        if (resposne['status'] == "true") {
          printWrapped('-->237 $resp');
          print("==>521 status TRUE Paid");
          _showDialogForLogout('Log out?');
        } else {
          print("not successful in payment");
          showSnackBar(message);
        }
      } else {
        print("Not 200 state");
        showSnackBar("Server error pay");
      }
    } catch (e) {
      print('__payWithStripe__ error $e');

      print("Please try again!");
      showSnackBar("You are using the same token more than once");
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  Future<bool> setStringValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  Future<void> setAlbum() async {
    await setStringValue('album_title', widget.album.title);
  }
}
