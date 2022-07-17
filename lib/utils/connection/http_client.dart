import 'dart:async';
import 'dart:convert';
import 'dart:io';

 import 'package:tsbeh/utils/connection/cash/IFileManager.dart';
import 'package:tsbeh/utils/connection/cash/local_file.dart';
import 'package:http/http.dart';
import 'package:tsbeh/utils/connection/api_exception.dart';
import 'package:tsbeh/utils/constants.dart';

import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;



class HttpClient {
  HttpClient._privateConstructor();

  static const int DurationHours = 24 ;

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }


  IFileManager fileManager  = LocalFile();


  Future<String> getLocalData(String url) async {
    final data = await fileManager.getUserRequestDataOnString(url);
    return data;
  }

  Future<dynamic> getRequest(String path, {Map<String, dynamic>? bodyFields , bool isCaching = false}) async {

    try {
      var url = path  ;

      if (bodyFields != null)
      {
        if (!url.contains("?"))
        {
          url = path + "?";

        }
        bodyFields.forEach((k,v)
        {
           url = '$url&$k=$v';
        });

      }

       // ======================================================================
      // check Cash
      if (isCaching  == true)
      {

        final localData = await getLocalData(url);
        if (localData != null && localData.isNotEmpty) {
          if (localData.isEmpty) {
            return []; //List<dynamic>();
          } else {
            print("con: Cashed");

            var res =  json.decode(localData );
            return res;
          }
        }
      }
      // ======================================================================

      print("con: $url" ) ;

      // response = await get(path)
      //  ..headers.addAll(req_headers) ;
      var uri = Uri.parse(url);
      var request = MultipartRequest('GET', uri)
        ..headers.addAll(req_headers) //if u have headers, basic auth, token bearer... Else remove line
        ;


      var response  = await request.send();
      // response = await post(path, headers: req_headers,body: bodyJson);
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        final respStr = await response.stream.bytesToString();

        if (isCaching) fileManager.writeUserRequestDataWithTime(url, respStr, Duration(hours: DurationHours));

        if (respStr.isEmpty) {
          return []; //List<dynamic>();
        } else {

          var res =  json.decode(respStr );

          return res;
        }
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      } else if (statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      } else {
        throw UnknownException();
      }

    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> postRequest(String path, Map<String, String> body , { String? image_name  , File? image  , bool isCaching = false}) async {
    // Response response;

    try {
      var url = path  ;

      // ======================================================================
      // check Cash
      if (isCaching  == true)
      {
        final localData = await getLocalData(url);
        if (localData != null && localData.isNotEmpty) {
          if (localData.isEmpty) {
            return []; //List<dynamic>();
          } else {
            var res =  json.decode(localData );
            return res;
          }
        }
      }
      // ======================================================================


      String bodyJson = json.encode(body);

      print("con: $url" ) ;
      print("con: $bodyJson" ) ;

      var uri = Uri.parse(path);

      var request = MultipartRequest('POST', uri)
        ..headers.addAll(req_headers) //if u have headers, basic auth, token bearer... Else remove line
        ..fields.addAll(body);



      if (image != null)
        {
          var pic = await http.MultipartFile.fromPath(image_name!, image.path);
          request.files.add(pic);

        }




      var response  = await request.send();
      // response = await post(path, headers: req_headers,body: bodyJson);
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        final respStr = await response.stream.bytesToString();

        if (isCaching) fileManager.writeUserRequestDataWithTime("veli-$url-get", respStr, Duration(hours: DurationHours));


        if (respStr.isEmpty) {
          return [] ;//List<dynamic>();
        } else {

          var res =  json.decode(respStr );
          // print("con: $res" ) ;

          return res;
        }
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      } else if (statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      } else {
        throw UnknownException();
      }
    } on SocketException {
      throw ConnectionException();
    }
  }
}
