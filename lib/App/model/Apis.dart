

import 'dart:io';

import 'package:tsbeh/utils/connection/http_client.dart';

import 'ApiModel.dart';


const String apiURL = "http://api.4topapps.com/APPS/tsbeh/v3";


class Apis  {

  Apis(
      {
        this.status,
        this.errorMessage});

  final HttpClient _httpClient = HttpClient();

     int? status;

  String? errorMessage = "";

  Map<String, dynamic> response = Map() ;

   fromJson(Map<String, dynamic> json) {
     this.response = json;

     this.status =  json['status']   ?? 0 ;
     this.errorMessage = json['message']   ?? "" ;

  }

  void checkApiStatus(Map<String, dynamic> json)
  {
    this.response = json;

    Map<String, dynamic> meta = json["meta"] ?? 0;

       this.status  = meta["status"] ?? 0;
       this.errorMessage = meta['message']   ?? "" ;

  }

  void checkApiStatus_helpDesk(Map<String, dynamic> json)
  {
    // print(json);

    this.response = json;


    this.status  = json["success"] ?? 0;
    this.errorMessage = json['message']   ?? "" ;

  }

  //========================================================================
  // USer
  //========================================================================
  Future<List<ApiModel>>  menuHome( bool isCaching  ) async {
    try {


      final List  res = await _httpClient.getRequest( apiURL + "/api.php?mod=menu_home",isCaching:isCaching);
      var _menu = ApiModel.fromList(res);
      // this.fromJson(res);


      return _menu;
    } catch (e) {
      print("Could Not Load Data: $e");
      return [];
    }
  }


  Future<List<ApiModel>>  getList( String url,int page, bool isCaching  ) async {
    try {

      Map<String, String> body = <String,String>{
        'page' :page.toString(),

      };

      final List  res = await _httpClient.getRequest( url , bodyFields: body ,isCaching:isCaching);
      var _menu = ApiModel.fromList(res);

      return _menu;
    } catch (e) {
      print("Could Not Load Data: $e");
      return [];
    }
  }

  Future<ApiModel>  getContent( String url, bool isCaching  ) async {
    try {


      final List res = await _httpClient.getRequest( url   ,isCaching:isCaching);
      var _menu = ApiModel.fromObject(res.first);

      return _menu;
    } catch (e) {
      print("Could Not Load Data: $e");
      return ApiModel();
    }
  }












  }























