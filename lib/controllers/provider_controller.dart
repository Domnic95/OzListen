
import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/just_audio_player.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/splash_screen.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ProviderController extends StatefulWidget {
  const ProviderController({Key key}) : super(key: key);

  @override
  _ProviderControllerState createState() => _ProviderControllerState();
}

class _ProviderControllerState extends State<ProviderController> {
  Future _future;

  Future<Map> _get() async {
  }

  @override
  void initState() {
    super.initState();

    _future = _get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            // Uncompleted State
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
              break;
            default:
              // Completed with error
            bool lp = true;
            String methodName = 'build ProviderController';
              if (snapshot.hasError) {
                p('-->56 snapshot.hasError', snapshot.hasError, methodName, lp);
              }
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
                    // child: AppView()),
              ),
            ));
          }
        });
  }
}
