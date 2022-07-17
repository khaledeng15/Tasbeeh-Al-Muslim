// import 'dart:convert';
//
// import 'package:tsbeh/utils/PreferenceUtils.dart';
//
//
// class NotificationsClass
// {
//   NotificationsClass(){}
//
//    var waterByHour = 0 ;
//
//
//    NotificationsClass.fromJson(Map<String, dynamic> json)
//        : waterByHour =  json['waterByHour']  ;
//
//
//    Map<String, dynamic> toJson() => {
//      'waterByHour':  waterByHour
//    };
//
//    save()
//    {
//      String json_str =  json.encode( toJson());
//      PreferenceUtils.instance.setString("NotificationsClass",json_str  );
//     }
//
//    static  NotificationsClass get()
//    {
//      String jsonCls = PreferenceUtils.instance.getString("NotificationsClass") ?? "" ;
//      if (jsonCls.isNotEmpty)
//      {
//        Map<String, dynamic> map = json.decode(jsonCls);
//        print(map);
//        NotificationsClass cls = NotificationsClass.fromJson(map);
//        return cls ;
//      }
//      return NotificationsClass();
//    }
//
//   static set({int waterByHour = 0})
//   {
//     NotificationsClass cls = NotificationsClass.get();
//     cls.waterByHour = waterByHour;
//     cls.save();
//   }
//
//
//
//
// }