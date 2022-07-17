import '../../utils/DartEnumHelperFunctions.dart';

enum ApiType {
  unDefined,
  open

}
enum  ApiSubType {
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
  Zeker
}

class ApiModel  {

   ApiModel();

  late  String itemId  ;
   late  String title  ;
   late  String photo  ;
   late String url  ;
   late String free  ;
   late String html  ;
   late String share  ;
   late String shareUrl  ;
   late String shareTitle  ;
   late  String titleParent = "" ;


   late ApiType type  ;
   late ApiSubType subtype  ;

  static List<ApiModel> fromList(List  data) {
        List<ApiModel> arr = [] ;

        for (int i = 0 ; i < data.length ; i ++)
        {
          ApiModel temp = ApiModel.fromObject(data[i]) ;
          arr.add(temp) ;
        }

      return arr;
   }

    factory  ApiModel.fromObject(Map<String, dynamic> map) {
    var cls = ApiModel();
    cls.itemId = map["itemId"]   ?? "";
    cls.title = map["title"]   ?? "";
    cls.photo = map["photo"]   ?? "";
    cls.url = map["url"]   ?? "";
    cls.free = map["free"]   ?? "";
    cls.html = map["html"]   ?? "";
    cls.share = map["share"]   ?? "";
    cls.shareUrl = map["shareurl"]   ?? "";
    cls.shareTitle = map["sharetitle"]   ?? "";





    String strType =  map["type"]   ?? "unDefined" ;
    String strSubtype=  map["subtype"]   ?? "unDefined" ;

    cls.type = enumFromString<ApiType>(strType,ApiType.values);
     cls.subtype = enumFromString<ApiSubType>(strSubtype,ApiSubType.values);

      return cls;
  }

}