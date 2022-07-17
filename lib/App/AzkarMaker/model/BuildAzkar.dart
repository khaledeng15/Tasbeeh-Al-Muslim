
import 'dart:convert';

import 'package:tsbeh/App/AzkarMaker/model/zekerModel.dart';

import '../../../utils/PreferenceUtils.dart';
import 'SleepHourClass.dart';
import 'ZekerTime.dart';

class BuildAzkar{

    ZekerTime everyTime = getEveryTime()  ;
    SleepHourClass sleepTime = SleepHourClass.get();

  void  saveEveryTime()
  {
    String jsonStr  = jsonEncode(everyTime);

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


  static saveSelectedZeker(List<ZekerModel> lst)
  {
    String jsonStr  = jsonEncode(lst);

    PreferenceUtils.instance.setString("selectedZeker", jsonStr);
  }

  static List<ZekerModel>  getSelectedZeker() {
    String jsonCls = PreferenceUtils.instance.getString("selectedZeker") ?? "";
    if (jsonCls.isNotEmpty) {
      List  lst = json.decode(jsonCls);

      return ZekerModel.fromList(lst);
    }
    return [];
  }

}