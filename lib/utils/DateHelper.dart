
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ProKitLib/main/utils/AppConstant.dart';



class DateHelper
{
  static  String  niceDate(String  dt ,String formate,BuildContext context)
  {
    String languageCode = Localizations.localeOf(context).languageCode;

    DateTime tempDate = new DateFormat(formate).parse(dt);

    return DateFormat('EEEE, d MMM, yyyy',languageCode).format(tempDate);

  }

  static TimeOfDay stringToTimeOfDay(String tod) {

    return TimeOfDay(hour:int.parse(tod.split(":")[0]),minute: int.parse(tod.split(":")[1]));
  }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }


  static int difTimeStampInDays(int timeStamp1,int timeStamp2)
  {
    var date1 = new DateTime.fromMillisecondsSinceEpoch(timeStamp1);
    var date2 = new DateTime.fromMillisecondsSinceEpoch(timeStamp2);

    final difference = date2.difference(date1).inDays;


    return difference;
  }


  static String toStringDate(DateTime date)
  {
     return DateFormat(dateFormat).format(date);

  }
  static DateTime toDate(String dateString,String format)
  {
    return DateFormat(format).parse(dateString);

  }

}