import 'package:flutter/material.dart';
class NothingToShow extends StatelessWidget {
  String text;
  NothingToShow({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text,
          style: TextStyle(fontSize: 21, color: Colors.black)),
    );
  }
}
