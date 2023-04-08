import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/screens/HomeScreen/View/HomeScreen.dart';
import 'package:tsbeh/screens/SplashScreen/View/SplashScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';

import 'Bloc/AppCubit.dart';
import 'Bloc/cubit/ThemeAppCubit.dart';
import 'Bloc/cubit/ThemeAppStates.dart';
import 'Notifications/Local/NotificationService.dart';
import 'Theme/AppTheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'helper/connection/cash/CashLocal.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'helper/dbSQLiteProvider.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
const assetPath = "assets/images";
bool isDarkModeOn = false;
const int DurationHours = 24;
const dateFormat = 'MMM dd, yyyy';
final playerAzkar = AudioPlayer();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await CashLocal.init();

  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  await NotificationService().init();

  await setupTimeZone();

  await dbSQLiteProvider.db.database;

  isDarkModeOn = CashLocal.getStringCash('IsDark') == "" ? false : true;

  String lang = "ar";

  runApp(MyApp(isDarkModeOn, lang));
}

Future<void> setupTimeZone() async {
  tz.initializeTimeZones();
  final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZone));
}

class MyApp extends StatelessWidget {
  final bool IsDark;
  final String langCode;
  MyApp(this.IsDark, this.langCode);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: ((BuildContext context) =>
                AppCubit()..getHomeData(context))),
        BlocProvider(
            create: ((BuildContext context) => ThemeAppCubit()
              ..ChangeAppMode(fromShared: IsDark, lang: langCode))),
        // BlocProvider(
        //   create: ((BuildContext context) => LanguageCubit()..changeStartLang),
        // ),
      ],
      child: BlocConsumer<ThemeAppCubit, ThemeAppStates>(
        listener: (themecontext, state) {},
        builder: (themecontext, state) {
          print("BlocConsumer called");
          return MaterialApp(
            builder: (context, child) {
              child = EasyLoading.init()(context, child);

              return Directionality(
                  textDirection: TextDirection.ltr, child: child);
            },
            // builder: EasyLoading.init(),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            theme: lightTheme,
            darkTheme: darkthemes,
            themeMode: ThemeAppCubit.get(themecontext).IsDark
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            locale: ThemeAppCubit.get(themecontext).appLocal,
          );
        },
      ),
    );
  }
}
