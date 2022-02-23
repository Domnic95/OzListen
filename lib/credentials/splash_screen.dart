import 'dart:async';

import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/login_screen.dart';
import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner:false,
    home: SplashScreen()));

class SplashScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => SplashScreen(),
    );
  }

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String tokenSet;
  Future _future;

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tokenSet = sharedPreferences.getString('token');
    bool lp = true;
    String methodName = 'getToken SplashScreen';
    p('-->27 tokenSet', tokenSet, methodName, lp);
    // isLoggedInGlobal = true;
    // isLoggedInGlobal = tokenSet.isNotEmpty;
    // sharedPreferences.setString('token', tokenSet);
  }

  @override
  void initState() {
    super.initState();
    _future = getToken();
    bool tokenBlanc = true;
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => tokenBlanc
                    ? Login_screen()
                    : TabContainerBottom(
                        selectedIndex: MAIN_FREE,
                      ))));
  }

  @override
  Widget build(BuildContext context) {
    double widthMax = MediaQuery.of(context).size.width;
    double heightMax = MediaQuery.of(context).size.height;
    double width = 900;
    double height = 650;
    return Scaffold(
      body: FutureBuilder<String>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          //
          if (snapshot.hasData) {
            return Center(
                child: Container(
              height: height / heightMax * 400,
              width: width / widthMax * 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: AssetImage(IMAGE_TRANSPARENT),
                    // image: AssetImage('images/img.png',),
                    fit: BoxFit.fitWidth),
              ),
            ));
          } else
            return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
