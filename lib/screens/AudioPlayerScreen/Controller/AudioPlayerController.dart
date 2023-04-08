import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../models/AudioModel/common.dart';
import '../../../models/Base/ApiModel.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerController {
  final Function() refresh;

  AudioPlayerController(this.refresh);

  late AudioPlayer player;
  late ConcatenatingAudioSource playlist;
  late List<ApiModel> list;
  late ApiModel model;

  void update() {
    refresh();
  }

  Future<void> onInit(List<ApiModel> _list, ApiModel _model) async {
    list = _list;
    model = _model;
    await _init();
    update();
  }

  Future<void> _init() async {
    player = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      buildPlaylist();
      // Preloading audio is not currently supported on Linux.
      await player.setAudioSource(playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
  }

  void buildPlaylist() {
    List<AudioSource> lst = [];
    for (int i = 0; i < list.length; i++) {
      ApiModel temp = list[i];
      lst.add(AudioSource.uri(
        Uri.parse(temp.url!),
        tag: MediaItem(
          id: model.itemId,
          album: temp.titleParent,
          title: temp.title,
        ),
      ));
    }

    playlist = ConcatenatingAudioSource(children: [
      if (kIsWeb ||
          ![TargetPlatform.windows, TargetPlatform.linux]
              .contains(defaultTargetPlatform))
        ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(model.url!)),
          tag: MediaItem(
            id: model.itemId,
            album: model.titleParent,
            title: model.title,
          ),
        ),
    ]);

    playlist.addAll(lst);
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
