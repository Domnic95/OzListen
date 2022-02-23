
import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/album/album.dart';

p(String name, Object i, String methodName, bool lp) async {
  String what = name + ' ' + i.toString() + ' ' + methodName;
  if(lp) print(what);
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.focusedChild.unfocus();
  }
}

printAlbum(Album album, int i){
  bool lp = false;
  String methodName = 'printAlbum gridViewMain';
  p('\n-->103 gridview i =', i, methodName, lp);
  p('-->100 album.id', album.id, methodName, lp);
  p('-->100 album.title', album.title, methodName, lp);
  p('-->100 album.date_created', album.dateCreated, methodName, lp);
  p('-->100 album.status', album.status, methodName, lp);
  p('-->100 album.image', album.image, methodName, lp);
  p('-->100 album.ifpaid', album.ifpaid, methodName, lp);
  p('-->100 album.price', album.price, methodName, lp);
  p('-->100 album.rating', album.rating, methodName, lp);
  p('-->100 album.sort', album.sort, methodName, lp);
  p('-->100 album.total_reviews', album.total_reviews, methodName, lp);
  p('-->100 album.avarge_reviews', album.avarge_reviews, methodName, lp);
  p('-->100 album.current_user_paid', album.current_user_paid, methodName, lp);
  p('-->100 album.base_url', album.base_url, methodName, lp);
}

String dummyUserPng = 'images/dumy_user.png';
int PLAYER_MAIN = 3;
int LOAD_AUDIO = 1;
int MAIN_FREE = 0;

int PAID = 4;

void printWrapped(String text) => RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);
