import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsbeh/App/AzkarMaker/model/zekerModel.dart';

//  import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:intl/intl.dart';
import '../../Notifications/Local/NotificationService.dart';
import 'BuildAzkar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'PermissionsNotifications.dart';
import 'notification_util.dart';

class BuildNotifications {

  PermissionsNotifications permissionsNotifications = PermissionsNotifications();


  Future<void> build(BuildAzkar bz,BuildContext context) async {

    await permissionsNotifications.check(context) ;
    bool allowed = permissionsNotifications.globalNotificationsAllowed ;
    if(allowed)
      {
        // createBuild(bz);
        AwesomeNotifications().cancelAll();
        addNotification(0, 1,"res_morph_power_rangers", "res_morph_power_rangers") ;

      }
  }

 static Future<void> createBuild(BuildAzkar bz) async {



       List azkarList = BuildAzkar.getSelectedZeker() ;

       int fileCursor =0;
       int countarr = azkarList.length;

       int totalMinutes = bz.everyTime.hours * 60 + bz.everyTime.minutes;
       double unit = 0;
       // DateTimeComponents repeatInterval = DateTimeComponents.time;

       if (totalMinutes < 60) {
         unit = 60 / totalMinutes;
         // repeatInterval =   DateTimeComponents.dateAndTime; //NSCalendarUnitHour | NSCalendarUnitMinute ;
       } else {
         unit = 24 / bz.everyTime.hours;
         // repeatInterval = DateTimeComponents.dayOfWeekAndTime; //NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute  ;
       }

       addNotification(0, 1,"res_morph_power_rangers", "res_morph_power_rangers") ;

       return;
       int hourNotif = 0;
       int minuteNotif = 0;

       for (int i = 0; i < unit; i++) {
         if (totalMinutes < 60) {
           hourNotif = hourNotif + bz.everyTime.hours;
           minuteNotif = minuteNotif + bz.everyTime.minutes;

           if (minuteNotif > 60) {
             minuteNotif = bz.everyTime.minutes;
           }
         } else {
           hourNotif = hourNotif + bz.everyTime.hours;
           minuteNotif = bz.everyTime.minutes;
         }

         if (hourNotif == 24) {
           hourNotif = 0;
         }

         if (minuteNotif == 60) {
           minuteNotif = 0;
         }

         if (excludeTime(hourNotif, minuteNotif) == false) {
           ZekerModel temp = azkarList[fileCursor] ;
           fileCursor = fileCursor +1;
           if (fileCursor > countarr -1) {
             fileCursor = 0;
           }

           String zeker_id = temp.zeker_id ;
           String newfilename =  "a$zeker_id" ;
           if (temp.choose_repeat.isEmpty == false && temp.zeker_repeat.isEmpty == false)
           {
             int chooseRepeat = int.parse( temp.choose_repeat) ;
             int filerepeat = int.parse(temp.zeker_repeat);

             if (filerepeat < chooseRepeat) {
               chooseRepeat = filerepeat;
             }

             newfilename = "a$zeker_id" "_" "$chooseRepeat" ;

           }


           // addNotification(0, (hourNotif * 60) + minuteNotif,newfilename,temp.zeker_name,repeatInterval) ;


         }


       }

       print("finsh");



  }

 static Future<void> addNotification(int id,int diffMinutes,String fileName,String title ) async {
   String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
   String utcTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

   await AwesomeNotifications().createNotification(
       content: NotificationContent(
           id: id,
           channelKey: PermissionsNotifications.channelKey,
           title: 'Notification at every single minute',
           body:
           'This notification was schedule to repeat at every single minute.',
           fullScreenIntent:true,
           // customSound:'resource://raw/res_morph_power_rangers'
           // customSound:'resource://raw/res_morph_power_rangers.m4a',

         notificationLayout: NotificationLayout.BigPicture,
           bigPicture: 'asset://images/app/cover.jpg'
       ),
       schedule: NotificationInterval(interval: 60, timeZone: localTimeZone, repeats: true));

 }

  //  static Future<void> addNotification(int id,int diffMinutes,String fileName,String title ,DateTimeComponents repeatInterval)
  // async {
  //
  //
  //
  //   int timeStamp = DateTime.now().millisecondsSinceEpoch ;
  //   tz.TZDateTime scheduledDate =  getDate(); //tz.TZDateTime.now(tz.local) ;//.add( Duration(minutes: diffMinutes)) ;
  //
  //
  //   // scheduledDate = tz.TZDateTime;
  //   scheduledDate = scheduledDate.add( Duration(minutes: diffMinutes)) ;
  //
  //    NotificationService().scheduleLocalNotifications(id, "تسبيح المسلم" ,  title ,scheduledDate ,repeatInterval,fileName) ;
  //
  //
  //   print( "$scheduledDate =>> $fileName");
  // }

 // static tz.TZDateTime getDate()
 //  {
 //    var currentDate = DateFormat("dd/MM/yyy").format( DateTime.now());
 //
 //    final DateTime tempDate = new DateFormat("dd/MM/yyy").parse(currentDate);
 //
 //
 //    tz.TZDateTime scheduledDate =  tz.TZDateTime.from(tempDate, tz.local) ;
 //
 //    return  scheduledDate ;
 //  }

 static bool excludeTime(int hour, int minutes) {
    return false;
  }



}
