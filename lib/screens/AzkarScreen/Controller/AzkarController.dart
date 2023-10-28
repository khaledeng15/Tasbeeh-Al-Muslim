import 'dart:io';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/appRoutes.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../Bloc/AppStates.dart';
import '../../../main.dart';
import '../../../models/ZekerBuildNotifications/BuildAzkar.dart';
import '../../../models/ZekerBuildNotifications/BuildNotifications.dart';
import '../../../models/zekerModel.dart';

class AzkarController {
  final Function() refresh;

  AzkarController(this.refresh);

  double expandHeight = 350;
  late List<ZekerModel> zekerList = [];
  late List<ZekerModel> selectedZekerList = [];

  BuildAzkar builder = BuildAzkar();
  BuildNotifications buildNotifications = BuildNotifications();

  int selectedSegmentedListType = 0;

  List hours = [];
  List minutes = [];
  late AppCubit cubit;
  bool hideStopTime = false;
  bool _showLoading = false;

  int currentGenrated = 0;
  int totalGenrated = 0;

  void update() {
    refresh();
  }

  Future<void> onInit(BuildContext context) async {
    setupTime();
    ZekerModel.getListOfRepeats(context).then((value) {
      zekerList.addAll(value);
      update();
    });

    selectedZekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);
    checkStopTime();
    update();
  }

  bool isLoading() {
    return _showLoading;
  }

  void showLoading() {
    _showLoading = true;
    update();
  }

  void hideLoading() {
    _showLoading = false;
    update();
  }

  void checkStopTime() {
    if (Platform.isIOS) {
      if (builder.everyTime.hours == 0 && builder.everyTime.minutes < 25) {
        hideStopTime = true;
      } else {
        hideStopTime = false;
      }
    }
  }

  void setupTime() {
    for (var i = 0; i < 60; i++) {
      if (i < 10) {
        minutes.add("0$i");
      } else {
        minutes.add("$i");
      }
    }

    for (var i = 0; i < 24; i++) {
      if (i < 10) {
        hours.add("0$i");
      } else {
        hours.add("$i");
      }
    }
  }

  void segmentedSelected(dynamic val, BuildContext context) {
    if (val == 0) {
      ZekerModel.getListOfRepeats(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    } else if (val == 1) {
      ZekerModel.getListOfazkar(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    } else if (val == 2) {
      ZekerModel.getListOfDoaa(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    } else if (val == 3) {
      ZekerModel.getListOfQuran(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    }
  }

  Future<void> scheduleAzkar(BuildContext context) async {
    if (_showLoading == true) {
      return;
    }

    zekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);
    if (zekerList.length == 0) {
      EasyLoading.showError("من فضلك اختار ذكر اولا");
      return;
    }

    if (Platform.isAndroid) {
      if (builder.everyTime.hours == 0 && builder.everyTime.minutes < 3) {
        EasyLoading.showError("اقل وقت للتذكير ٣ دقائق");
        return;
      }
    }

    showLoading();

    Future.delayed(const Duration(milliseconds: 500), () async {
      await buildNotifications.build(builder, context, (i, total) {
        currentGenrated = i;
        totalGenrated = total;
        // print("$currentGenrated/$totalGenrated");
        refresh();
      });
      BuildAzkar.play();

      cubit.emit(InitialAppStates());
      hideLoading();

      AppRoutes.back();
    });
  }

  void playSound(ZekerModel temp) async {
    String path = temp.soundFileNamePath();
    if (Platform.isAndroid) {
      Uri fileUrl = Uri.parse(path);
      var audio = AudioSource.uri(
        fileUrl,
        tag: MediaItem(
          id: "1",
          title: "    ${temp.zeker_name}   ",
        ),
      );

      player.setAudioSource(audio).then((value) {
        player.play();
      });
    } else {
      String fileUrl = await ZekerModel.getPassFileInIOS(path);

      var audio = AudioSource.file(
        fileUrl,
        tag: MediaItem(
          id: "1",
          title: temp.zeker_name,
        ),
      );
      player.setAudioSource(audio).then((value) {
        player.play();
      });
    }
  }
}
