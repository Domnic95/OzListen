import 'dart:convert';
import 'dart:developer';

import 'package:com.ozlisten.ozlistenapp/album/album.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/profile/modal/credit_history.dart';
import 'package:com.ozlisten.ozlistenapp/profile/modal/credit_modal.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreditProvider extends ChangeNotifier {
  List<CreditModal> credits;
  String stripeSecretKey;
  String stripeTokenString;
  String skTest;
  String user_credit;
  List<CreditHistory> credithistory;
  CreditProvider() {
    loadCredits();
    fetchUserCredit();
    loadCredithistory();
  }
  loadCredits() async {
    final res = await http.get(Uri.parse("$ROOT_API/getlistcredits"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data["credits"] != null) {
        credits = (data["credits"] as List)
            .map((e) => CreditModal.fromJson(e))
            .toList();
      } else {
        credits = [];
      }
    } else {
      credits = [];
    }
    notifyListeners();
  }

  Future fetchUserCredit() async {
    final token = (await SharedPreferences.getInstance()).getString("token");
    final res = await http.post(
      Uri.parse("$ROOT_API/getuserbalance"),
      body: {"token": token},
    );
    log(res.body);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data["balance"] != null) {
        user_credit = data["balance"].toString();
      }
    } else {
      log(res.body);
    }
    notifyListeners();
  }

  loadCredithistory() async {
    final token = (await SharedPreferences.getInstance()).getString("token");
    final res = await http.post(
      Uri.parse("$ROOT_API/fetchcredithistory"),
      body: {"token": token},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      log(data.toString());
      if (data["credits"] != null) {
        credithistory = (data["credits"] as List)
            .map((e) => CreditHistory.fromJson(e))
            .toList();
      } else {
        credithistory = [];
      }
    } else {
      credithistory = [];
      log(res.body);
    }
    notifyListeners();
  }

  Future<bool> buyFromCredit(Album album) async {
    final token = (await SharedPreferences.getInstance()).getString("token");
    final res = await http.post(
      Uri.parse("$ROOT_API/payfromwallet"),
      body: {"token": token, "album_id": album.id},
    );
    log(album.id);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      log(data.toString());
      await fetchUserCredit();
      if (data["status"].toString() == true.toString()) {
        log("a");
        await fetchUserCredit();
        return true;
      }
    } else {
      log(res.body);
    }
    notifyListeners();
  }

  Future<bool> buyCredit(String cardNummber, int expireMonth, int expireYear,
      int cvv, int ammount) async {
    await getStripeKeys();
    log(stripeSecretKey + "stripe key");
    if (stripeSecretKey != null) {
      await stripeToken(cardNummber, expireMonth, expireYear, cvv);
    }
    if (stripeTokenString != null) {
      final res = await payWithStripe(ammount);
      if (res == true) {
        fetchUserCredit();
        loadCredithistory();
        return true;
      }
    }
  }

  Future<bool> payWithStripe(int ammount) async {
    final sharedpref = await SharedPreferences.getInstance();

    final token = sharedpref.getString("token");
    final email = sharedpref.getString("email");
    final res = await http.post(
      Uri.parse("$ROOT_API/paywithstripe"),
      body: {
        "token": token,
        "email": email,
        "item_price": ammount.toString(),
        "stripeToken": stripeTokenString
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return true;
      // if (data["balance"] != null) {
      //   user_credit = data["balance"].toString();
      // }
    } else {
      log(res.body);
    }
    // notifyListeners();
  }

  Future getStripeKeys() async {
    bool lp = true;
    String methodName = 'payWithStripe CustomCardPaymentScreen';
    p('-->494  start', '----payWithStripe---', methodName, lp);
    String token =
        (await SharedPreferences.getInstance()).getString("token") ?? '';
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
        // showSnackBar("Server error 2");
      }
    } catch (e) {
      print('getStripeKeys error $e');
      print("Please try again!");
    }
  }

  Future<Map<String, dynamic>> stripeToken(
      String cardNummber, int expireMonth, int expireYear, int cvv) async {
    bool lp = true;
    String methodName = 'stripeToken CustomCardPaymentScreen';
    p('-->168 start', '-------', methodName, lp);
    final url = Uri.parse('$kApiUrl/tokens');
    p('-->410 url stripeToken', url, methodName, lp);
    Map data = {
      'card[number]': int.parse(cardNummber).toString(),
      'card[exp_month]': expireMonth.toString(),
      'card[exp_year]': expireYear.toString(),
      'card[cvc]': cvv.toString(),
    };
    print(data.toString() + "$skTest");
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
        // showSnackBar("Token success, continue to payment");
        // await payWithStripe();
      } else {
        print("${resposne['msg']}");
        // showSnackBar("Error in communication");
      }
    } else {
      print(response.body.toString());
      print("Not 200 state");
      // showSnackBar("Server error");
    }
    return json.decode(response.body);
  }

  getStringValue(String s) {}
}
