import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../main.dart';
import '../../../models/AudioModel/common.dart';
import '../../../models/Base/ApiModel.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerController {
  final Function() refresh;

  AudioPlayerController(this.refresh);

  List<AudioSource> playlist = [];
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
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Listen to errors during playback.
    player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
    try {
      buildPlaylist();
      // Preloading audio is not currently supported on Linux.
      // await player.setAudioSources(
      //   playlist,
      //   preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux,
      // );
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
  }

  String urlSupportedExtension(String url) {
    return url.replaceAll(".pls", ".weba");
  }

  // استبدال ConcatenatingAudioSource بالطريقة الحديثة باستخدام setAudioSources

  Future<void> buildPlaylist() async {
    // إضافة المقطع الرئيسي (model) إذا كان مسموح به حسب المنصة
    if (kIsWeb ||
        ![
          TargetPlatform.windows,
          TargetPlatform.linux,
        ].contains(defaultTargetPlatform)) {
      playlist.add(
        ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(urlSupportedExtension(model.url!))),
          tag: MediaItem(
            id: model.itemId,
            album: model.titleParent,
            title: model.title,
          ),
        ),
      );
    }

    // 2. إضافة باقي المقاطع من list
    for (int i = 0; i < list.length; i++) {
      ApiModel temp = list[i];
      playlist.add(
        AudioSource.uri(
          Uri.parse(urlSupportedExtension(temp.url!)),
          tag: MediaItem(
            id: temp.itemId,
            album: model.titleParent,
            title: temp.title,
            artist: temp.title,
            artUri: Uri.parse(
              'https://www.cybeasy.com/Tasbeeh-Al-Muslim/vapp-landing/img/logo.png',
            ),
          ),
        ),
      );
    }

    // إعداد قائمة التشغيل في المشغل
    await player.setAudioSources(
      playlist,
      // preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux,
    );
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );
}
