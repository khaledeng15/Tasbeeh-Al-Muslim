import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/AppRoutes.dart';
import 'package:tsbeh/helper/List+ext.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../Bloc/AppStates.dart';
import '../../../Notifications/Local/NotificationService.dart';
import '../../../main.dart';
import '../../../models/ZekerBuildNotifications/BuildAzkar.dart';
import '../../../models/zekerModel.dart';

class scheduleNotificationsController {
  final Function() refresh;

  scheduleNotificationsController(this.refresh);

  List<PendingNotificationRequest> pendingList = [];
  late AppCubit cubit;

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    NotificationService().pending().then((list) {
      pendingList = list;
      pendingList.sortedBy((it) => it.id);

      update();
    });
    update();
  }

  ZekerModel getNotificationModel(
      PendingNotificationRequest notificationRequest) {
    return ZekerModel.fromJson(
        ZekerModel.toMapString(notificationRequest.payload!));
  }

  void deleteNotification(PendingNotificationRequest notificationRequest) {
    NotificationService().cancelNotification(notificationRequest.id);
  }

  void stop() {
    BuildAzkar.stop();

    cubit.emit(InitialAppStates());

    AppRoutes.back();
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
