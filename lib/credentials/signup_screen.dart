import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/login_screen.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/ui/widgets/privacy_tos.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/get_image_header.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup_screen extends StatefulWidget {
  @override
  _SignupDemoState createState() => _SignupDemoState();
}

class _SignupDemoState extends State<Signup_screen> {
  bool isLoading = false;
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repasswordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  ProgressDialog dialog;

  double vertDiv = 10.0;

  var contHeight = 35.0;

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');

    double widthMax = MediaQuery.of(context).size.width;
    double heightMax = MediaQuery.of(context).size.height;
    double width = 900;
    double height = 650;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 5),
              child: Center(
                  child: Column(children: <Widget>[
                GetImageHeader(width: width, widthMax: widthMax),
              ])),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 7),
              child: Container(
                height: contHeight,
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                      hintText: 'Enter First Name'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              child: Container(
                height: contHeight,
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                      hintText: 'Enter Last Name'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: vertDiv, bottom: 0),
              child: Container(
                height: contHeight,
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
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: vertDiv, bottom: 0),
              child: Container(
                height: contHeight,
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                      hintText: 'Enter valid phone munber'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: vertDiv, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: contHeight,
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
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: vertDiv, bottom: vertDiv),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: contHeight,
                child: TextField(
                  controller: _repasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      hintText: 'Enter confirm password'),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  if (_passwordController.text == _repasswordController.text) {
                    signup(
                        _firstNameController.text,
                        _lastNameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _phoneController.text);
                  } else {
                    scaffoldMessenger.showSnackBar(SnackBar(
                        content: Text("Password mismatch.Please try again!")));
                  }
                },
                child: Text(
                  'SIGN-UP',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Login_screen()));
              },
              child: Text(
                'Have an account? Login',
                style: TextStyle(color: primaryColor, fontSize: 15),
              ),
            ),
            PrivacyTos()
          ],
        ),
      ),
    );
  }

  Future<bool> setStringValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  signup(first_name, last_name, email, password, phone_number) async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    await dialog.show();
    Map data = {
      'firstname': first_name,
      'lastname': last_name,
      'email': email,
      'password': password,
      'mobile_no': phone_number
    };
    print(data.toString());
    final response = await http.post(Uri.parse(REGISTRATION),
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
      if (resposne['status'] == "true") {
        await dialog.hide();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => Login_screen()));
        // make sure a new user is in
        setStringValue('album_title', '');
        setStringValue('token', '');
        setStringValue('email', email);
        // isLoggedInGlobal = false;
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text("Registered successful.Please login.")));
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => Login_screen()));
      } else {
        await dialog.hide();
        print("${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      }
    } else {
      await dialog.hide();
      print("Please try again!");
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Something went wrong.Please try again!")));
    }
    await dialog.hide();
  }
}
