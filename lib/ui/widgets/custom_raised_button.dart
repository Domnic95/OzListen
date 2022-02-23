import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color color;
  final double width, height;
  final VoidCallback onPressed;

  const CustomRaisedButton({
    Key key,
    this.text,

    this.textStyle = const TextStyle(fontSize: 18),
    this.width = 280,
    this.height = 50,
    this.color = Colors.transparent,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 44.0,
      child: RaisedButton(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        color: color ?? Colors.white,
        disabledColor: color?.withOpacity(0.7) ?? Colors.white.withOpacity(0.7),
        onPressed: onPressed ?? null,
        child: Text(
          text,
          style: TextStyle(
            color: textStyle?.color ?? Color(0xFF2684FF),
            fontSize: textStyle?.fontSize ?? 16.0,
            height: textStyle?.height ?? 20.0 / 16.0,
            fontStyle: textStyle?.fontStyle ?? FontStyle.normal,
            fontWeight: textStyle?.fontWeight ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
