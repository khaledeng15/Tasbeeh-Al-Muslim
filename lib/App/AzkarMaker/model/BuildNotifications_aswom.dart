import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tsbeh/App/AzkarMaker/model/zekerModel.dart';

import 'BuildAzkar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'PermissionsNotifications.dart';
import 'SleepHourClass.dart';
import 'ZekerTime.dart';

class BuildNotifications_aswom {
  PermissionsNotifications permissionsNotifications =
      PermissionsNotifications();
  late List<ZekerModel> zekerList;
  int fileCursor = 0;

  Future<void> stop(BuildContext context) async {
    await removeAllChanel();
  }

  Future<void> build(BuildAzkar bz, BuildContext context) async {
    await removeAllChanel();

    zekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);

    for (var item in zekerList) {
      await createNotificationChannels(
          item.zeker_id, item.zeker_name, item.soundFileName());

      await permissionsNotifications.check(context, item.zeker_id);

      BuildAzkar.saveZekerListFor(zekerList, zekerListFor.createdChanel);
    }

    bool allowed = permissionsNotifications.globalNotificationsAllowed;
    if (allowed) {
      await AwesomeNotifications().cancelAll();
      await buildList(bz);
    }
  }

  Future<void> removeAllChanel() async {
    List<ZekerModel> lst =
        BuildAzkar.getZekerListFor(zekerListFor.createdChanel);
    for (var item in lst) {
      await AwesomeNotifications().removeChannel(item.zeker_id);
    }
  }

  Future<void> createNotificationChannels(
      String _channelKey, String _channelName, String soundFileName) async {
    String soundSourcePath = 'resource://raw/$soundFileName';
    await AwesomeNotifications().initialize(
        'resource://drawable/ic_logo',
        [
          NotificationChannel(
            channelGroupKey: 'TSBEH',
            // icon: 'resource://drawable/ic_logo',
            channelKey: _channelKey,
            channelName: _channelName,
            channelDescription: "Notifications with TSBEH sound",
            playSound: true,
            // soundSource: 'resource://raw/res_morph_power_rangers',
            // soundSource: 'resource://raw/a1_1',

            soundSource: soundSourcePath,

            defaultColor: Colors.red,
            ledColor: Colors.red,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            locked: true,
            defaultPrivacy: NotificationPrivacy.Public,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupName: 'TSBEH sound notifications',
              channelGroupKey: 'TSBEH'),
        ],
        debug: true);
  }

  List<ZekerTime> getListZekerTime(BuildAzkar bz) {
    // F(n) = h * (n-1) + (m * n)
    // n = notificatin number Max is 24 , h = hour , m = minute

    List<ZekerTime> zTimeList = [];
    int Fn = bz.everyTime.hours == 0 ? 0 : 1;
    bool stop = false;
    do {
      ZekerTime x = ZekerTime();
      if (bz.everyTime.hours != 0) {
        // fix minutes in every hour and increase hour only
        x.hours = bz.everyTime.hours * (Fn - 1);
        x.minutes = bz.everyTime.minutes;
        x.modeHours = true;
      } else {
        // increase minutes only
        x.hours = 0;
        // x.minutes = bz.everyTime.minutes * Fn;
        x.minutes = bz.everyTime.minutes;
        stop = true;
        zTimeList.add(x);
      }

      if (x.minutes >= 60 && bz.everyTime.hours != 0) {
        double h = x.minutes / 60;
        double m = x.minutes % 60;

        x.minutes = m.toInt();
        x.hours = x.hours + h.toInt();
      } else if (x.minutes >= 60 && bz.everyTime.hours == 0) {
        stop = true;
      }

      Fn++;

      if (x.hours >= 24) {
        stop = true;
      }
      if (stop == false) {
        zTimeList.add(x);
        print("N$Fn = ${x.hours}:${x.minutes}");
      }
    } while (!stop);
    return zTimeList;
  }

  ZekerModel getZekerSelected(int countarr) {
    ZekerModel temp = zekerList[fileCursor];
    fileCursor = fileCursor + 1;
    if (fileCursor > countarr - 1) {
      fileCursor = 0;
    }

    String zekerId = temp.zeker_id;
    if (temp.choose_repeat.isEmpty == false &&
        temp.zeker_repeat.isEmpty == false) {
      int chooseRepeat = int.parse(temp.choose_repeat);
      int filerepeat = int.parse(temp.zeker_repeat);

      if (filerepeat < chooseRepeat) {
        chooseRepeat = filerepeat;
      }

      temp.fullFileName = "a$zekerId" "_" "$chooseRepeat";
    }

    return temp;
  }

  Future<void> buildList(BuildAzkar bz) async {
    fileCursor = 0;
    int countarr = zekerList.length;

    List<ZekerTime> zTimeList = getListZekerTime(bz);
    SleepHourClass sleepHours = SleepHourClass.get();

    for (int i = 0; i < zTimeList.length; i++) {
      ZekerTime zekerTime = zTimeList[i];

      if (excludeTime(zekerTime, sleepHours) == false) {
        ZekerModel temp = getZekerSelected(countarr);
        addNotificationSchedule(temp, zekerTime);
      }
    }
  }

  static Future<void> addNotificationSchedule(
      ZekerModel zeker, ZekerTime zekerTime) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    NotificationSchedule? scheduleZeker;

    if (zekerTime.modeHours == false) {
      // int minute = zekerTime.minutes;
      // if (minute == 0) {
      //   minute = 60;
      // } else {
      //   minute = zekerTime.minutes * 60;
      // }
      // scheduleZeker = NotificationInterval(
      //     interval: zekerTime.minutes * 60,
      //     // timeZone: localTimeZone,
      //     repeats: true);
      scheduleZeker = NotificationCalendar(
          minute: zekerTime.minutes, repeats: true, timeZone: localTimeZone);
    } else {
      // var dt = DateHelper.toDate("$hour:$minutes","HH:mm");
      scheduleZeker = NotificationCalendar(
          hour: zekerTime.hours,
          minute: zekerTime.minutes,
          repeats: true,
          timeZone:
              localTimeZone); //NotificationCalendar.fromDate(date: dt,repeats: true);
    }

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: int.parse(zeker.zeker_id),
            channelKey: zeker.zeker_id,
            title: zeker.zeker_name,
            // body:   'This notification was schedule to repeat at every single minute.',
            fullScreenIntent: true,
            category: NotificationCategory.Reminder,
            wakeUpScreen: true,

            // customSound:'resource://raw/res_morph_power_rangers'
            // customSound:'resource://raw/res_morph_power_rangers.m4a',

            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: 'asset://images/app/cover.jpg'),
        schedule: scheduleZeker);

    print("$scheduleZeker =>> ${zeker.fullFileName}}");
  }

  static bool excludeTime(ZekerTime zekerTime, SleepHourClass sleepHours) {
    if (zekerTime.modeHours == true) {
      int zekerTimeInMinutes = zekerTime.hours * 60 + zekerTime.minutes;
      int startSleepHourinMinutes =
          sleepHours.startTime[0] * 60 + sleepHours.startTime[1];
      int endSleepHourinMinutes =
          sleepHours.endTime[0] * 60 + sleepHours.endTime[1];

      if (zekerTimeInMinutes < startSleepHourinMinutes &&
          zekerTimeInMinutes > endSleepHourinMinutes) {
        return true;
      }
    }

    return false;
  }
  // Future<void> buildListOld(BuildAzkar bz) async {
  //   int fileCursor = 0;
  //   int countarr = zekerList.length;

  //   int totalMinutes = bz.everyTime.hours * 60 + bz.everyTime.minutes;
  //   double unit = 0;
  //   // DateTimeComponents repeatInterval = DateTimeComponents.time;
  //   if (totalMinutes < 60) {
  //     unit = 60 / totalMinutes;
  //     // repeatInterval =   DateTimeComponents.dateAndTime; //NSCalendarUnitHour | NSCalendarUnitMinute ;
  //   } else {
  //     unit = 24 / bz.everyTime.hours;
  //     // repeatInterval = DateTimeComponents.dayOfWeekAndTime; //NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute  ;
  //   }

  //   int hourNotif = 0;
  //   int minuteNotif = 0;

  //   for (int i = 0; i < unit; i++) {
  //     if (totalMinutes < 60) {
  //       hourNotif = hourNotif + bz.everyTime.hours;
  //       minuteNotif = minuteNotif + bz.everyTime.minutes;

  //       if (minuteNotif > 60) {
  //         minuteNotif = bz.everyTime.minutes;
  //       }
  //     } else {
  //       hourNotif = hourNotif + bz.everyTime.hours;
  //       minuteNotif = bz.everyTime.minutes;
  //     }

  //     if (hourNotif >= 24) {
  //       hourNotif = 0;
  //     }

  //     if (minuteNotif >= 60) {
  //       minuteNotif = 0;
  //     }

  //     if (excludeTime(hourNotif, minuteNotif) == false) {
  //       ZekerModel temp = zekerList[fileCursor];
  //       fileCursor = fileCursor + 1;
  //       if (fileCursor > countarr - 1) {
  //         fileCursor = 0;
  //       }

  //       String zekerId = temp.zeker_id;
  //       String newfilename = "a$zekerId";
  //       if (temp.choose_repeat.isEmpty == false &&
  //           temp.zeker_repeat.isEmpty == false) {
  //         int chooseRepeat = int.parse(temp.choose_repeat);
  //         int filerepeat = int.parse(temp.zeker_repeat);

  //         if (filerepeat < chooseRepeat) {
  //           chooseRepeat = filerepeat;
  //         }

  //         newfilename = "a$zekerId" "_" "$chooseRepeat";
  //       }

  //       addNotificationSchedule(
  //           temp, hourNotif, minuteNotif, newfilename, temp.zeker_name);
  //       // addNotification(0, (hourNotif * 60) + minuteNotif,newfilename,temp.zeker_name,repeatInterval) ;

  //     }
  //   }
  // }

  // Future<void> createBuild(BuildAzkar bz) async {
  //   // azkarList = BuildAzkar.getSelectedZeker() ;

  //   int fileCursor = 0;
  //   int countarr = zekerList.length;

  //   int totalMinutes = bz.everyTime.hours * 60 + bz.everyTime.minutes;
  //   double unit = 0;
  //   // DateTimeComponents repeatInterval = DateTimeComponents.time;

  //   if (totalMinutes < 60) {
  //     unit = 60 / totalMinutes;
  //     // repeatInterval =   DateTimeComponents.dateAndTime; //NSCalendarUnitHour | NSCalendarUnitMinute ;
  //   } else {
  //     unit = 24 / bz.everyTime.hours;
  //     // repeatInterval = DateTimeComponents.dayOfWeekAndTime; //NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute  ;
  //   }

  //   // addNotification(0, 1,"res_morph_power_rangers", "res_morph_power_rangers") ;
  //   //
  //   // return;
  //   int hourNotif = 0;
  //   int minuteNotif = 0;

  //   for (int i = 0; i < unit; i++) {
  //     if (totalMinutes < 60) {
  //       hourNotif = hourNotif + bz.everyTime.hours;
  //       minuteNotif = minuteNotif + bz.everyTime.minutes;

  //       if (minuteNotif > 60) {
  //         minuteNotif = bz.everyTime.minutes;
  //       }
  //     } else {
  //       hourNotif = hourNotif + bz.everyTime.hours;
  //       minuteNotif = bz.everyTime.minutes;
  //     }

  //     if (hourNotif == 24) {
  //       hourNotif = 0;
  //     }

  //     if (minuteNotif == 60) {
  //       minuteNotif = 0;
  //     }

  //     if (excludeTime(hourNotif, minuteNotif) == false) {
  //       ZekerModel temp = zekerList[fileCursor];
  //       fileCursor = fileCursor + 1;
  //       if (fileCursor > countarr - 1) {
  //         fileCursor = 0;
  //       }

  //       String zekerId = temp.zeker_id;
  //       String newfilename = "a$zekerId";
  //       if (temp.choose_repeat.isEmpty == false &&
  //           temp.zeker_repeat.isEmpty == false) {
  //         int chooseRepeat = int.parse(temp.choose_repeat);
  //         int filerepeat = int.parse(temp.zeker_repeat);

  //         if (filerepeat < chooseRepeat) {
  //           chooseRepeat = filerepeat;
  //         }

  //         newfilename = "a$zekerId" "_" "$chooseRepeat";
  //       }

  //       // addNotification(0, (hourNotif * 60) + minuteNotif,newfilename,temp.zeker_name,repeatInterval) ;

  //     }
  //   }

  //   print("finsh");
  // }

}
