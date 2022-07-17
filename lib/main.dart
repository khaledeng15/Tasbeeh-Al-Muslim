import 'package:flutter/material.dart';
import 'package:tsbeh/AppRoutes.dart';
import 'package:tsbeh/utils/PreferenceUtils.dart';


import 'App/HomeScreen.dart';
import 'App/Notifications/Local/NotificationService.dart';
import 'ProKitLib/locale/Languages.dart';
import 'ProKitLib/main/store/AppStore.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:just_audio/just_audio.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

AppStore appStore = AppStore();
BaseLanguage? language;
final playerAzkar = AudioPlayer();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // await NotificationService().init();
  PreferenceUtils.init();
  initNotificationService();

  runApp(const MyApp());
}

void initNotificationService()
{
  AwesomeNotifications().initialize(
      'resource://drawable/ic_logo',
      [
        NotificationChannel(
            channelGroupKey: 'TSBEH',
            // icon: 'resource://drawable/ic_logo',
            channelKey: "TSBEH_sound",
            channelName: "TSBEH sound notifications",
            channelDescription: "Notifications with TSBEH sound",
            playSound: true,
            // soundSource: 'resource://raw/res_morph_power_rangers',
          soundSource: 'resource://raw/a1_1',

          defaultColor: Colors.red,
            ledColor: Colors.red,
            importance: NotificationImportance.High,
            channelShowBadge: true,
             locked: true,
            defaultPrivacy: NotificationPrivacy.Public,

          ),
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupkey: 'TSBEH', channelGroupName: 'TSBEH sound notifications'),
      ],
      debug: true
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TSBEH',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:   const HomeScreen(),
      routes:  AppRoutes.routes()
    );
  }
}


