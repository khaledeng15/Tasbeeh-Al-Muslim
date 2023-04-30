import '../../helper/DartEnumHelperFunctions copy.dart';

enum AppModel {
  radioList,
  quran,
  zeker,
  hades,
  doaaInQuran,
  firstInIslam,
  azkarElyome,
  islamEvents,
  convertDate,
  about,
  unDefined
}

enum ApiType { unDefined, open }

enum ApiSubType {
  unDefined,
  open,
  Open_list,
  Open_view,
  Open_url,
  Open_about,
  Open_alert,
  Open_twitter,
  Open_facebookpage,
  Open_buy,
  Open_email,
  Open_share,
  Open_radio,
  Open_radio_list,
  Open_sound,
  Zeker,
  Open_list_db
}

enum ApiReadFrom { api, database, unDefined }

class ApiModel {
  ApiModel();
  // ApiModel({Map<String, dynamic>? data}) {
  //   if (data != null) {
  //     map = data;
  //     ApiModel.fromObject(data);
  //   }
  // }

  Map<String, dynamic> map = {};

  int? catID;

  late String itemId;

  String title = "";

  late String photo;

  late String? url;

  late String free;

  late String html;

  late String share;

  late String shareUrl;

  late String shareTitle;

  late String description;

  late ApiType type;

  late ApiSubType subtype;

  ApiReadFrom? readFrom;

  late AppModel appModel;

  late String titleParent = "";

  static List<ApiModel> fromList(List data,
      {ApiType? type,
      ApiSubType? subtype,
      ApiReadFrom? readFrom,
      AppModel? appModel}) {
    List<ApiModel> arr = [];

    for (int i = 0; i < data.length; i++) {
      ApiModel cls = ApiModel.fromObject(data[i],
          type: type, subtype: subtype, readFrom: readFrom, appModel: appModel);
      // Map<String, dynamic> temp = Map.from(data[i]);

      // if (type != null) {
      //   temp["type"] = enumToString(type);
      // }
      // if (subtype != null) {
      //   temp["subtype"] = enumToString(subtype);
      // }
      // if (readFrom != null) {
      //   temp["readFrom"] = enumToString(readFrom);
      // }
      // if (appModel != null) {
      //   temp["appModel"] = enumToString(appModel);
      // }

      // ApiModel cls = ApiModel(data: temp);
      arr.add(cls);
    }

    return arr;
  }

  factory ApiModel.fromObject(Map<String, dynamic> map,
      {ApiType? type,
      ApiSubType? subtype,
      ApiReadFrom? readFrom,
      AppModel? appModel}) {
    var cls = ApiModel();
    cls.itemId = map["itemId"] ?? "";
    cls.catID = map["catID"] ?? 0;

    cls.title = map["title"] ?? "";
    cls.photo = map["photo"] ?? "";
    cls.url = map["url"] ?? "";
    cls.free = map["free"] ?? "";
    cls.html = map["html"] ?? "";
    cls.share = map["share"] ?? "";
    cls.shareUrl = map["shareurl"] ?? "";
    cls.shareTitle = map["sharetitle"] ?? "";
    cls.description = map["description"] ?? "";

    if (readFrom != null) {
      cls.readFrom = readFrom;
    }

    if (appModel != null) {
      cls.appModel = appModel;
    }

    if (type != null) {
      cls.type = type;
    } else {
      String strType = map["type"] ?? "unDefined";
      cls.type = enumFromString<ApiType>(strType, ApiType.values);
    }

    if (subtype != null) {
      cls.subtype = subtype;
    } else {
      String strSubtype = map["subtype"] ?? "unDefined";

      cls.subtype = enumFromString<ApiSubType>(strSubtype, ApiSubType.values);
    }

    return cls;
  }
}
