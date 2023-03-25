import 'dart:convert';

import 'package:tsbeh/App/AzkarMaker/model/zekerModel.dart';

import '../../../utils/PreferenceUtils.dart';
import 'SleepHourClass.dart';
import 'ZekerTime.dart';

enum zekerListFor { selected, createdChanel }

class BuildAzkar {
  ZekerTime everyTime = getEveryTime();
  SleepHourClass sleepTime = SleepHourClass.get();

  static void play() {
    PreferenceUtils.instance.setBool("ZekerPlay", true);
  }

  static void stop() {
    PreferenceUtils.instance.setBool("ZekerPlay", false);
  }

  static bool isPlay() {
    return PreferenceUtils.instance.getBool("ZekerPlay") ?? false;
  }

  void saveEveryTime() {
    String jsonStr = jsonEncode(everyTime);

    PreferenceUtils.instance.setString("ZekerTime", jsonStr);
  }

  static ZekerTime getEveryTime() {
    String jsonCls = PreferenceUtils.instance.getString("ZekerTime") ?? "";
    if (jsonCls.isNotEmpty) {
      Map<String, dynamic> map = json.decode(jsonCls);

      return ZekerTime.fromJson(map);
    }
    return ZekerTime();
  }

  static saveZekerListFor(List<ZekerModel> lst, zekerListFor key) {
    String jsonStr = jsonEncode(lst);

    PreferenceUtils.instance.setString(key.toString(), jsonStr);
  }

  static List<ZekerModel> getZekerListFor(zekerListFor key) {
    String jsonCls = PreferenceUtils.instance.getString(key.toString()) ?? "";
    if (jsonCls.isNotEmpty) {
      List lst = json.decode(jsonCls);

      return ZekerModel.fromList(lst);
    }
    return [];
  }
}
