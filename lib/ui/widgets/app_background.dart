import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Color color;
  final Widget child;

  static const _defaultColor = Colors.lightBlueAccent;

  const AppBackground({
    Key key,
    this.color = _defaultColor,
    this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: color,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
         /* Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 225.0,
            child: FittedBox(
              fit: BoxFit.fill,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/App.svg',
                key: Key('key_App_background'),
                colorBlendMode: BlendMode.multiply,
                color: color,
              ),
            ),
          ),*/
          Container(
            width: size.width,
            height: size.height,
            color: color.withOpacity(1.0),
            child: Image.asset(
            'assets/logos/logo_splash.png',
            fit: BoxFit.fill,
          ),
          ),
          child,
        ],
      ),
    );
  }
}
