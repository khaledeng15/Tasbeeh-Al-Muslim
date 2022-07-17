

 import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
 import 'package:timeago/timeago.dart' as timeago;

   String todayDate() {
 var now = new DateTime.now();
 var formatter = new DateFormat("yyyy-MM-dd hh:mm:ss");
 String formattedDate = formatter.format(now);
 print(formattedDate);

 return  formattedDate;
 }
Future<void> saveImage(File imageFile,String storeName) async
{

// getting a directory path for saving
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2

// copy the file to a new path
  final File newImage = await imageFile.copy('$appDocumentsPath/$storeName');

}

 Future<String> getImage(String storeName) async
 {

// getting a directory path for saving
   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
   String appDocumentsPath = appDocumentsDirectory.path; // 2

    return  '$appDocumentsPath/$storeName' ;

 }
 Future<File?> fileImage(String storeName) async
 {


   String path = await getImage(storeName);
   File f = File(path);
   if(f.existsSync())
     {
       return  File(path) ;

     }
   else
     {
       return null;
     }

 }

 Future<String> getPath() async
 {

// getting a directory path for saving
   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
   String appDocumentsPath = appDocumentsDirectory.path; // 2

   return  appDocumentsPath ;

 }


 int get_key_int(Object value)
{
    if (value is int)
      {
        return value as int   ;
      }
    else if (value is double)
      {
        return  value.toInt();
      }
     else
       {
         String  val = value as String? ?? "";
          if (val.isEmpty)
           {
             return 0 ;
           }

         return double.parse(val).toInt() ;
       }
}

 double get_key_double(Object value)
 {
   if (value is int)
   {
     return value.toDouble()   ;
   }
   else if (value is double)
   {
     return  value ;
   }
   else
   {
     String  val = value as String? ?? "";
     if (val.isEmpty)
     {
       return 0 ;
     }

     return double.parse(val)  ;
   }
 }


 String get_key_str(Object value)
 {
   if (value is int)
   {
     return value.toString() ;
   }
   else
   {
     return  value as String  ;
   }
 }


 ImageProvider? getImageProvider(String path) {

  if (path.startsWith("res/"))
    {
      return AssetImage(path);
    }
  else
    {
      File f = File(path);

      if (f.existsSync())
      {
         return FileImage(f) ;
      }
      else
        {
          return  const AssetImage('res/images/no_photo.png');
        }
      // return f.existsSync()
      //     ? FileImage(f)
      //     : const AssetImage('res/images/no_photo.png');
    }




 }


 String  getTimeAgo(String created_at,String lang)
 {

   DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(created_at,true); // time in etd

   // print(tempDate);
   tempDate = tempDate.add(Duration( hours: 5)); // time in utc
    // print(tempDate);
   tempDate = tempDate.toLocal() ;
   // print(tempDate);
   // timeago.setLocaleMessages('ar', timeago.ArMessages());

      if (lang == "ar")
       {
         print("lang:" +lang);
         return timeago.format( tempDate ,locale:"ar");

       }
     else
       {
         return timeago.format( tempDate ,locale:"en");

       }

 }


