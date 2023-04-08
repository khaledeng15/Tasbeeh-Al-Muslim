import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tsbeh/models/zekerModel.dart';

import '../../Notifications/Local/NotificationService.dart';
import '../../main.dart';
import 'BuildAzkar.dart';

import 'SleepHourClass.dart';
import 'ZekerTime.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:intl/intl.dart';

class BuildNotifications {
  late List<ZekerModel> zekerList;
  int fileCursor = 0;

  Future<void> stop(BuildContext context) async {
    await removeAllChanel();
  }

  Future<void> build(BuildAzkar bz, BuildContext context) async {
    /*
 NotificationService().cancelAll() ;
        tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local);

    scheduledDate = scheduledDate.add(const Duration(minutes: 2));

    ZekerModel zekerModel = ZekerModel();
    zekerModel.zeker_id = "1";
    zekerModel.zeker_repeat = "1" ;
    zekerModel.channelID = "a1_1" ;
    zekerModel.channelName =  "a1_1" ;
    zekerModel.channelDescription =  "" ;
    zekerModel.notficationId = 1 ;
    zekerModel.notficationTitle = "test" ;
    zekerModel.notficationBody = "test" ;
    zekerModel.notficationScheduledDate = scheduledDate ;

    // "a1_1"
    NotificationService().scheduleLocalNotifications(zekerModel);
*/

    await removeAllChanel();

    zekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);

    for (var item in zekerList) {
      // await createNotificationChannels(
      //     item.zeker_id, item.zeker_name, item.soundFileName());

      // await permissionsNotifications.check(context, item.zeker_id);

      BuildAzkar.saveZekerListFor(zekerList, zekerListFor.createdChanel);
    }

    removeAllChanel();
    await buildList(bz);
  }

  tz.TZDateTime getDate() {
    var currentDate = DateFormat(dateFormat).format(DateTime.now());

    final DateTime tempDate = DateFormat(dateFormat).parse(currentDate);

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(tempDate, tz.local);

    return scheduledDate;
  }

  Future<void> removeAllChanel() async {
    NotificationService().cancelAll();
  }

  List<ZekerTime> getListZekerTime(BuildAzkar bz) {
    // F(n) = h * (n-1) + (m * n)
    // n = notificatin number Max is 24 , h = hour , m = minute
    // Max notification for android = 500 , ios = 64
    // Min notification time will by every 25 minutes

    // if (bz.everyTime.hours != 0) {
    return getListZekerTimeByHour(bz);
    // } else {
    //   return getListZekerTimeByMinutes(bz);
    // }
  }

  List<ZekerTime> getListZekerTimeByMinutes(BuildAzkar bz) {
    // F(n) = h * (n-1) + (m * n)
    // n = notificatin number Max is 24 , h = hour , m = minute

    List<ZekerTime> zTimeList = [];
    int Fn = 1;
    int lastMinutes = 0;
    bool stop = false;

    do {
      ZekerTime x = ZekerTime();
      x.hours = Fn - 1;
      x.minutes = bz.everyTime.minutes + lastMinutes;

      lastMinutes = x.minutes;

      if (x.minutes >= 60) {
        lastMinutes = 0;
        Fn++;
      }

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

  List<ZekerTime> getListZekerTimeByHour(BuildAzkar bz) {
    List<ZekerTime> zTimeList = [];
    int Fn = 1;
    bool stop = false;
    int totalMinutes = bz.everyTime.hours * 60 + bz.everyTime.minutes;
    do {
      ZekerTime x = ZekerTime();
      // if (bz.everyTime.hours != 0) {
      //   // fix minutes in every hour and increase hour only
      //   x.hours = bz.everyTime.hours * (Fn - 1);
      //   x.minutes = bz.everyTime.minutes;
      //   x.modeHours = true;
      // }

      int newTotalMinutes = totalMinutes * Fn;

      // if (x.minutes >= 60) {
      double h = newTotalMinutes / 60;
      double m = newTotalMinutes % 60;

      x.minutes = m.toInt();
      x.hours = x.hours + h.toInt();
      // }
      // else if (x.minutes >= 60 && bz.everyTime.hours == 0) {
      //   stop = true;
      // }

      Fn++;

      if (x.hours >= 24) {
        x.hours = 0;
        zTimeList.add(x);
        print("N$Fn = ${x.hours}:${x.minutes}");

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

    String zekerId = "${temp.zeker_id}";
    if (temp.choose_repeat.isEmpty == false && temp.zeker_repeat != 1) {
      int chooseRepeat = int.parse(temp.choose_repeat);
      int filerepeat = temp.zeker_repeat;

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

      if (excludeTime(zekerTime, sleepHours, bz) == false) {
        ZekerModel zekerModel = getZekerSelected(countarr);
        // addNotificationSchedule(temp, zekerTime);
        log("${zekerModel.soundFileName()} / ${zekerTime.toJson()}");

        zekerModel.channelID = zekerModel.soundFileName();
        zekerModel.channelName = zekerModel.zeker_name;
        zekerModel.channelDescription = "";
        zekerModel.notficationId = zekerTime.timeID();
        zekerModel.notficationTitle = zekerModel.zeker_name;
        // zekerModel.notficationBody = zekerModel.zeker_type;
        zekerModel.notficationScheduledDate = zekerTime.scheduledDate();

        NotificationService().scheduleLocalNotifications(zekerModel);
      }
    }
    int count = await NotificationService().count();
    log("Stored Notifications : $count ");
  }

  static bool excludeTime(
      ZekerTime zekerTime, SleepHourClass sleepHours, BuildAzkar bz) {
    if (bz.sleepTime.stopAt == false) {
      return false;
    }

    bool exclude = false;

    int zekerTimeInMinutes = zekerTime.hours * 60 + zekerTime.minutes;

    int startSleepHourinMinutes =
        sleepHours.startTime[0] * 60 + sleepHours.startTime[1];
    int endSleepHourinMinutes =
        sleepHours.endTime[0] * 60 + sleepHours.endTime[1];

    if (startSleepHourinMinutes > endSleepHourinMinutes) // it's in two day
    {
      // start time compare to  1440 (24*60)
      if (zekerTimeInMinutes >= startSleepHourinMinutes &&
          zekerTimeInMinutes <= 1440) {
        exclude = true;
      } else if (zekerTimeInMinutes >= 0 &&
          zekerTimeInMinutes <= endSleepHourinMinutes) {
        exclude = true;
      }
    } else {
      // in same day
      if (zekerTimeInMinutes >= startSleepHourinMinutes &&
          zekerTimeInMinutes <= endSleepHourinMinutes) {
        exclude = true;
      }
    }

    if (exclude) {
      log("excludeTime : ${zekerTime.toJson()} ");
    }

    return exclude;
  }
}
