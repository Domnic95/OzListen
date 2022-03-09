import 'dart:async';

import 'package:com.ozlisten.ozlistenapp/album/album.dart';
import 'package:com.ozlisten.ozlistenapp/album/services.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/nothing_to_show.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gridcell.dart';

class GridViewMain extends StatefulWidget {
  bool paidOnly;

  GridViewMain({this.paidOnly}) : super();

  @override
  GridViewDemoState createState() => GridViewDemoState();
}

class GridViewDemoState extends State<GridViewMain> {
  //
  StreamController<int> streamController = new StreamController<int>();
  bool isfav_selected = false;

  Future<List<Album>> _future;

  @override
  void initState() {
    super.initState();
    bool lp = false;
    String methodName = 'GridViewMain ';
    _future = Services.getPhotos();
    p('-->31 initState', '-------------------', methodName, lp);
  }

  gridview(List<Album> albums) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: albums.length == 0
          ? NothingToShow(text: 'Nothing to show')
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: albums.map(
                (album) {
                  return GestureDetector(
                    child: GridTile(
                      child: AlbumCell(album),
                    ),
                    onTap: () {},
                  );
                },
              ).toList(),
            ),
    );
  }

  circularProgress() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final albumNotifier = Provider.of<AlbumNotifier>(context);
    bool lp = false;
    String methodName = 'build gridViewMain';
    p('-->67 build', '-----------', methodName, lp);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: widget.paidOnly ? Text('Purchased items') : Text('Albums'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: FutureBuilder<List<Album>>(
              future: albumNotifier.getPhotos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  p('-->97 snapshot.data', snapshot.data, methodName, lp);
                  List<Album> list = snapshot.data;
                  List<Album> filtered = list;
                  filtered = <Album>[];
                  for (int i = 0; i < list.length; i++) {
                    if (list[i].status == '1') {
                      if (widget.paidOnly) {
                        if (list[i].current_user_paid) {
                          filtered.add(list[i]);
                        }
                      } else {
                        filtered.add(list[i]);
                      }
                    }
                  }
                  streamController.sink.add(filtered.length);
                  return gridview(filtered);
                } else
                  return circularProgress();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }
}
