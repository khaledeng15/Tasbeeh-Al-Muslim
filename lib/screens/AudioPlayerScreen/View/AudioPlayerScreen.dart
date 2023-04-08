import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/screens/AudioPlayerScreen/View/ControlButtons.dart';

import '../../../main.dart';
import '../../../models/AudioModel/common.dart';
import '../../../models/Base/ApiModel.dart';
import '../Controller/AudioPlayerController.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key, required this.model, required this.list})
      : super(key: key);

  final ApiModel model;
  final List<ApiModel> list;

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AudioPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AudioPlayerController(refresh);
    _controller.onInit(widget.list, widget.model);
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
  }

  void refresh() {
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.titleParent)),
      body: Stack(children: [
        Image.asset(
          "$assetPath/cover.jpg",
          height: 200,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
        Container(
          width: double.maxFinite,
          height: 200,
          color: Colors.black38,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: _controller.player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metadata = state!.currentSource!.tag as MediaItem;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(metadata.album!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold)),
                          Text(metadata.title,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  ),
                ),
                ControlButtons(_controller.player),
                StreamBuilder<PositionData>(
                  stream: _controller.positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        _controller.player.seek(newPosition);
                      },
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    StreamBuilder<LoopMode>(
                      stream: _controller.player.loopModeStream,
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
                            _controller.player.setLoopMode(cycleModes[
                                (cycleModes.indexOf(loopMode) + 1) %
                                    cycleModes.length]);
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        "القائمه",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StreamBuilder<bool>(
                      stream: _controller.player.shuffleModeEnabledStream,
                      builder: (context, snapshot) {
                        final shuffleModeEnabled = snapshot.data ?? false;
                        return IconButton(
                          icon: shuffleModeEnabled
                              ? const Icon(Icons.shuffle, color: Colors.orange)
                              : const Icon(Icons.shuffle, color: Colors.grey),
                          onPressed: () async {
                            final enable = !shuffleModeEnabled;
                            if (enable) {
                              await _controller.player.shuffle();
                            }
                            await _controller.player
                                .setShuffleModeEnabled(enable);
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 240.0,
                  child: StreamBuilder<SequenceState?>(
                    stream: _controller.player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) newIndex--;
                          _controller.playlist.move(oldIndex, newIndex);
                        },
                        children: [
                          for (var i = 1; i < sequence.length; i++)
                            row(sequence, state, i)
                        ],
                      );
                    },
                  ),
                ),
              ],
            )),
      ]),
    );
  }

  Widget row(List<IndexedAudioSource> sequence, SequenceState? state, int i) {
    return Dismissible(
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
        _controller.playlist.removeAt(i);
      },
      child: Material(
        color: i == state!.currentIndex ? Colors.grey.shade300 : null,
        child: ListTile(
          title: Text(
            sequence[i].tag.title as String,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () {
            _controller.player.seek(Duration.zero, index: i);
          },
        ),
      ),
    );
  }
}
