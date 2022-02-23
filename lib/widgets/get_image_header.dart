import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
class GetImageHeader extends StatelessWidget {
  double width;
  double widthMax;
  GetImageHeader({Key key, this.width, this.widthMax}) : super(key: key);

  Widget getImageHeader() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 250,
      width: width / widthMax * 200,
      decoration: BoxDecoration(
        // color: Colors.red,
        shape: BoxShape.rectangle,
        image: DecorationImage(
            image: AssetImage(IMAGE_TRANSPARENT),
            fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getImageHeader() ;
  }
}


