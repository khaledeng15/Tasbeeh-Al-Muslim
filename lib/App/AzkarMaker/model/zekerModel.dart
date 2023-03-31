import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:timezone/timezone.dart' as tz;

 
class ZekerModel {
  ZekerModel();

  late String zeker_id;
  late String zeker_type;
  late String zeker_name;
  late String zeker_repeat;
  late String zeker_time;
  late int zeker_order;

  late bool selected = false;
  late String choose_repeat = "1";

  String? fullFileName;

// Notfication option
late String channelID ;
late String channelName ;
late String channelDescription;
late int notficationId;
late  String notficationTitle;
late String notficationBody;
late tz.TZDateTime notficationScheduledDate;
  

  String soundFileName() {
    var fileName = "";
    if (zeker_repeat.isEmpty) {
      fileName = zeker_id;
    } else {
      fileName = "${zeker_id}_1";
    }

    return "a$fileName";
  }

  String soundFileNamePath() {  
    var fileName = soundFileName();
    return "assets/$fileName.mp3";
  }

  static Future<List<ZekerModel>> getListOfRepeats(BuildContext context) async {
    return getList(context, "zeker_1repeat");
  }

  static Future<List<ZekerModel>> getListOfazkar(BuildContext context) async {
    return getList(context, "zeker_2azkar");
  }

  static Future<List<ZekerModel>> getListOfDoaa(BuildContext context) async {
    return getList(context, "zeker_3doaa");
  }

  static Future<List<ZekerModel>> getListOfQuran(BuildContext context) async {
    return getList(context, "zeker_4quran");
  }

  static Future<List<ZekerModel>> getList(
      BuildContext context, String fileName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/$fileName.json");
    final jsonResult = jsonDecode(data);

    return ZekerModel.fromList(jsonResult);
  }

  static List<ZekerModel> fromList(List data) {
    List<ZekerModel> arr = [];

    for (int i = 0; i < data.length; i++) {
      ZekerModel temp = ZekerModel.fromJson(data[i]);
      arr.add(temp);
    }

    return arr;
  }

  factory ZekerModel.fromJson(Map<String, dynamic> map) {
    var cls = ZekerModel();
    cls.zeker_id = map["zeker_id"] ?? "";
    cls.zeker_type = map["zeker_type"] ?? "";
    cls.zeker_name = map["zeker_name"] ?? "";
    cls.zeker_repeat = map["zeker_repeat"] ?? "";
    cls.zeker_time = map["zeker_time"] ?? "";
    cls.zeker_order = map["zeker_order"] ?? 1000;
    cls.choose_repeat = map["choose_repeat"] ?? "1";
    cls.selected = map["selected"] ?? false;

    return cls;
  }

  Map<String, dynamic> toJson() => {
        'zeker_id': zeker_id,
        'zeker_type': zeker_type,
        'zeker_name': zeker_name,
        'zeker_repeat': zeker_repeat,
        'zeker_time': zeker_time,
        'zeker_order': zeker_order,
        'choose_repeat': choose_repeat,
        'selected': selected,
      };
}
