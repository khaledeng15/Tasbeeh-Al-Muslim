
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:rxdart/rxdart.dart';

import '../../ProKitLib/main/utils/AppWidget.dart';
import '../../utils/baseUi.dart';
import '../model/ApiModel.dart';
import 'Example/example_playlist.dart';
import 'model/common.dart';

class AppAudioPlayer extends StatefulWidget
{
  static var tag = "/AppAudioPlayer";

  final ApiModel model;
  final List<ApiModel> list;

  const AppAudioPlayer({Key? key, required this.model, required this.list}  ) : super(key: key);

  @override
  AppAudioPlayerState createState() => AppAudioPlayerState();
}

class AppAudioPlayerState extends State<AppAudioPlayer> with WidgetsBindingObserver {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;
  int _addedCount = 0;

  final _playlistOld = ConcatenatingAudioSource(children: [
    // Remove this audio source from the Windows and Linux version because it's not supported yet
    if (kIsWeb ||
        ![TargetPlatform.windows, TargetPlatform.linux]
            .contains(defaultTargetPlatform))
      ClippingAudioSource(
        start: const Duration(seconds: 60),
        end: const Duration(seconds: 90),
        child:
        AudioSource.uri(Uri.parse(  "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
        tag: AudioMetadata(
          album: "Science Friday",
          title: "A Salute To Head-Scratching Science (30 seconds)",
          artwork:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        ),
      ),

    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///audio/nature.mp3"),
      tag: AudioMetadata(
        album: "Public Domain",
        title: "Nature Sounds",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),

  ]);


  List<AudioSource> buildPlaylist()
  {
     List<AudioSource> lst = [] ;
     for (int i = 0 ; i < widget.list.length ; i ++)
     {
       ApiModel temp = widget.list[i]  ;
       lst.add(AudioSource.uri(
         Uri.parse(temp.url),
         tag: MediaItem(
             id: widget.model.itemId,
             album: temp.titleParent,
             title: temp.title,
            artUri:  Uri.parse('images/app/bgSound.jpg') // "images/app/bgSound.jpg",
         ),
       ));
     }

     _playlist = ConcatenatingAudioSource(children: [
       if (kIsWeb ||
           ![TargetPlatform.windows, TargetPlatform.linux]
               .contains(defaultTargetPlatform))
         ClippingAudioSource(
           // start: const Duration(seconds: 60),
           // end: const Duration(seconds: 90),
           child:
           AudioSource.uri(Uri.parse( widget.model.url)),
           tag: MediaItem(
              id: widget.model.itemId,
             album: widget.model.titleParent,
             title:  widget.model.title,
             artUri:  Uri.parse('https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg') // "images/app/bgSound.jpg",
           ),
         ),

       ]);

     _playlist.addAll(lst);

     return lst;
  }
  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _player = AudioPlayer();
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {
      buildPlaylist();
      // Preloading audio is not currently supported on Linux.
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      // _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body:

          Stack(
            children: [

          Padding(
          padding: const EdgeInsets.only(top: 80),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Center(child:
                            Image.network(metadata.artUri.toString())
                            // commonCacheImageWidget(metadata.artUri,100)
                            // Image.asset(metadata.artUri!.path,   fit: BoxFit.fill)
                            ),
                          ),
                        ),
                        Text(metadata.album!,
                            style: Theme.of(context).textTheme.headline6),
                        Text(metadata.title),
                      ],
                    );
                  },
                ),
              ),
              ControlButtons(_player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      _player.seek(newPosition);
                    },
                  );
                },
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.orange),
                        Icon(Icons.repeat_one, color: Colors.orange),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                          (cycleModes.indexOf(loopMode) + 1) %
                              cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Playlist",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? const Icon(Icons.shuffle, color: Colors.orange)
                            : const Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await _player.shuffle();
                          }
                          await _player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 240.0,
                child: StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final sequence = state?.sequence ?? [];
                    return ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) newIndex--;
                        _playlist.move(oldIndex, newIndex);
                      },
                      children: [
                        for (var i = 0; i < sequence.length; i++)
                          Dismissible(
                            key: ValueKey(sequence[i]),
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (dismissDirection) {
                              _playlist.removeAt(i);
                            },
                            child: Material(
                              color: i == state!.currentIndex
                                  ? Colors.grey.shade300
                                  : null,
                              child: ListTile(
                                title: Text(sequence[i].tag.title as String),
                                onTap: () {
                                  _player.seek(Duration.zero, index: i);
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )
          ) ,
              navigationBase(context, widget.model.titleParent)
            ]),



        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add),
        //   onPressed: () {
        //     _playlist.add(AudioSource.uri(
        //       Uri.parse("asset:///audio/nature.mp3"),
        //       tag: AudioMetadata(
        //         album: "Public Domain",
        //         title: "Nature Sounds ${++_addedCount}",
        //         artwork:
        //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        //       ),
        //     ));
        //   },
        // ),
      )
    ;
  }
}