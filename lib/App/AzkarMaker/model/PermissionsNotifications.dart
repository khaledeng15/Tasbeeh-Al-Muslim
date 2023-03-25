import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';

import 'notification_util.dart';

class PermissionsNotifications {
  // static  String  channelKey = "TSBEH_sound" ;

  bool globalNotificationsAllowed = false;
  bool schedulesFullControl = false;
  bool isCriticalAlertsEnabled = false;
  bool isPreciseAlarmEnabled = false;
  bool isOverrideDnDEnabled = false;

  Map<NotificationPermission, bool> scheduleChannelPermissions = {};
  Map<NotificationPermission, bool> dangerousPermissionsStatus = {};

  List<NotificationPermission> channelPermissions = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Light,
    NotificationPermission.Vibration,
    NotificationPermission.CriticalAlert,
    NotificationPermission.FullScreenIntent
  ];

  List<NotificationPermission> dangerousPermissions = [
    NotificationPermission.CriticalAlert,
    NotificationPermission.OverrideDnD,
    NotificationPermission.PreciseAlarms,
  ];

  Future<void> check(BuildContext context, String channelKey) async {
    await refreshPermissionsIcons(channelKey);
    bool allowed =
        await NotificationUtils.requestBasicPermissionToSendNotifications(
            context);
    // bool allowed =  await NotificationUtils.requestUserPermissions(context, channelKey: channelKey, permissionList: channelPermissions);

    if (allowed != globalNotificationsAllowed) {
      await refreshPermissionsIcons(channelKey);
    }

    // refreshPermissionsIcons().then((_) =>
    //     NotificationUtils.requestBasicPermissionToSendNotifications(context).then((allowed){
    //       if(allowed != globalNotificationsAllowed) {
    //         refreshPermissionsIcons();
    //       }
    //     })
    // );
  }

  Future<void> refreshPermissionsIcons(String channelKey) async {
    globalNotificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();

    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    //   // setState(() {
    //   globalNotificationsAllowed = isAllowed;
    //   // }
    //   // );
    // });
    await refreshScheduleChannelPermissions(channelKey);
    await refreshDangerousChannelPermissions();
  }

  Future<void> refreshScheduleChannelPermissions(String channelKey) async {
    List<NotificationPermission> permissionsAllowed =
        await AwesomeNotifications().checkPermissionList(
            channelKey: channelKey, permissions: channelPermissions);

    schedulesFullControl = true;
    for (NotificationPermission permission in channelPermissions) {
      scheduleChannelPermissions[permission] =
          permissionsAllowed.contains(permission);
      schedulesFullControl =
          schedulesFullControl && scheduleChannelPermissions[permission]!;
    }

    // AwesomeNotifications().checkPermissionList(
    //     channelKey: 'scheduled',
    //     permissions: channelPermissions
    // ).then((List<NotificationPermission> permissionsAllowed) async {
    //   // setState(() {
    //   schedulesFullControl = true;
    //   for(NotificationPermission permission in channelPermissions){
    //     scheduleChannelPermissions[permission] = permissionsAllowed.contains(permission);
    //     schedulesFullControl = schedulesFullControl && scheduleChannelPermissions[permission]!;
    //   }
    //   // }
    // }
    //
    // );
  }

  Future<void> refreshDangerousChannelPermissions() async {
    List<NotificationPermission> permissionsAllowed =
        await AwesomeNotifications()
            .checkPermissionList(permissions: dangerousPermissions);

    for (NotificationPermission permission in dangerousPermissions) {
      dangerousPermissionsStatus[permission] =
          permissionsAllowed.contains(permission);
    }
    isCriticalAlertsEnabled =
        dangerousPermissionsStatus[NotificationPermission.CriticalAlert]!;
    isPreciseAlarmEnabled =
        dangerousPermissionsStatus[NotificationPermission.PreciseAlarms]!;
    isOverrideDnDEnabled =
        dangerousPermissionsStatus[NotificationPermission.OverrideDnD]!;

    // AwesomeNotifications().checkPermissionList(
    //     permissions: dangerousPermissions
    // ).then((List<NotificationPermission> permissionsAllowed) async {
    //   // setState(() {
    //   for (NotificationPermission permission in dangerousPermissions) {
    //     dangerousPermissionsStatus[permission] =
    //         permissionsAllowed.contains(permission);
    //   }
    //   isCriticalAlertsEnabled =
    //   dangerousPermissionsStatus[NotificationPermission.CriticalAlert]!;
    //   isPreciseAlarmEnabled =
    //   dangerousPermissionsStatus[NotificationPermission.PreciseAlarms]!;
    //   isOverrideDnDEnabled =
    //   dangerousPermissionsStatus[NotificationPermission.OverrideDnD]!;
    //   // })
    // }
    // );
  }
}
