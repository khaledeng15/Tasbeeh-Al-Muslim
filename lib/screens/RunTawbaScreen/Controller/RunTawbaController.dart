import 'dart:ffi';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/models/Base/ApiModel.dart';
import 'package:tsbeh/models/TawbaModel.dart';

import '../../../main.dart';
import '../../../models/zekerModel.dart';

class RunTawbaController {
  final Function() refresh;

  RunTawbaController(this.refresh);

  ApiModel? model;

  int count = 0;
  bool isRun = false;
  bool isPlaySound = true;

  late AudioSource audio;

  void update() {
    refresh();
  }

  Future<void> onInit(String id) async {
    model = await TawbaModel.getrow(id);
    initSound();
    showPopup();
    update();
  }

  void btnRunCounterClick() {
    isRun = !isRun;
    if (isRun) {
      doInCounter();
      playSound();
      runCounter();
    } else {
      stopSound();
      update();
    }
  }

  void showPopup() {
    EasyLoading.showToast(model?.description ?? "",
        dismissOnTap: true, duration: Duration(minutes: 1));
  }

  void runCounter() {
    if (isRun == false) {
      update();
    } else {
      int time = model!.time * 1000;

      Future.delayed(Duration(milliseconds: time), () async {
        doInCounter();
        runCounter();
      });
    }
  }

  void doInCounter() {
    count++;

    if (count == model!.count) {
      EasyLoading.showSuccess(
          "غفر الله لك , لقد اتممت العدد جعله الله فى ميزان حسناتك",
          dismissOnTap: true,
          duration: Duration(minutes: 10));
    }

    update();
  }

  void initSound() async {
    String path = model!.soundfile;
    // path = path.replaceAll(".mp3", "");
    audio = AudioSource.asset(
      "assets/sounds/$path",
      tag: MediaItem(
        id: "1",
        title: "    ${model!.title}   ",
      ),
    );

    // audio = AudioSource.uri(Uri.parse('asset:assets/sounds/$path'));

    // if (Platform.isAndroid) {
    //   path = path.replaceAll(".mp3", "");
    //   path = "android.resource://com.tsbeh/raw/$path";
    // }
    // if (Platform.isAndroid) {
    //   Uri fileUrl = Uri.parse(path);
    //   audio = AudioSource.uri(
    //     fileUrl,
    //     tag: MediaItem(
    //       id: "1",
    //       title: "    ${model!.title}   ",
    //     ),
    //   );
    // } else {
    //   String fileUrl = await ZekerModel.getPassFileInIOS(path);

    //   audio = AudioSource.file(
    //     fileUrl,
    //     tag: MediaItem(
    //       id: "1",
    //       title: "    ${model!.title}   ",
    //     ),
    //   );
    // }

    player.setAudioSource(audio);
    // player.setAsset("assets/sounds/$path");
    player.setLoopMode(LoopMode.all);
  }

  void checkSound() async {
    if (isPlaySound) {
      playSound();
    } else {
      stopSound();
    }
  }

  void playSound() async {
    player.play();
  }

  void stopSound() async {
    player.pause();
  }
}
