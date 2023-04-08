import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tsbeh/AppRoutes.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../Bloc/AppStates.dart';
import '../../../Notifications/Local/NotificationService.dart';
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
}
