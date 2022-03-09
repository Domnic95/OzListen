import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:com.ozlisten.ozlistenapp/profile/buy_credit_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/credentials/login_screen.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/main.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  File file;
  bool _status = true;
  bool isLoading = false;
  final FocusNode myFocusNode = FocusNode();
  static ScaffoldMessengerState scaffoldMessenger;
  String firstname, lastname, email, mobile_no, profileurl, password;
  Future<File> imageFile;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _LastNameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PhoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _focusNode;

  String _hintText = 'Enter password';
  String _labelText = 'Enter password';

  bool _dontShowPassword;

  double fontSize = 15.0;

  @override
  void initState() {
    profile_data();
    _dontShowPassword = true;
    _passwordController = TextEditingController();
    _focusNode = FocusNode()..addListener(_onPasswordFocusChanged);
    super.initState();
  }

  void _onPasswordFocusChanged() {
    if (_focusNode.hasFocus) {
      setState(() {
        _hintText = 'Enter password';
        _labelText = 'Enter password';
      });
    } else {
      if (_passwordController.text.isEmpty) {
        setState(() {
          _hintText = 'Enter password';
          _labelText = 'Enter password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: Text('Profile'),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200.0,
                  // color: Colors.green,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // image: false
                                  image: decorationImage(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {
                                        _choose();
                                      },
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        // color: Colors.blue,
                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                    child: RaisedButton(
                                  child: Text("Log out"),
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      _status = true;
                                      _showDialogForLogout('Log out?');
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                )),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _status
                                              ? _getEditIcon()
                                              : Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: _firstNameController,
                                          decoration: const InputDecoration(
                                            //         firstname,lastname,email,mobile_no;
                                            hintText: 'Enter First Name',
                                          ),
                                          enabled: !_status,
                                          autofocus: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Last Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: _LastNameController,
                                          decoration: const InputDecoration(
                                              hintText: "Enter last Name"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Email ID',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          readOnly: true,
                                          controller: _EmailController,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Email ID"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Mobile',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: _PhoneController,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Mobile Number"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Password',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          obscureText: _dontShowPassword,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            hintText: _hintText,
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            labelText: _labelText,
                                            labelStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            suffixIcon: IconButton(
                                              alignment: Alignment.bottomRight,
                                              icon: FaIcon(
                                                _dontShowPassword
                                                    ? FontAwesomeIcons.eyeSlash
                                                    : FontAwesomeIcons.eye,
                                                color: _dontShowPassword
                                                    ? Colors.grey[700]
                                                    : Colors.grey[350],
                                                size: 18.0,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _dontShowPassword =
                                                      !_dontShowPassword;
                                                });
                                              },
                                            ),
                                          ),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BuyCredit()));
                                    },
                                    child: Text("Buy Credit")),
                              ),
                              !_status ? _getActionButtons() : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  DecorationImage decorationImage() {
    bool lp = false;
    String methodName = 'decorationImage profile_screen.dart';
    p('-->435 profileurl', profileurl, methodName, lp);
    DecorationImage decorationImage;
    try {
      decorationImage = profileurl != ''
          ? DecorationImage(image: NetworkImage(profileurl), fit: BoxFit.cover)
          : DecorationImage(
              image: ExactAssetImage(dummyUserPng),
              fit: BoxFit.cover,
            );
    } catch (e) {
      print('__decorationImage__ $e');
      profileurl = dummyUserPng;
      decorationImage = DecorationImage(
        image: ExactAssetImage(dummyUserPng),
        fit: BoxFit.cover,
      );
    }
    p('-->452 profileurl', profileurl, methodName, lp);

    return decorationImage;
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    update_profile_data();
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  String tokenSet;

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tokenSet = sharedPreferences.getString('token') ?? '';
    // sharedPreferences.setString('token', tokenSet);
  }

  setToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString('token', '');
  }

  void _showDialogForLogout(String text) {
    print("KKIHGTOOIJYTJU _showDialogForLogout");
    double Kconst = 0.9;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Color(0xFFa7b7bf),
          title: Column(
            children: [
              Row(children: <Widget>[
                const Expanded(child: Text('')),
                IconButton(
                  iconSize: 25.0,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]),
              Row(children: <Widget>[
                Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Helvetica Regular',
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const Expanded(child: Text('')),
              ]),
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Helvetica Regular',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "YES",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Helvetica Regular',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  onPressed: () {
                    setTokenToBlanc();
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    "NO",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Helvetica Regular',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> setTokenToBlanc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('album_title', '');
    preferences.setString('token', '');
    isLoggedInGlobal = false;
    Navigator.push(context, MaterialPageRoute(builder: (_) => MyAppStart()));
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  profile_data() async {
    bool lp = true;
    String methodName = 'profile_data ProfileScreen';
    // await progress.show();
    String token = await getStringValue('token');
    if (token.isEmpty) {
      return;
    }
    Map data = {'token': token};
    p('-->649 profileData', data, methodName, lp);
    final response = await http.post(Uri.parse(FETCH_PROFILE),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    setState(() {
      isLoading = false;
    });
    p('-->443 response.statusCode', response.statusCode, methodName, lp);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->447 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        firstname = resposne["firstname"];
        lastname = resposne["lastname"];
        email = resposne["email"];
        mobile_no = resposne["mobile_no"];
        profileurl = resposne["profile_picture"] ?? '';
        print('-->450 profile_data.dart profileurl = ' + profileurl.toString());

        _firstNameController.text = resposne["firstname"];
        _EmailController.text = resposne["email"];
        _PhoneController.text = resposne["mobile_no"];
        _LastNameController.text = resposne["lastname"];
      } else {
        print("${resposne['msg']}");
      }
    } else {
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
  }

  update_profile_data() async {
    bool lp = true;
    String methodName = 'update_profile_data ProfileScreen';
    p('-->675 _passwordController.text', _passwordController.text, methodName,
        lp);
    Map data = {
      'token': await getStringValue('token'),
      'firstname': _firstNameController.text,
      'lastname': _LastNameController.text,
      'mobile_no': _PhoneController.text,
      'password': _passwordController.text
    };
    print(data.toString());
    final response = await http.post(
      Uri.parse(UPDATE_PROFILE_DATA),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne['status'] == "true") {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text(resposne["msg"])));
        profile_data();
        _status = true;
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        print("${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text(resposne["msg"])));
      }
    } else {
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
  }

  void _choose() async {
    ImagePicker picker = ImagePicker();
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    XFile xFile = await picker.pickImage(source: ImageSource.gallery);
    file = File(xFile.path);
    profile_image_upload();
  }

  profile_image_upload() async {
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;
    Map data = {
      'token': await getStringValue('token'),
      'image': base64Image,
      'name': fileName
    };
    print('-->547 profile_image_upload ' + data.toString());
    final response = await http.post(Uri.parse(UPLOAD_PROFILE_IMG),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    isLoading = false;
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne['status'] == "true") {
        print("${resposne['msg']}");
        profile_data();
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      } else {
        print("${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      }
    } else {
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }
}
