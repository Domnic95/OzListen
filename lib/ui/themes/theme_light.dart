import 'package:flutter/material.dart';

import 'theme_colors.dart';

// This is the (default) theme of application.
ThemeData themeLight = ThemeData(
  scaffoldBackgroundColor: ThemeColors.scaffoldBackgroundColor,
  fontFamily: ThemeColors.fontFamily,

  appBarTheme: AppBarTheme(
    color: ThemeColors.appBarThemeColor,
    centerTitle: true,
    elevation: ThemeColors.appBarThemeElevation,
    iconTheme: IconThemeData(
      color: ThemeColors.appBarBackIconThemeColor,
      size: ThemeColors.appBarBackIconThemeSize,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: ThemeColors.appBarTextThemeBodyText1Color,
        fontSize: ThemeColors.appBarTextThemeBodyText1FontSize,
        height: ThemeColors.appBarTextThemeBodyText1Height,
        fontWeight: ThemeColors.appBarTextThemeBodyText1FontWeight,
        fontStyle: ThemeColors.appBarTextThemeBodyText1FontStyle,
      ),
      headline6: TextStyle(
        color: ThemeColors.appBarTextThemeHeadline6Color,
        fontSize: ThemeColors.appBarTextThemeHeadline6FontSize,
        height: ThemeColors.appBarTextThemeHeadline6Height,
        fontWeight: ThemeColors.appBarTextThemeHeadline6FontWeight,
        fontStyle: ThemeColors.appBarTextThemeHeadline6FontStyle,
      ),
    ),
    actionsIconTheme: IconThemeData(
      color: ThemeColors.appBarActionsIconThemeColor,
      size: ThemeColors.appBarActionsIconThemeSize,
    ),
  ),

  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: ThemeColors.appBodyTextThemeBodyText1Color,
      fontSize: ThemeColors.appBodyTextThemeBodyText1FontSize,
      height: ThemeColors.appBodyTextThemeBodyText1Height,
      fontWeight: ThemeColors.appBodyTextThemeBodyText1FontWeight,
      fontStyle: ThemeColors.appBodyTextThemeBodyText1FontStyle,
    ),
    bodyText2: TextStyle(
      color: ThemeColors.appBodyTextThemeBodyText2Color,
      fontSize: ThemeColors.appBodyTextThemeBodyText2FontSize,
      height: ThemeColors.appBodyTextThemeBodyText2Height,
      fontWeight: ThemeColors.appBodyTextThemeBodyText2FontWeight,
      fontStyle: ThemeColors.appBodyTextThemeBodyText2FontStyle,
    ),
  ),

  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
