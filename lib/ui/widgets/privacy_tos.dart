import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/ui/screens/html_files/view/privacy.dart';
import 'package:com.ozlisten.ozlistenapp/ui/screens/html_files/view/tos.dart';

class PrivacyTos extends StatelessWidget {
  const PrivacyTos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 34,
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TosPage()));
            },
            child: Text(
              'Terms of Service',
              style: TextStyle(color: primaryColor, fontSize: 15),
            ),
          ),
        ),
        Container(
          height: 34,
          child: FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PrivacyHtmlPage()));
            },
            child: Text(
              'Privacy Policy',
              style: TextStyle(color: primaryColor, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
