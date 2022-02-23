import 'package:audio_service/audio_service.dart' as AudioService;
import 'package:flutter/material.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/item.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';
import 'package:com.ozlisten.ozlistenapp/custom_assets/colors.dart';
import 'package:com.ozlisten.ozlistenapp/utils/p.dart';
import 'package:com.ozlisten.ozlistenapp/widgets/nothing_to_show.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Player extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayerButtons();
  }
}

class PlayerButtons extends State<Player> {
  int indx = 0;

  TextEditingController describeItController = TextEditingController();

  List<PlaylistItem> mediaItem = <PlaylistItem>[];

  @override
  initState() {
    load_index();
    super.initState();
  }

  Stream<MediaState> get _mediaStateStream => Rx.combineLatest3<
          AudioService.MediaItem,
          Duration,
          AudioService.PlaybackState,
          MediaState>(
      AudioService.AudioService.currentMediaItemStream,
      AudioService.AudioService.positionStream,
      AudioService.AudioService.playbackStateStream,
      (mediaItem, position, playbackState) =>
          MediaState(mediaItem, position, playbackState));

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.85;
    // double height = 400;
    return Consumer<AudioPlayerService>(builder: (_, player, __) {
      bool lp = false;
      String methodName = 'Consumer playerButtons';
      return Container(
        // height: height,
        // color: Colors.red,
        // margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<List<PlaylistItem>>(
                stream: player.currentPlaylist,
                builder: (context, snapshot) {
                  mediaItem = snapshot.data;
                  p('-->44 mediaItem', mediaItem, methodName, lp);
                  p('-->46 indx', indx, methodName, lp);
                  if (mediaItem != null) {
                    p('-->47 mediaItem[indx]', mediaItem[indx], methodName, lp);
                  }
                  return mediaItem != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildImage(height),
                            buildTitle(),
                            buildSubTitle()
                          ],
                        )
                      : NothingToShow(text: 'Current playlist does not exist');
                },
              ),
              /* StreamBuilder<MediaState>(
                stream: _mediaStateStream,
                builder: (context, snapshot) {
                  final mediaState = snapshot.data;
                  return ProgressBar(
                    total: Duration(minutes: 3),
                    // total: mediaState?.mediaItem?.duration ?? Duration.zero,
                    progress: Duration(seconds: 52),
                    // progress: mediaState?.position ?? Duration.zero,
                    onSeek: (newPosition) {
                      Duration(seconds: 52);
                      // AudioService.AudioService.seekTo(newPosition);
                    },
                  );
                },
              ),*/
              Container(
                // color: Colors.yellow,
                height: 100,
                child: buildRowOfButtons(player),
              ),
            ]),
      );
    });
  }

  Row buildRowOfButtons(AudioPlayerService player) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<List<PlaylistItem>>(
          stream: player.currentPlaylist,
          builder: (_, __) {
            return _previousButton(player);
          },
        ),

        StreamBuilder<AudioProcessingState>(
          stream: player.audioProcessingState,
          builder: (_, snapshot) {
            final playerState = snapshot.data ?? AudioProcessingState.unknown;
            return _playPauseButton(playerState, player);
          },
        ),
        // Next
        StreamBuilder<List<PlaylistItem>>(
          stream: player.currentPlaylist,
          builder: (_, __) {
            return _nextButton(player);
          },
        ),
      ],
    );
  }

  Text buildSubTitle() {
    return Text(
      mediaItem[indx].title,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
    );
  }

  Text buildTitle() {
    return Text(
      mediaItem[indx].album_name ?? "",
      textAlign: TextAlign.center,
      maxLines: 1,
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
    );
  }

  Container buildImage(double height) {
    return Container(
        height: height / 3,
        width: height / 3,
        padding: EdgeInsets.only(top: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                Image.network(mediaItem[indx].album_image, fit: BoxFit.fill)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ));
  }

  Widget _playPauseButton(
      AudioProcessingState processingState, AudioPlayerService player) {
    if (processingState == AudioProcessingState.ready) {
      return Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: Center(
            child: IconButton(
          icon: Icon(Icons.play_arrow),
          iconSize: 60.0,
          onPressed: player.play,
        )),
      );
    } else if (processingState != AudioProcessingState.completed) {
      return Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: Center(
            child: IconButton(
          icon: Icon(Icons.pause),
          iconSize: 60.0,
          onPressed: player.pause,
        )),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: Center(
            child: IconButton(
          icon: Icon(Icons.play_arrow),
          iconSize: 60.0,
          onPressed: player.play,
        )),
      );
    }
  }

  Future<bool> setIntValue(String key, value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(key, value);
  }

  Widget _previousButton(AudioPlayerService player) {
    bool lp = true;
    String methodName = '_previousButton';
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
      child: IconButton(
          iconSize: 40.0,
          icon: Icon(Icons.skip_previous),
          // onPressed: player.hasPrevious ? player.seekToPrevious : null,
          onPressed: () {
            if (player.hasPrevious) indx = indx - 1;
            if (indx < 0) indx = 0;
            setIntValue('index', indx);
            p('-->176 indx', indx, methodName, lp);
            player.seekToPrevious();
          }),
    );
  }

  Widget _nextButton(AudioPlayerService player) {
    bool lp = true;
    String methodName = '_nextButton playerButtons';
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
      child: IconButton(
          iconSize: 40.0,
          icon: Icon(Icons.skip_next),
          onPressed: () {
            if (player.hasNext) {
              indx = indx + 1;
              if (indx > mediaItem.length - 1) indx = mediaItem.length - 1;
              setIntValue('index', indx);
              p('-->190 indx', indx, methodName, lp);
              player.seekToNext();
            } else {}
          }),
    );
  }

  load_index() async {
    indx = await getIntValue('index');
    PlayerButtons();
  }

  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<int> getIntValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }
}

class MediaState {
  final AudioService.MediaItem mediaItem;
  final Duration position;
  final AudioService.PlaybackState playbackState;

  MediaState(this.mediaItem, this.position, this.playbackState);
}
