import 'package:com.ozlisten.ozlistenapp/album/services.dart';
import 'package:com.ozlisten.ozlistenapp/api/api.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/profile/credit_provider.dart';
import 'package:com.ozlisten.ozlistenapp/profile/modal/credit_modal.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/custom_card_payment_screen.dart';
import 'package:com.ozlisten.ozlistenapp/stripe/loading_button.dart';
import 'package:com.ozlisten.ozlistenapp/tabcontroller/tabs.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Card;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'album.dart';

class AlbumCell extends StatelessWidget {
  bool isLoading = false;

  final Album album;

  AlbumCell(this.album);

  @required
  payViaNewCard(BuildContext context, String price) async {
    bool lp = true;
    String methodName = 'payViaNewCard gridcell.dart';
    p('-->30 start of method ', '------------', methodName, lp);
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CustomCardPaymentScreen(amount: price, album: album);
    }));
  }

  payViaCredit(BuildContext context, String price) async {
    bool lp = true;
    String methodName = 'payViaNewCard gridcell.dart';
    p('-->30 start of method ', '------------', methodName, lp);
    if (double.parse(
            Provider.of<CreditProvider>(context, listen: false).user_credit) ==
        0.0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Add credit to your wallet to buy audio"),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ok"),
                  ),
                )
              ],
            );
          });
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return PaymentDialog(
            album: album,
          );
        });
  }

  int increment = -1;

  @override
  Widget build(BuildContext context) {
    bool lp = true;
    String methodName = 'build gridCell';

    increment++;
    printAlbum(album, increment);
    album.thumbnailUrl = album.thumbnailUrl ?? '';
    // p('-->94 album.thumbnailUrl', album.thumbnailUrl, methodName, lp);
    /*if (album.thumbnailUrl == '') {
      album.thumbnailUrl =
          'uploads/album_images/951d2a5af5a46c5a2d0d6209bb55b4d7.jpg';
    }*/
    // p('-->105 album.thumbnailUrl', album.thumbnailUrl, methodName, lp);
    return showAlbum(context, album);
  }

  SizedBox showAlbum(BuildContext context, Album album) {
    setStringValue('album_title', album.title);
    setStringValue('album_rating', album.rating);
    return SizedBox(
        height: MediaQuery.of(context).size.width * 0.3,
        child: Card.Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: ClipRRect(
                      child: Hero(
                        tag:
                            "image${album.id}${DateTime.now().millisecondsSinceEpoch.toString()}",
                        child: getStack(album, context),
                      ),
                    ),
                  ),
                  getContent(context, album)
                ],
              ),
            ),
          ),
        ));
  }

  Padding getContent(BuildContext context, Album album) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 1.0),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width / 1.2,
              minHeight: 20,
              maxHeight: 30,
            ),
            child: Text(
              album.title,
              maxLines: 1,
              softWrap: true,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          album.author.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 1.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    minWidth: MediaQuery.of(context).size.width / 1.2,
                    minHeight: 20,
                    maxHeight: 30,
                  ),
                  child: Text(
                    'By: ' + album.author.toString(),
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Container(),
          Container(
            constraints: BoxConstraints(
              minHeight: 25,
              maxHeight: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    alignment: FractionalOffset.centerLeft,
                    child: Row(children: [
                      RatingBarIndicator(
                        rating: double.parse(album.avarge_reviews),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 12.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        album.total_reviews,
                        textAlign: TextAlign.start,
                      ),
                    ])),
                const Expanded(child: Text('')),
                Container(
                    alignment: FractionalOffset.centerRight,
                    child: Row(children: [
                      album.ifpaid == '1'
                          ? !album.current_user_paid
                              ? TextButton(
                                  onPressed: () {
                                    payViaCredit(context, album.price);
                                  },
                                  child: Text(
                                    'Buy',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )
                              : Text('Paid',
                                  style: TextStyle(color: Colors.green))
                          : Container(),
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack getStack(Album album, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        album.thumbnailUrl.isNotEmpty
            ? FadeInImage.assetNetwork(
                placeholder: IMAGE_TRANSPARENT,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                image: ROOT_ONLY + album.thumbnailUrl,
                fit: BoxFit.fill,
              )
            : Container(
                margin: const EdgeInsets.all(0.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                child: Center(),
                decoration: BoxDecoration(
                  color: const Color(0xfffffff),
                  image: DecorationImage(
                    image: AssetImage(IMAGE_TRANSPARENT),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
        CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.7),
          radius: 30,
          child: IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Colors.white,
            iconSize: 30.0,
            onPressed: () {
              setStringValue('album_id', album.id);
              setStringValue('album_rating', album.rating);
              setStringValue('album_image_grid', getImageString());

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          TabContainerBottom(selectedIndex: LOAD_AUDIO)));
            },
          ),
        ),
      ],
    );
  }

  ImageProvider getImage() {
    if (album.thumbnailUrl == null || album.thumbnailUrl == '') {
      return ExactAssetImage(dummyUserPng);
    } else {
      return NetworkImage(ROOT_ONLY + album.thumbnailUrl);
    }
  }

  String getImageString() {
    if (album.thumbnailUrl == null || album.thumbnailUrl == '') {
      return dummyUserPng;
    } else {
      return ROOT_ONLY + album.thumbnailUrl;
    }
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<bool> setStringValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }
}

class PaymentDialog extends StatefulWidget {
  final Album album;
  const PaymentDialog({this.album, Key key}) : super(key: key);

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  @override
  Widget build(BuildContext context) {
    final creditNotifier = Provider.of<CreditProvider>(context);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.album.title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "Credit in wallet: " + creditNotifier.user_credit.toString()),
              Text("price: " + widget.album.price),
              const SizedBox(
                height: 10,
              ),
              LoadingButton(
                text: "pay",
                onPressed: () async {
                  final res =
                      await Provider.of<CreditProvider>(context, listen: false)
                          .buyFromCredit(widget.album);
                  if (res == true) {
                    Provider.of<AlbumNotifier>(context, listen: false)
                        .refersh();
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Album bought successfully"),
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("ok"),
                                ),
                              )
                            ],
                          );
                        });
                  }
                },
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
