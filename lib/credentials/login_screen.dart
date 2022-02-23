import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/signup_screen.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/ui/widgets/privacy_tos.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/get_image_header.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_screen extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<Login_screen> {
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  ProgressDialog dialog;

  double textFieldHeight = 40.0;

  String tokenLocal = '';

  var fontSize = 18.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold() {
      double widthMax = MediaQuery.of(context).size.width;
      double heightMax = MediaQuery.of(context).size.height;
      double width = 900;
      double height = 650;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height + 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 2),
                    child: Center(
                        child: Column(children: <Widget>[
                      GetImageHeader(width: width, widthMax: widthMax),
                    ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 0, bottom: 0),
                    child: Container(
                      height: textFieldHeight,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: textFieldHeight,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter password'),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty) {
                        _showDialogForLogout('PROBLEM!');
                      } else {
                        await forgotPassword(_emailController.text);
                      }
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: primaryColor, fontSize: 15),
                    ),
                  ),
                  Container(
                    height: textFieldHeight,
                    width: 250,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        login(_emailController.text, _passwordController.text);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: textFieldHeight / 2,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Signup_screen()));
                    },
                    child: Text(
                      'New User? Create Account',
                      style: TextStyle(color: primaryColor, fontSize: 15),
                    ),
                  ),
                  PrivacyTos(),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // return false
    bool lp = true;
    String methodName = 'build Login_screen';
    p('-->169 isLoggedInGlobal', isLoggedInGlobal, methodName, lp);
    return isLoggedInGlobal
        ? TabContainerBottom(selectedIndex: MAIN_FREE)
        : scaffold();
  }

  login(email, password) async {
    bool lp = true;
    String methodName = 'login Login_screen';
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    Map data = {'email': email, 'password': password};
    print('--> 153 login login_screen.dart ' + data.toString());
    final response = await http.post(Uri.parse(LOGIN),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->222 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        String token = resposne["token"];
        String username = resposne["username"];
        String email = resposne["email"];
        String profile_image = resposne["image"];

        setStringValue('username', username);
        setStringValue('email', email);
        setStringValue('profile_image', profile_image);
        print('--> 178 login login_screen.dart ' + token);
        setStringValue('token', token);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TabContainerBottom(
                      selectedIndex: MAIN_FREE,
                    )));
      } else {
        print("${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      }
    } else {
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
  }

  Future<bool> setStringValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  void _showDialogForLogout(String text) {
    print("-->255 _showDialogForLogout LoginScreen");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFa7b7bf),
          title: Column(
            children: [
              Row(children: <Widget>[
                Text(
                  'Email field is empty',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Helvetica Regular',
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const Expanded(child: Text('')),
              ]),
            ],
          ),
          content: Text(
            'Please fill it in',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Helvetica Regular',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Helvetica Regular',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    // await dialog.show();
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    Map data = {'email': email};
    print('--> 320 login login_screen.dart ' + data.toString());
    final response = await http.post(Uri.parse(FORGOT_PASSWORD),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    setState(() {
      isLoading = false;
    });
    bool lp = true;
    String methodName = '';
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->265 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        print("--> 339 response msg = ${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      } else {
        // await dialog.hide();
        print("${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      }
    } else {
      // await dialog.hide();
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
    // await dialog.hide();
  }
}
