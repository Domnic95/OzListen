import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';
import 'package:com.ozlisten.ozlistenapp/controls/player_buttons.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/nothing_to_show.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerButtonsContainer extends StatefulWidget {
  @override
  State<PlayerButtonsContainer> createState() => _PlayerButtonsContainerState();
}

class _PlayerButtonsContainerState extends State<PlayerButtonsContainer> {

  IconData _selectedIcon;
  double _rating;
  double _initialRating;

  String tokenSet = '';
  double hor = 10;

  int indx = 0;

  bool isLoading = false;

  bool noAudioFound = false;

  double fontSize = 18.0;
  String userReview = '';

  @override
  void initState() {
    super.initState();
    load_index();
    _rating = _initialRating;
  }

  load_index() async {
    bool lp = true;
    String methodName = 'load_index PlayerButtonsContainer';
    indx = await getIntValue('index');
    p('-->48 indx', indx, methodName, lp);
    userReview = '0';
    p('-->48 userReview', userReview, methodName, lp);
    _initialRating = 1.0;
    p('-->55 _initialRating', _initialRating, methodName, lp);
    // PlayerButtons();
  }

  Future<int> getIntValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  void _showDialogForRating() {
    print("KKIHGTOOIJYTJU _showDialogForLogout");
    double Kconst = 0.9;
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  'RATING',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Helvetica Regular',
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Expanded(child: Text('')),
              ]),
            ],
          ),
          content: Text(
            'Your rating for this track is ${_rating}',
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
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      userReview = _rating.toString();
                      sendReview(_rating);
                    });
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
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = _initialRating;
                      userReview = '0';
                    });
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

  Widget _ratingBar() {
    bool lp = true;
    String methodName = '_ratingBar playerByttonsContainer';
        p('-->155 userReview', userReview, methodName, lp);
        p('-->155 _rating', _rating, methodName, lp);
        p('-->155 _initialRating', _initialRating, methodName, lp);
        return RatingBar.builder(
          initialRating: _initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 40.0,
          // ignoreGestures: false,
          ignoreGestures: userReview == '0' ? false : true,
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            p('-->173 rating in onRatingUpdate', rating, methodName, lp);
            _rating = rating;
            setState(() {
              if(userReview == '0'){
                p('-->176 userReview', userReview, methodName, lp);
                _showDialogForRating();
              }else{
                // _initialRating = rating;
              }
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer<AudioPlayerService>(
                    builder: (context, player, _) {
                      return StreamBuilder<bool>(
                        stream: player.audioProcessingState
                            .map((state) => state != AudioProcessingState.idle),
                        builder: (context, snapshot) {
                          // If no audio is loaded, do not show the controllers.
                          if (snapshot.data ?? false) {
                            noAudioFound = false;
                            return Container(
                                child: Column(
                                  children: [
                                    Player(),
                                    Container(height: 20,),
                                    _heading('Rate the Album'),
                                    _ratingBar(),
                                  ],
                                ));
                          } else {
                            noAudioFound = true;
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              child: NothingToShow(
                                  text:
                                      'No audio found.\nSelect an audio from stories.'),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      );

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tokenSet = sharedPreferences.getString('token') ?? '';
    sharedPreferences.setString('token', tokenSet);
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<bool> setStringValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  Future<void> sendReview(double userRating) async {
    // await dialog.show();
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    getToken();
    String albumId = await getStringValue('album_id');

    Map data = {
      'review': userRating.toString(),
      'album_id': albumId,
      'token': tokenSet
    };
    print('--> 320 login login_screen.dart ' + data.toString());
    final response = await http.post(Uri.parse(ADD_REVIEW),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    setState(() {
      isLoading = false;
    });
    bool lp = true;
    String methodName = 'player_buttons_container';
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->182 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        print("--> 184 response msg = ${resposne['msg']}");
        String totalReviews = resposne['total_reviews'];
        String averageReview = resposne['avarge_reviews'];
        String sumReviews = resposne['sum_reviews'];
        p('-->203 totalReviews', totalReviews, methodName, lp);
        p('-->203 averageReview', averageReview, methodName, lp);
        p('-->203 sumReviews', sumReviews, methodName, lp);
        p('-->203 userReview', userReview, methodName, lp);
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      } else {
        // await dialog.hide();

        p('-->310 userReview', userReview, methodName, lp);
        hideKeyboard(context);

        setState(() {
        });
        print("${resposne['msg']}");
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      }
    } else {
      // await dialog.hide();
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
    // await dialog.hide();
  }
}
