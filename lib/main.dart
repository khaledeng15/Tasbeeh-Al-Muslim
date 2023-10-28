import 'dart:io';

import 'package:app_review_helper/app_review_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/screens/HomeScreen/View/HomeScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Bloc/AppCubit.dart';
import 'Bloc/cubit/ThemeAppCubit.dart';
import 'Bloc/cubit/ThemeAppStates.dart';
import 'Notifications/Local/NotificationService.dart';
import 'Theme/AppTheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'firebase_options.dart';
import 'helper/connection/cash/CashLocal.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'helper/dbSQLiteProvider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
const assetPath = "assets/images";
const int DurationHours = 24;
const dateFormat = 'MMM dd, yyyy';
late final AudioPlayer player;

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

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

  await initFirebase();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await NotificationService.init();

  await setupTimeZone();

  await dbSQLiteProvider.db.database;

  bool isDarkModeOn =
      CashLocal.getStringCash('IsDark') != "true" ? false : true;

  String lang = "ar";

  player = AudioPlayer();

  checkAppRating();

  runApp(MyApp(isDarkModeOn, lang));
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  if (Platform.isAndroid) {
    messaging.subscribeToTopic("android");
  } else if (Platform.isIOS) {
    messaging.subscribeToTopic("ios");
  }
}

Future<void> setupTimeZone() async {
  tz.initializeTimeZones();
  final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZone));
}

void checkAppRating() {
  final appReviewHelper = AppReviewHelper.instance;
  appReviewHelper.initial(
    /// Min days
    minDays: 3,

    /// If you add this line in your main(), it's same as app opening count
    minCalls: 3,

    /// If the current version is satisfied with this than not showing the request
    /// this value use plugin `satisfied_version` to compare.
    // noRequestVersions: ['<=1.0.0', '3.0.0', '>4.0.0'],

    /// Control which versions allow reminding if `keepRemind` is false
    // remindedVersions: ['2.0.0', '3.0.0'],

    /// If true, it'll keep asking for the review on each new version (and satisfy with all the above conditions).
    /// If false, it only requests for the first time the conditions are satisfied.
    keepRemind: false,

    /// Request with delayed duaration
    duration: const Duration(seconds: 5),

    /// Print debug log
    isDebug: false,
  );
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
