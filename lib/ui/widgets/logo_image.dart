import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';

class LogoImage extends StatelessWidget {
  final double width;

  const LogoImage({Key key, this.width}) : super(key: key);

  Widget showImage(BuildContext context, String imageName) {
    double width2 = MediaQuery.of(context).size.width ;
    return Container(
      margin: const EdgeInsets.all(0.0),
      height: 300,
      width: width2,
      child: Center(),
      decoration: BoxDecoration(
        color: const Color(0xfffffff),
        image: DecorationImage(
          image: AssetImage(imageName),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('->29  buildContext logo_image');

    String imagename = IMAGE_TRANSPARENT;
    return showImage(context, imagename);
  }
}
