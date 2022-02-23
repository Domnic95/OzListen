import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/item.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/nothing_to_show.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite_audio extends StatefulWidget {
  @override
  _Favorite_audioState createState() => _Favorite_audioState();
}

class _Favorite_audioState extends State<Favorite_audio> {
  bool isLoading = false;
  bool isfav_selected = false;
  List<PlaylistItem> _allSong = [];
  List<PlaylistItem> flitered_results = [];
  String albumTitle = '';

  @override
  initState() {
    super.initState();
    load_audio();
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
    }
    // Refresh the UI
    setState(() {
      flitered_results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: Text('Favorites'),
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
                    child: flitered_results.length > 0
                        ? ListView.builder(
                            itemCount: flitered_results.length,
                            itemBuilder: (context, index) => Card(
                                child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    // margin: EdgeInsets.all(20),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: getImage(index),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 2.0),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                1.6,
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                      ),
                                      child: Text(
                                        flitered_results[index].title,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Row(children: [
                                      //pay button area
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.play_arrow),
                                          color: Colors.red,
                                          onPressed: () {
                                            setIntValue('index', index);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        TabContainerBottom(
                                                            selectedIndex:
                                                                PLAYER_MAIN)));
                                            // => PlayerMain()));
                                            final player =
                                                Provider.of<AudioPlayerService>(
                                                    context,
                                                    listen: false);
                                            player
                                                .loadPlaylist(_allSong)
                                                .then((_) =>
                                                    player.seekToIndex(index))
                                                .then((_) => player.play());
                                          },
                                        ),
                                      ),
                                    ]),
                                  ],
                                )
                              ],
                            )),
                          )
                        : NothingToShow(text: 'No results found')),
              ],
            ),
          ),
        ));
  }

  Object getImage(int index) {
    bool lp = false;
    String methodName = 'methodName FavoriteAudio';
    String address = flitered_results[index].thumbnailUrl;
    p('-->175 address', address, methodName, lp);
    bool b1 = address != null;
    bool b2 = flitered_results[index].thumbnailUrl.contains('uploads/');
    bool b3 = b1 & b2;
    String trueAddress = ROOT_ONLY + address;
    p('-->180 trueAddress', trueAddress, methodName, lp);
    return b3
        ? DecorationImage(image: NetworkImage(trueAddress), fit: BoxFit.fill)
        : DecorationImage(
            image: AssetImage(IMAGE_TRANSPARENT), fit: BoxFit.fill);
  }

  load_fav() async {
    Map data = {'token': await getStringValue('token')};
    final response = await http.post(Uri.parse(FEV_LIST),
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
      final data = jsonDecode(response.body);

      // print('-->202 favorite_audio.dart data = ' + data.toString());
      data.forEach((mapElement) {
        Map map = mapElement as Map;

        try {
          _allSong.add(
            PlaylistItem(
              id: map['id'],
              title: map['title'],
              ifpaid: '1',
              thumbnailUrl: map['image'],
              url: map['base_url'] + map['file_name'],
              album_name: map['album_title'],
              album_image: map['base_url'] + (map['album_image'] ?? ""),
            ),
          );
        } catch (e) {
          log(map.toString());
        }
      });

      // print('-->210 favorite_audio.dart _allSong = ' + _allSong.toString());

      flitered_results = _allSong;
    } else {
      print("Not 200 state");
      showSnackBar("Server error");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      load_fav();
    } catch (e) {
      print('__LOAD_FAV__ $e');
    }
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

  @override
  List<PlaylistItem> get allItems {
    return []..addAll(_allSong);
  }

  Future<String> getStringValue(String key) async {
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
  }
}
