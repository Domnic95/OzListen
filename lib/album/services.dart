import 'dart:convert';

import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/cupertino.dart';

import 'album.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlbumNotifier extends ChangeNotifier {
  List<Album> albums;
  Future<List<Album>> getPhotos() {
    return Services.getPhotos();
  }

  refersh() {
    notifyListeners();
  }
}

class Services {
  static Future<List<Album>> getPhotos() async {
    bool lp = false;
    String methodName = 'getPhotos Services';
    p('-->14 start ', '=============', methodName, lp);
    List<Album> list;

    Map data = {'token': await getStringValue('token')};
    try {
      final response = await http.post(Uri.parse(LIST_ALBUM),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));
      p('-->24 response.body', response.body, methodName, lp);

      if (response.statusCode == 200) {
        String responseBody = response.body.toString();
        p('-->31 responseBody', responseBody, methodName, lp);
        list = parsePhotos(response.body);
        p('-->30 list', list, methodName, lp);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      p('-->35 EXCEPTION getPhotos ', e, methodName, lp);
      throw Exception(e.toString());
    }
  }

  static List<Album> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    bool lp = false;
    String methodName = 'parsePhotos';
    p('-->44 parsed', parsed, methodName, lp);
    var fff = parsed.map<Album>((json) => Album.fromJson(json)).toList();
    p('-->49 fff', fff, methodName, lp);
    return fff;
  }

  static Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }
}
