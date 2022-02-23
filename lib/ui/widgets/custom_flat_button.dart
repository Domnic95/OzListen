import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double width, height;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  const CustomFlatButton({
    Key key,
    this.text,
    this.textStyle = const TextStyle(fontSize: 18),
    this.width = 200,
    this.height = 50,
    this.padding = const EdgeInsets.fromLTRB(10, 50, 170, 20),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(textStyle);
    return Container(
      width: width ?? null,
      height: height ?? null,
      padding: padding ?? null,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: InkWell(
            onTap: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: textStyle?.color ?? Colors.white,
                fontSize: textStyle?.fontSize ?? 16.0,
                height: textStyle?.height ?? 20.0 / 16.0,
                fontStyle: textStyle?.fontStyle ?? FontStyle.normal,
                fontWeight: textStyle?.fontWeight ?? FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
