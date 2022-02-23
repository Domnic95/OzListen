import 'package:com.ozlisten.ozlistenapp/audio_data/item.dart';
enum AudioProcessingState {
  idle,
  loading,
  buffering,
  ready,
  playing,
  completed,
  unknown,
}
enum PlaylistLoopMode {
  off,
  one,
  all,
}
abstract class AudioPlayerService {
  Stream<bool> get isPlaying;
  Stream<bool> get shuffleModeEnabled;
  Stream<AudioProcessingState> get audioProcessingState;
  Stream<PlaylistLoopMode> get loopMode;
  bool get hasPrevious;
  bool get hasNext;
  Stream<List<PlaylistItem>> get currentPlaylist;
  Future<void> seekToPrevious();
  Future<void> seekToNext();
  Future<void> setLoopMode(PlaylistLoopMode mode);
  Future<void> setShuffleModeEnabled(bool enabled);
  Future<void> pause();
  Future<void> play();
  Future<void> seekToStart();
  Future<void> seekToIndex(int index);
  Future<Duration> loadPlaylist(List<PlaylistItem> playlist);
}
