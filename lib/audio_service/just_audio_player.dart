import 'package:just_audio/just_audio.dart';
import 'package:com.ozlisten.ozlistenapp/audio_data/item.dart';
import 'package:com.ozlisten.ozlistenapp/audio_service/audio_player_service.dart';

class JustAudioPlayer implements AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  // State
  @override
  Stream<AudioProcessingState> get audioProcessingState =>
      _audioPlayer.playerStateStream.map(
        (_playerStateMap),
      );

  @override
  Stream<List<PlaylistItem>> get currentPlaylist =>
      _audioPlayer.sequenceStateStream.map(
        (sequenceState) {
          return sequenceState?.sequence
              .map(
                (source) => source.tag,
              )
              .whereType<PlaylistItem>()
              .toList();
        },
      );

  AudioPlayer get audioPlayer => _audioPlayer;

  @override
  bool get hasNext => _audioPlayer.hasNext;

  @override
  bool get hasPrevious => _audioPlayer.hasPrevious;

  @override
  Stream<bool> get isPlaying => _audioPlayer.playingStream;

  @override
  Stream<PlaylistLoopMode> get loopMode =>
      _audioPlayer.loopModeStream.map((_loopModeMap));

  @override
  Stream<bool> get shuffleModeEnabled => _audioPlayer.shuffleModeEnabledStream;

  // Actions

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> play() {
    return _audioPlayer.play();
  }

  @override
  Future<void> seekToNext() {
    return _audioPlayer.seekToNext();
  }

  @override
  Future<void> seekToPrevious() {
    return _audioPlayer.seekToPrevious();
  }

  @override
  Future<void> setLoopMode(PlaylistLoopMode mode) {
    switch (mode) {
      case PlaylistLoopMode.off:
        return _audioPlayer.setLoopMode(LoopMode.off);
      case PlaylistLoopMode.one:
        return _audioPlayer.setLoopMode(LoopMode.one);
      case PlaylistLoopMode.all:
        return _audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  @override
  Future<void> setShuffleModeEnabled(bool enabled) async {
    if (enabled) {
      await _audioPlayer.shuffle();
    }
    return _audioPlayer.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> seekToStart() {
    return _audioPlayer.seek(Duration.zero,
        index: _audioPlayer.effectiveIndices?.first);
  }

  @override
  Future<void> seekToIndex(int index) {
    return _audioPlayer.seek(Duration.zero, index: index);
  }

  @override
  Future<Duration> loadPlaylist(List<PlaylistItem> playlist) {
    return _audioPlayer
        .setAudioSource(
      ConcatenatingAudioSource(
        children: playlist
            .map(
              (item) => AudioSource.uri(
                Uri.parse(item.url),
                tag: item,
              ),
            )
            .toList(),
      ),
    )
        .catchError((error) {
      print("An error occured $error");
    });
  }

  Future<void> dispose() {
    return _audioPlayer.dispose();
  }

  // Helpers
  static AudioProcessingState _playerStateMap(PlayerState state) {
    final processingState = state?.processingState;
    if (processingState == null) return AudioProcessingState.unknown;
    switch (processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;

      case ProcessingState.ready:
        if (state.playing)
          return AudioProcessingState.playing;
        else
          return AudioProcessingState.ready;
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  static PlaylistLoopMode _loopModeMap(LoopMode mode) {
    switch (mode) {
      case LoopMode.off:
        return PlaylistLoopMode.off;
      case LoopMode.one:
        return PlaylistLoopMode.one;
      case LoopMode.all:
        return PlaylistLoopMode.all;
    }
  }
}
