library my_prj.globals;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


enum BiographyValidationError { empty, invalidFormat}

enum PhotoValidationError { empty, invalidFormat}

enum CompanyOrCollegeValidationError { empty, invalidFormat}

enum CompanyOrCollegeLocationValidationError { empty, invalidFormat}

enum DateValidationError { empty, invalidFormat}

enum EmailValidationError { empty, invalidFormat }

enum DisplayNameValidationError { empty, invalidFormat }

enum NameValidationError { empty, invalidFormat}

enum NewPasswordValidationError { empty, invalidFormat }

enum NewPasswordConfirmedValidationError { empty, invalidFormat, mismatch}

enum PasswordValidationError { empty, invalidFormat }

enum TitleValidationError { empty, invalidFormat}

enum UsernameValidationError { empty, invalidFormat }

enum WebsiteValidationError { empty, invalidFormat}

enum PasswordConfirmedValidationError { empty, invalidFormat, mismatch}


enum FormType {
  // authFormType
  login, // signIn
  register,
  reset
}

class Singleton {


  static TextStyle snackbarStyle = const TextStyle(color: Colors.white);
  static double fontSize = 22.0;
  static double textFieldFontSize = 22.0;
  static double resultTextFontSize = 22.0;

  static String calendarIconColorBlue = "#0096ff";
  static String calendarIconColorYellow = "#f8ba00";

  static TextStyle textStyleTextFormField(Color color,
      double textFieldFontSize) {
    return new TextStyle(
      color: color,
      fontFamily: fontFamilyName,
      fontWeight: FontWeight.normal,
      fontSize: textFieldFontSize,
    );
  }

  static TextStyle textStyleButton(Color color) {
    return new TextStyle(
      color: color,
      fontFamily: fontFamilyName,
      fontWeight: FontWeight.normal,
      fontSize: textFieldFontSize - 3,
    );
  }

  static TextStyle textStyleAlertDialog(
      Color color, String fontFamily, double fontSize) {
    return new TextStyle(
      color: color,
      fontFamily: fontFamily,
      // fontFamilyName,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.1,
    );
  }

  // for NewOrderContent.dart
  static TextStyle textStyleHeader(
      Color color, String fontFamily, double fontSize) {
    return new TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.1,
    );
  }

  static TextStyle textStyleAStatusButtons(
      Color color, String fontFamily, double fontSize) {
    return new TextStyle(
      color: color,
      fontFamily: fontFamily,
      // fontFamilyName,
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.7,
    );
  }

// colors
  //@override
  Color hexStringToColorDefaultWhite(String hex) {
    Color color = hexStringToColorDefaultColor(hex, Colors.white);
    return color;
  }
  //@override
  Color hexStringToColorDefaultBlack(String hex) {
    Color color = hexStringToColorDefaultColor(hex, Colors.black);
    return color;
  }
  //@override
  Color hexStringToColorDefaultColor(String hex, Color defaultColor) {
    Color color = Colors.white;
    if(hex == null){
      color = defaultColor;
    }else{
      color = hexStringToColor(hex);
    };
    return color;
  }

  //@override
  Color hexStringToColorDefaultHexString(String hex, String
  defaultHexString) {
    Color color = Colors.white;
    if(hex == null){
      color = hexStringToColor(defaultHexString);
    }else{
      color = hexStringToColor(hex);
    };
    return color;
  }

  //@override
  static Color hexStringToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    Color color = new Color(val).withOpacity(1.0);
    return color;
  }

  ///
  ///
  static Center vertWhiteDelimiter(double rowHeight) {
    return Center(
      child: Container(
        width: 4.0,
        height: rowHeight ,
        decoration: localTesting(true, Colors.white, Colors
            .white, 3.0),
      ),
    );
  }


  static Widget navBarText(String text, double fontsize) {

    double editButtonHeight = 30;
    Color color = Singleton.hexStringToColor(Singleton.calendarIconColorBlue);
    double fontSizeForHeader = fontsize;
    return Container(
      height: editButtonHeight,
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: Singleton.textStyleHeader(
              color,
              Singleton.fontFamilyName,
              fontSizeForHeader),
        ),
      ),
    );
  }

  static TextStyle textStylePasswordRules(
      Color color, String fontFamily, double fontSize) {
    return textStyleAlertDialog(color, fontFamily, fontSize);
  }


  static TextStyle sortButtons() {
    return new
    TextStyle(
      color: Colors.white,
      fontFamily: 'Helvetica Regular',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }



  static BoxDecoration localTesting(
      bool local, Color borderColor, Color boxColor, double width) {
    // localTesting(Colors.black,Colors.white, 4.0)
    // decoration: localTesting(Colors.black, Colors.white, 4.0),
    if (borderColor == null) borderColor = Colors.white;
    if (boxColor == null) boxColor = Colors.white;
    if (width == null) width = 0.0;
    if (local) {
//    print("KKDWMsDRdJJIU localTesting setBorderWhite index = " + width.toString());
    }
    if (local) {
      return BoxDecoration(
        color: boxColor,
        border: new Border.all(
          color: borderColor,
          width: width,
        ),
      );
    } else {
      return BoxDecoration(
        /*
          color: Colors.white,
          border: new Border.all(
            color: Colors.white,
            width: 0.0,
          ),*/
      );
    }
  }

  static double epsilon = 0.00001;
  static double topPadding = 0.0;
  static String appFont = "Verdana";
  static String fontFamilyName = 'Helvetica Regular';
  static void goToScreen(BuildContext context, String screenName) {
    print("LFKGJCNQ goToScreen screenName = " + screenName);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(screenName);
    });
  }

  // user defined function
  static void showDialogGlobal(BuildContext context, String title, String text,
      double fontSize, String font, String widgetName) {
    // flutter defined function
    print("KKIJU _showDialog");
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            title,
            style: Singleton.textStyleAlertDialog(
                Colors.black, fontFamilyName, fontSize),
          ),
          content: new Text(
            text,
            style: Singleton.textStyleAlertDialog(
                Colors.black, fontFamilyName, fontSize),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close",
                  style: Singleton.textStyleAlertDialog(
                      Colors.red,
                      'Helvetica '
                          'Regular',
                      fontSize)),
              onPressed: () {
                print("DFDFHUHU Close");
//                 Navigator.of(context).pushNamed(widgetName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // decorations start
  // taken from newOwnerContent.dart
  static BoxDecoration boxDecorationBuildMenuRowSave(
      String imageName, double rounded) {
    return BoxDecoration(
      color: const Color(0xfffffff),
      image: new DecorationImage(
        image: new AssetImage(
          imageName,
        ),
        fit: BoxFit.cover,
      ),
      borderRadius: new BorderRadius.all(new Radius.circular(rounded)),
      border: new Border.all(
        color: Colors.white,
        width: 0.0,
      ),
    );
  }


  // taken from newOwnerContent.dart
  static BoxDecoration boxDecorationBuildMenuRowSaveNotRounded(
      String imageName, double rounded) {
    return BoxDecoration(
      color: const Color(0xfffffff),
      image: new DecorationImage(
        image: new AssetImage(
          imageName,
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  // taken from registerScreen.dart
  static BoxDecoration boxDecoration(double rounded) {
    return BoxDecoration(
      borderRadius: new BorderRadius.all(new Radius.circular(rounded)),
      color: Colors.white,
      border: new Border.all(
        color: Colors.white,
        width: 1.0,
      ),
    );
  }


  static FormType formType = FormType.login;

  static bool isResetting = false;

  static String passwordRulesText =
      "Password should contain at least one lowercase, at least one uppercase and "
      "at least one digit, and be at least 8 characters long";
  static bool confirmCancel = false;
  static String readConfig = "";

  static String imageFileName = "";

  static bool downloadFinished = true;
  static bool firstRun = true;
  static bool pageDidLoad = false;
  static int selectedIndex = 0;
  static BuildContext context;
  static String nextScreenToLoad = "";

  // background color for the entire app
  static Color listBackgroundColor = Colors.white;

  static String strX;
  static String strY;
  static bool isIpad;
  static bool isIOS;
  static bool tabletDetector;
  static bool isMapView3;
  static String waterQualityImage;
  static List<bool> greenForBeaches = [];

  final mediaQueryData = MediaQuery.of(context);
  static double screenWidth = MediaQuery.of(context).size.width;
  static double screenHeight = MediaQuery.of(context).size.height;
  static int numberVisibleIcons = 8;

  static Queue screenIdQueue = new Queue<String>();

  static double horizontalIconsHeight = 90.0;
  static double horizontalIconsWidth = 90.0;

  static Size getSizes(GlobalKey key) {
    final RenderBox renderBoxRed =
        key.currentContext.findRenderObject() as RenderBox;
    final sizeRed = renderBoxRed.size;
    return sizeRed;
  }

// TextStyles start

  static TextStyle registerScreenHeaderText(Color col) {
    return new TextStyle(
      color: col,
      fontWeight: FontWeight.bold,
    );
  }
}

/// Mutual class for streams to communicate
class SingletonStream {
  static StreamController<int> streamCounter = StreamController.broadcast();

  static int counter = 0;

}

class MyFmt {
  static double leftMargin = 10.0;
  static double rightMargin = 10.0;

  static double headerTop = 39.0;
  static double headerBottom = 0.0;
  static double normalTop = 10.0;
  static double normalBottom = 0.0;

  static double fontSize = 24.0;
  static double minusTen = 20.0;

  static TextStyle normalTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontFamily: 'Helvetica Regular',
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle headerTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontFamily: 'Helvetica Regular',
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    );
  }

  static double computeWidth() {
    double ret = 480 - leftMargin - rightMargin + minusTen;
//    double ret = widthLocal - leftMargin - rightMargin + minusTen;
    return ret;
  }

  static Container normalText(String text) {
    return Container(
      width: computeWidth(),
      padding: EdgeInsets.only(
          top: normalTop,
          left: leftMargin,
          right: rightMargin,
          bottom: normalBottom),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: computeWidth() - minusTen,
              child: Text(
                text,
                style: normalTextStyle(),
              ),
            ),
          ]),
    );
  }

  static Container headerText(String text) {
    return Container(
      width: computeWidth(),
      padding: EdgeInsets.only(
          top: headerTop,
          left: leftMargin,
          right: rightMargin,
          bottom: headerBottom),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: computeWidth() - minusTen,
              child: Center(
                child: Text(
                  text,
                  style: headerTextStyle(),
                ),
              ),
            ),
          ]),
    );
  }

  static Container centerImage(
      String imagename, double imageWidth, double imageHeight) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      width: imageWidth,
      height: imageHeight,
      //   padding: const EdgeInsets.all(0.0),
      child: Center(
        child: Text(""),
      ),
      decoration: BoxDecoration(
        color: const Color(0xfffffff),
        image: new DecorationImage(
          image: new AssetImage(imagename),
          fit: BoxFit.cover,
        ),
        /*border: new Border.all(
              color: Colors.black,
              width: 0.0,
            ),*/
      ),
    );
  }
}

BoxDecoration localTesting(
    bool local, Color borderColor, Color boxColor, double width) {
  // localTesting(Colors.black,Colors.white, 4.0)
  // decoration: localTesting(Colors.black, Colors.white, 4.0),
  if (borderColor == null) borderColor = Colors.white;
  if (boxColor == null) boxColor = Colors.white;
  if (width == null) width = 0.0;
  if (local) {
    //print("KKDWMJJIU localTesting setBorderWhite index = " + width.toString());
  }
  if (local) {
    return BoxDecoration(
      color: boxColor,
      border: new Border.all(
        color: borderColor,
        width: width,
      ),
    );
  } else {
    return BoxDecoration(
        /*
          color: Colors.white,
          border: new Border.all(
            color: Colors.white,
            width: 0.0,
          ),*/
        );
  }
}


String assetsFolder = "assets/";
String imagesFolder = "images/";

class CommonThings {
  static String mainTitle = 'Orders \$99 and Over Ship Free!';
}

class IconType {
  final _value;

  const IconType._internal(this._value);

  // toString() => 'Enum.$_value';

  static const SHOWICONURL = const IconType._internal('SHOWICONURL');
  static const SHOWICONNAME = const IconType._internal('SHOWICONNAME');
  static const SHOWNOICON = const IconType._internal('SHOWNOICON');
}

class ImageType {
  final _value;

  const ImageType._internal(this._value);

  toString() => 'Enum.$_value';

  static const SHOWIMAGEURL = const ImageType._internal('SHOWIMAGEURL');
  static const SHOWIMAGENAME = const ImageType._internal('SHOWIMAGENAME');
  static const SHOWNOIMAGE = const ImageType._internal('SHOWNOIMAGE');
}

class AccessoryType {
  final _value;

  const AccessoryType._internal(this._value);

  toString() => 'Enum.$_value';

  static const DISCLOSUREINDICATOR =
      const AccessoryType._internal('DISCLOSUREINDICATOR');
  static const DETAILSDISCLOSUREINDICATOR =
      const AccessoryType._internal('DETAILSDISCLOSUREINDICATOR');
  static const CHECKMARK = const AccessoryType._internal('CHECKMARK');
  static const BLANK = const AccessoryType._internal('BLANK');
}
