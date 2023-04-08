
import 'package:flutter/cupertino.dart';
 
import 'package:intl/intl.dart';


 import '../../main.dart';
import 'NotificationService.dart';

import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {

  BuildContext context;

  LocalNotifications(this.context);


  late int noNotificationEveryMinutes ;
  late int startMinutes ;
  late int endMinutes ;

  var dayMinutes = 1440 ;
  var halfDay = 1440 / 2 ;

  int notifyHimAfter = 10 ;

  void repeatWaterNotifications()
  {
     // var notify = NotificationsClass.get();

     // var service = NotificationService() ;
     //   noNotificationEveryMinutes = notify.waterByHour ;
     //
     // service.cancelAll();


     if (noNotificationEveryMinutes != 0)
     {

        //  var sleep = SleepHourClass.get() ;
        //   startMinutes = sleep.startTime[0] * 60 + sleep.startTime[1];
        //   endMinutes = sleep.endTime[0] * 60 + sleep.endTime[1];
        //
        //  noNotificationEveryMinutes = noNotificationEveryMinutes * 60 ;
        //
        // if (startMinutes > halfDay && endMinutes < halfDay ) // tow days
        // {
        //   inTwoDays();
        // }
        // else
        // {
        //   inSameDay() ;
        // }


     }



  }

  void inTwoDays()
  {
    int startInterval = endMinutes;
    int diff = startMinutes - endMinutes ;

    int interval = diff  ~/  noNotificationEveryMinutes ;


    var newStartTime = endMinutes ;
    for (var i = 0; i < interval; i++) {
      if (i == 0)
      {
        newStartTime = startInterval + notifyHimAfter ; // notify him after wack up with 10 Minutes
      }
      else
      {
        newStartTime = newStartTime  + noNotificationEveryMinutes ;
      }

      if (newStartTime <= startMinutes)
      {
        addNotification(i,newStartTime);

      }

    }

  }
  void inSameDay()
  {

    // notify for firstInterval
    addFirstInterval() ;
    addSecondInterval();

  }

  void addFirstInterval()
  {
    print( "FirstInterval: " + tz.TZDateTime.now(tz.local).toString());


    int startInterval = 0 + startMinutes ;

    int interval = startInterval  ~/  noNotificationEveryMinutes ;


    var newStartTime = 0 ;
    for (var i = 0; i < interval; i++) {
      if (i == 0)
      {
        newStartTime = 0  + notifyHimAfter ; // notify him after wack up with 10 Minutes
      }
      else
      {
        newStartTime = newStartTime  + noNotificationEveryMinutes ;
      }

      if (newStartTime <= endMinutes)
      {
        addNotification(i,newStartTime);

      }

    }
  }

  void addSecondInterval()
  {
    print( "SecondInterval: " + tz.TZDateTime.now(tz.local).toString());

    int startInterval = dayMinutes - endMinutes ;

    int interval = startInterval  ~/  noNotificationEveryMinutes ;


    var newStartTime = endMinutes ;
    for (var i = 0; i < interval; i++) {

        newStartTime = newStartTime  + noNotificationEveryMinutes ;

      if (newStartTime <= dayMinutes)
      {
        addNotification(i,newStartTime);

      }

    }
  }

  void addNotification(int id,int diffMinutes)
  {


    // int timeStamp = DateTime.now().millisecondsSinceEpoch ;
    tz.TZDateTime scheduledDate =  getDate(); //tz.TZDateTime.now(tz.local) ;//.add( Duration(minutes: diffMinutes)) ;


    // scheduledDate = tz.TZDateTime
    scheduledDate = scheduledDate.add( Duration(minutes: diffMinutes)) ;

    // NotificationService().scheduleLocalNotifications(id, "Water" ,  "It's time to drink water" ,scheduledDate ) ;


    print(scheduledDate);
  }

  tz.TZDateTime getDate()
  {
    var currentDate =  DateFormat(dateFormat).format( DateTime.now());

    final DateTime tempDate = new DateFormat(dateFormat).parse(currentDate);

    tz.TZDateTime scheduledDate =  tz.TZDateTime.from(tempDate, tz.local) ;

    return  scheduledDate ;
  }

}