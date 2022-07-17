// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
//
// /// https://www.freecodecamp.org/news/local-notifications-in-flutter/
// class NotificationService {
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static final NotificationService _notificationService =
//   NotificationService._internal();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//     static const String CHANNEL_ID = "FUDC";
//   static const String CHANNEL_NAME = "FUDC";
//   static const String CHANNEL_DESCRIPTION = "";
//
//   static const  notificationDetailsOld =   NotificationDetails(
//       android:  androidPlatformChannelSpecifics,
//       iOS:  iOSPlatformChannelSpecifics
//
//   );
//
//   static const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails(
//     CHANNEL_ID,
//     CHANNEL_NAME,
//     channelDescription: CHANNEL_DESCRIPTION,
//     sound: RawResourceAndroidNotificationSound("insight"),
//     playSound: true,
//   ) ;
//
//
//   static const IOSNotificationDetails iOSPlatformChannelSpecifics =
//   IOSNotificationDetails(
//       presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//       presentBadge: true,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//       presentSound: true,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//       sound: "insight.mp3",  // Specifics the file path to play (only from iOS 10 onwards)
//       badgeNumber: 1, // The application's icon badge number
//       // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
//       // subtitle: String?, //Secondary description  (only from iOS 10 onwards)
//       // threadIdentifier: String? (only from iOS 10 onwards)
//   );
//
//   NotificationDetails notificationDetails(String soundFileName)
//   {
//     return  NotificationDetails(
//           android:  AndroidNotificationDetails(
//             CHANNEL_ID,
//             CHANNEL_NAME,
//             channelDescription: CHANNEL_DESCRIPTION,
//             sound: RawResourceAndroidNotificationSound(soundFileName) ,
//             playSound: true,
//           ) ,
//           iOS:   IOSNotificationDetails(
//             presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//             presentBadge: true,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//             presentSound: true,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//             sound: soundFileName,  // Specifics the file path to play (only from iOS 10 onwards)
//             badgeNumber: 1, // The application's icon badge number
//
//           )
//
//       );
//   }
//
//
//   Future<void> init() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('ic_logo');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: null);
//
//     tz.initializeTimeZones();
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }
//
//
//   Future<void> selectNotification(String? payload) async {
//     //Handle notification tapped logic here
//   }
//   Future<void> onDidReceiveLocalNotification( int id, String? title, String? body, String? payload) async {
//     //Handle notification tapped logic here
//   }
//
//
//   Future<void> scheduleLocalNotifications( int id,   String title,  String body, tz.TZDateTime scheduledDate,    DateTimeComponents repeatInterval,String fileName) async
//   {
//
//         NotificationDetails platformChannelSpecifics =   notificationDetails(fileName) ;// NotificationDetails(android: androidPlatformChannelSpecifics);
//       await flutterLocalNotificationsPlugin.periodicallyShow(0, title,
//           body, RepeatInterval.everyMinute  , platformChannelSpecifics,
//           androidAllowWhileIdle: true);
//
//     // await flutterLocalNotificationsPlugin.zonedSchedule(
//     //     id,
//     //     title,
//     //     body,
//     //     scheduledDate,
//     //     // tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes)),
//     //     notificationDetails(fileName) ,
//     //     androidAllowWhileIdle: true,
//     //     uiLocalNotificationDateInterpretation:  UILocalNotificationDateInterpretation.absoluteTime,
//     //     matchDateTimeComponents: repeatInterval);
//   }
//
//
//   // Future<void> scheduleLocalNotificationsMinutes( int id,   String title,  String body, int minutes) async
//   // {
//   //   await scheduleLocalNotifications(id,title,body,tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes))) ;
//   // }
//
//   // Future<void> repeatLocalNotifications( int id,   String title,  String body, int durationHour) async
//   // {
//   //
//   //   const NotificationDetails platformChannelSpecifics =  notificationDetails ;// NotificationDetails(android: androidPlatformChannelSpecifics);
//   //   await flutterLocalNotificationsPlugin.periodicallyShow(0, title,
//   //       body, RepeatInterval.everyMinute, platformChannelSpecifics,
//   //       androidAllowWhileIdle: true);
//   // }
//
//   Future<void>  cancelNotification(int notificationID) async
//   {
//     await flutterLocalNotificationsPlugin.cancel(notificationID);
//
//   }
//
//
//   Future<void>  cancelAll() async
//   {
//     await flutterLocalNotificationsPlugin.cancelAll();
//
//   }
//
// }
