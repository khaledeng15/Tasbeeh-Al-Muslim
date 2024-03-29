import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsbeh/Bloc/AppStates.dart';

import '../models/Base/ApiModel.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of(context);
  List<ApiModel> menuList = [
    buildListHome(
      itemId: "01",
      title: "تسبيح المسلم",
      photo: "zeker.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    buildListHome(
      itemId: "02",
      title: "القران الكريم (صوت)",
      photo: "quran.png",
      url: "https://api.4topapps.com/APPS/tsbeh/v3/mp3Quran_ver2.php",
      type: ApiType.open,
      subType: ApiSubType.Open_list,
      appModel: AppModel.quran,
    ),
    buildListHome(
      itemId: "03",
      title: "ضوتيات",
      photo: "mic.png",
      url: "https://api.4topapps.com/APPS/tsbeh/v3/radio.php",
      type: ApiType.open,
      subType: ApiSubType.Open_radio_list,
      appModel: AppModel.radioList,
    ),
    buildListHome(
      itemId: "04",
      title: "أحاديث نبويه",
      photo: "hades.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.hades,
    ),
    buildListHome(
      itemId: "05",
      title: "الدعاء فى القرآن",
      photo: "doaa.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.doaaInQuran,
    ),
    buildListHome(
      itemId: "06",
      title: "الأوائل",
      photo: "first.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.firstInIslam,
    ),
    buildListHome(
      itemId: "07",
      title: "أذكار اليوم",
      photo: "azkar-elyome.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.azkarElyome,
    ),
    buildListHome(
      itemId: "08",
      title: "الأحداث الاسلامية",
      photo: "events-islam.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.islamEvents,
    ),
    buildListHome(
      itemId: "09",
      title: "محول التقويم",
      photo: "convertdate.png",
      url: "convertdate.html",
      type: ApiType.open,
      subType: ApiSubType.Open_url,
      appModel: AppModel.convertDate,
    ),
    buildListHome(
      itemId: "10",
      title: "عن التطبيق",
      photo: "about.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_about,
      appModel: AppModel.about,
    ),
  ];

  static ApiModel buildListHome(
      {required String itemId,
      required String title,
      required String photo,
      String? url,
      required ApiType type,
      required ApiSubType subType,
      required AppModel appModel}) {
    ApiModel model = ApiModel();
    model.itemId = itemId;
    model.title = title;
    model.url = url;
    model.type = type;
    model.subtype = subType;
    model.appModel = appModel;
    model.photo = photo;

    return model;
  }

  void getHomeData(BuildContext context) async {}
}
