import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/zekerModel.dart';

/// https://www.freecodecamp.org/news/local-notifications-in-flutter/
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  // static const String CHANNEL_ID = "TSBEH";
  // static const String CHANNEL_NAME = "TSBEH";
  // static const String CHANNEL_DESCRIPTION = "";

  NotificationDetails notificationDetails(ZekerModel zekerModel) {
    return NotificationDetails(
        android: androidPlatformChannelSpecifics(zekerModel),
        iOS: iOSPlatformChannelSpecifics(zekerModel));
  }

  AndroidNotificationDetails androidPlatformChannelSpecifics(
      ZekerModel zekerModel) {
    return AndroidNotificationDetails(
      zekerModel.channelID!,
      zekerModel.channelName!,
      channelDescription: zekerModel.channelDescription,
      sound: RawResourceAndroidNotificationSound(zekerModel.soundFileName()),
      priority: Priority.high,
      playSound: true,
    );
  }

  DarwinNotificationDetails iOSPlatformChannelSpecifics(ZekerModel zekerModel) {
    String soundName = zekerModel.soundFileName();
    return DarwinNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound:
          soundName, // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 1, // The application's icon badge number
      // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      // subtitle: String?, //Secondary description  (only from iOS 10 onwards)
      // threadIdentifier: String? (only from iOS 10 onwards)
    );
  }

  // NotificationDetails notificationDetails(String soundFileName) {
  //   return NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       CHANNEL_ID,
  //       CHANNEL_NAME,
  //       channelDescription: CHANNEL_DESCRIPTION,
  //       sound: RawResourceAndroidNotificationSound(soundFileName),
  //       playSound: true,
  //     ),
  //     // iOS: IOSNotificationDetails(
  //     //   presentAlert:
  //     //       true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     //   presentBadge:
  //     //       true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     //   presentSound:
  //     //       true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     //   sound:
  //     //       soundFileName, // Specifics the file path to play (only from iOS 10 onwards)
  //     //   badgeNumber: 1, // The application's icon badge number
  //     // )
  //   );
  // }

  // Future<void> init() async {

  //     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('ic_logo');

  //   // final IOSInitializationSettings initializationSettingsIOS =
  //   //     IOSInitializationSettings(
  //   //   requestSoundPermission: true,
  //   //   requestBadgePermission: true,
  //   //   requestAlertPermission: true,
  //   //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  //   // );

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           // iOS: initializationSettingsIOS,
  //           macOS: null);

  //   tz.initializeTimeZones();

  //   // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //   //     onSelectNotification: selectNotification);
  // }

  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_logo');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

// final LinuxInitializationSettings initializationSettingsLinux =
//     const LinuxInitializationSettings(
//         defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      // macOS: initializationSettingsDarwin,
      // linux: initializationSettingsLinux
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);

    if (Platform.isIOS) {
// For iOS:
      // await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final bool? result2 = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');

      //    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);

      // scheduledDate = scheduledDate.add(const Duration(minutes: 2));

      //   NotificationService().scheduleLocalNotifications(id: 1,title: "title",body: "title",scheduledDate: scheduledDate);
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  // Future<void> selectNotification(String? payload) async {
  //   //Handle notification tapped logic here
  // }
  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    //Handle notification tapped logic here
  }

  Future<void> scheduleLocalNotifications(ZekerModel zekerModel) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        zekerModel.notficationId!,
        zekerModel.notficationTitle,
        zekerModel.notficationBody,
        zekerModel.notficationScheduledDate!,
        // tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes)),
        notificationDetails(zekerModel),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: zekerModel.toStringJson());

    /*
         This shows the notification and repeat every day at the same time.
          matchDateTimeComponents: DateTimeComponents.time

        This shows the notification and repeat every week (same day of week and time).
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime


         */
  }

  // Future<void> scheduleLocalNotificationsMinutes( int id,   String title,  String body, int minutes) async
  // {
  //   await scheduleLocalNotifications(id,title,body,tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes))) ;
  // }

  Future<void> repeatLocalNotifications(
      int id, String title, String body, int durationHour) async {
    // const NotificationDetails platformChannelSpecifics =  notificationDetails ;// NotificationDetails(android: androidPlatformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.periodicallyShow(0, title,
    //     body, RepeatInterval.everyMinute, platformChannelSpecifics,
    //     androidAllowWhileIdle: true);
  }

  // Future<void> scheduleLocalNotificationsMinutes( int id,   String title,  String body, int minutes) async
  // {
  //   await scheduleLocalNotifications(id,title,body,tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes))) ;
  // }

  // Future<void> repeatLocalNotifications( int id,   String title,  String body, int durationHour) async
  // {
  //
  //   const NotificationDetails platformChannelSpecifics =  notificationDetails ;// NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.periodicallyShow(0, title,
  //       body, RepeatInterval.everyMinute, platformChannelSpecifics,
  //       androidAllowWhileIdle: true);
  // }

  Future<void> cancelNotification(int notificationID) async {
    await flutterLocalNotificationsPlugin.cancel(notificationID);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<int> count() async {
    List<PendingNotificationRequest> list =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return list.length;
  }

  Future<List<PendingNotificationRequest>> pending() async {
    List<PendingNotificationRequest> list =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return list;
  }
}
