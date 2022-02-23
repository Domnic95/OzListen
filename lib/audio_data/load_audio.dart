import 'dart:convert';

import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/item.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/nothing_to_show.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Load_audio extends StatefulWidget {
  @override
  _Load_audioState createState() => _Load_audioState();
}

class _Load_audioState extends State<Load_audio> {
  bool isLoading = false;
  bool isfav_selected = false;
  List<PlaylistItem> _allSong = [];
  List<PlaylistItem> flitered_results = [];
  ProgressDialog dialog;

  bool favorited = false;

  String albumTitle = '';

  @override
  initState() {
    load_audio();
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<PlaylistItem> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allSong;
    } else {
      results = _allSong
          .where((user) =>
              user.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      flitered_results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    double width = MediaQuery.of(context).size.width;

    return flitered_results != null
        ? WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: primaryColor,
                title: Text('Load audio tracks'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    Card(
                      child: TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.zero)),
                    ),
                    Expanded(
                        child: (flitered_results.length > 0)
                            ? buildListView(width)
                            : Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    NothingToShow(text: "No Album Selected"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             TabContainerBottom(
                                        //                 selectedIndex:
                                        //                     MAIN_FREE)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Please select from home tab",
                                          // style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                  ],
                ),
              ),
            ))
        : NothingToShow(text: 'Nothing to show');
  }

  ListView buildListView(double width) {
    return ListView.builder(
      itemCount: flitered_results.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: <Widget>[
            buildImage(index),
            Row(
              children: <Widget>[
                buildTitle(context, index),
                Row(children: [
                  buildFavorite(context, index),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: width / 15,
                      minWidth: width / 15,
                    ),
                    child: buildIconButton(index, context),
                  ),
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }

  IconButton buildIconButton(int index, BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      color: Colors.red,
      onPressed: () {
        setIntValue('index', index);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    TabContainerBottom(selectedIndex: PLAYER_MAIN)));
        final player = Provider.of<AudioPlayerService>(context, listen: false);
        player
            .loadPlaylist(_allSong)
            .then((_) => player.seekToIndex(index))
            .then((_) => player.play());
      },
    );
  }

  Container buildPayArea(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 10,
        minWidth: MediaQuery.of(context).size.width / 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
      child: IconButton(
        icon: const Icon(Icons.payment_rounded),
        color: Colors.blue,
        onPressed: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (_) => Favorite_audio()));
        },
      ),
    );
  }

  Container buildTitle(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
        minWidth: MediaQuery.of(context).size.width / 2.1,
      ),
      child: Text(
        flitered_results[index].title,
        softWrap: true,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
      ),
    );
  }

  Object getImage(int index) {
    bool lp = true;
    String methodName = 'methodName LoadAudio';
    String address = flitered_results[index].thumbnailUrl;
    p('-->189 address', address, methodName, lp);
    bool b1 = address != null;
    bool b2 = flitered_results[index].thumbnailUrl.contains('uploads/');
    bool b3 = b1 && b2;
    String trueAddress = ROOT_ONLY + address;
    p('-->119480 trueAddress', trueAddress, methodName, lp);
    return b3
        ? DecorationImage(image: NetworkImage(trueAddress), fit: BoxFit.fill)
        : DecorationImage(
            image: AssetImage(IMAGE_TRANSPARENT), fit: BoxFit.fill);
  }

  Widget buildImage(int index) {
    return Container(
      // padding: const EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      width: 50,
      height: 50,
      decoration: BoxDecoration(shape: BoxShape.circle, image: getImage(index)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  Container buildFavorite(BuildContext context, int index) {
    bool lp = true;
    String methodName = 'buildFavorite loadAudio';
    p('\n-->225 flitered_results[$index].favorite',
        flitered_results[index].favorite, methodName, lp);
    favorited = flitered_results[index].favorite == "true";
    p('-->227 favorited', favorited, methodName, lp);
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 10,
        minWidth: MediaQuery.of(context).size.width / 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
      child: IconButton(
        icon: Icon(favorited ? Icons.favorite : Icons.favorite_border),
        color: Colors.green,
        onPressed: () {
          setState(() {
            favorited = !favorited;
            p('-->243 favorited', favorited, methodName, lp);
            flitered_results[index].favorite = favorited.toString();
            p('-->240 flitered_results[$index].favorite',
                flitered_results[index].favorite, methodName, lp);
            add_to_fev(flitered_results[index]);
          });
        },
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  load_audio() async {
    bool lp = true;
    String methodName = 'load_audio LoadAudio';
    albumTitle = await getStringValue('album_title');
    p('-->243 albumTitle', albumTitle, methodName, lp);
    if (albumTitle == '') {
      _allSong = <PlaylistItem>[];
      flitered_results = _allSong;
      return;
    }

    Map data = {
      'album_id': await getStringValue('album_id'),
      'token': await getStringValue('token')
    };
    http.Response response;
    try {
      response = await http.post(Uri.parse(SONGS_LIST),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('__LOAD AUDIO__ $e');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((mapElement) {
        Map map = mapElement as Map;
        // print('>>>>>>>>  ' + map['base_url'] + map['album_image']);
        _allSong.add(
          PlaylistItem(
            id: map['id'],
            title: map['title'],
            ifpaid: map['ifpaid'],
            thumbnailUrl: map['image'],
            url: map['base_url'] + map['file_name'],
            album_name: map['album_name'],
            album_image: map['base_url'] + map['album_image'],
            favorite: map['favorite'],
          ),
        );
      });

      flitered_results = _allSong;
    } else {
      print("Not 200 state");
      showSnackBar("Server error");
    }
  }

  add_to_fev(PlaylistItem playListItem) async {
    bool lp = true;
    String methodName = 'add_to_fev LoadAudio';
    await dialog.show();
    String songId = playListItem.id;
    String favorite = playListItem.favorite;
    p('-->312 songId', songId, methodName, lp);
    p('-->312 favorite', favorite, methodName, lp);
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    Map data = {
      'token': await getStringValue('token'),
      'id': songId,
      'favorite': favorite
    };
    p('-->322 data', data, methodName, lp);
    final response = await http.post(Uri.parse(ADD_TO_FEV),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      p('-->335 resposne', resposne, methodName, lp);
      if (resposne['status'] == "true") {
        await dialog.hide();
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
        // read the album once again
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TabContainerBottom(selectedIndex: LOAD_AUDIO)));
      } else {
        await dialog.hide();
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text("${resposne['msg']}")));
      }
    } else {
      await dialog.hide();
      print("Please try again!");
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text("Please try again!")));
    }
  }

  List<PlaylistItem> get allItems {
    return []..addAll(_allSong);
  }

  static Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<bool> setStringValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  Future<bool> setIntValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(key, value);
  }
}
