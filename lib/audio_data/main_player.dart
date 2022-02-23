import 'package:com.ozlisten.ozlistenapp/controls/player_buttons_container.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:flutter/material.dart';

class PlayerMain extends StatefulWidget {
  @override
  _PlayerMainState createState() => _PlayerMainState();
}

class _PlayerMainState extends State<PlayerMain> {
  // String audio_name,audio_des,audio_url,audio_image;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text("Now playing"),
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false),
      body: Container(
        height: height,
        child: PlayerButtonsContainer(),
      ),
    );
  }
}
