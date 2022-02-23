import 'dart:io';

import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/just_audio_player.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/login_screen.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/splash_screen.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/utils/singleton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Singleton singleton = Singleton();

SharedPreferences sharedPreferences;
bool isLoggedInGlobal = false;

// Charlie's data
String skTest = '';

Future<bool> isLoggedIn() async {
  bool lp = true;
  String methodName = 'isLoggedIn authenticationapiprovider';
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String userGuid = preferences.getString('token') ?? '';
  isLoggedInGlobal = userGuid.isNotEmpty;
  p('-->112 isLoggedInGlobal = ', isLoggedInGlobal, methodName, lp);
  return isLoggedInGlobal;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyOverrides();
  bool lp = true;
  String methodName = 'main';
  isLoggedInGlobal = await isLoggedIn();
  p('-->30 isLoggedInGlobal', isLoggedInGlobal, methodName, lp);
  runApp(MyAppStart());
}

class MyAppStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioPlayerService>(
          create: (_) => JustAudioPlayer(),
          dispose: (_, value) {
            (value as JustAudioPlayer).dispose();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Provider(
            create: (BuildContext context) {},
            // child: true
            child: isLoggedInGlobal ? SplashScreen() : Login_screen()),
        // : TabContainerBottom(selectedIndex: MAIN_FREE)),
      ),
    );
  }
}

class MyOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
