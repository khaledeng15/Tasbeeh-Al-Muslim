import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'ApiResponse.dart';
import 'api_exception.dart';
import 'cash/CashLocal.dart';

class HttpClient {
  HttpClient._privateConstructor();

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }

  // late Function(dynamic) onResultData;

  String getkey(String cashKey, String url) {
    String key = "$cashKey-$url";

    return key;
  }

  void request(String path, bool isGet,
      {Map<String, dynamic> body = const {},
      bool isCaching = false,
      String cashKey = "",
      Map<String, String> headers = const {},
      Function(ApiResponse)? onResult,
      required Map<String, dynamic> query}) {
    if (isGet) {
      get(path,
          body: body,
          isCaching: isCaching,
          cashKey: cashKey,
          headers: headers,
          onResult: onResult);
    } else {
      post(path,
          body: body,
          isCaching: isCaching,
          cashKey: cashKey,
          headers: headers,
          onResult: onResult);
    }
  }

  Future<void> get(String path,
      {Map<String, dynamic>? body,
      bool isCaching = false,
      String cashKey = "",
      Map<String, String> headers = const {},
      Function(ApiResponse)? onResult}) async {
    try {
      var url = path;

      if (body != null) {
        if (!url.contains("?")) {
          url = path + "?";
        }
        body.forEach((k, v) {
          url = '$url&$k=$v';
        });
      }

      log("$cashKey con Url GET: $url");

      // ======================================================================
      // check Cash
      if (isCaching == true) {
        final localData = await CashLocal.getStringCash(getkey(cashKey, url));
        if (localData.isNotEmpty) {
          log("$cashKey return Cashed data");
          var res = json.decode(localData);

          Response cashRespone = Response(res, 200);
          onResult!(
              ApiResponse(cashRespone, null, cashRespone.statusCode, true));
          // return res;
        }
        // else {
        //   Response cashRespone = Response("", 200);
        //   return ApiResponse(cashRespone, null, cashRespone.statusCode);
        // }
      }
      // ======================================================================

      // response = await get(path)
      //  ..headers.addAll(req_headers) ;
      var uri = Uri.parse(url);
      var request = Request('GET', uri)
            ..headers.addAll(
                headers) //if u have headers, basic auth, token bearer... Else remove line
          ;

      var bodyJson = jsonEncode(body);
      request.body = bodyJson;
      var response = await request.send();
      // response = await post(path, headers: req_headers,body: bodyJson);
      final respStr = await response.stream.bytesToString();

      log("===================== $cashKey ==============================");
      log("$cashKey con Url: $url");
      log("$cashKey con GET: $bodyJson");
      log("=====================");
      log("$cashKey con response:\n $respStr");
      log("==========================================================");

      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        if (isCaching) {
          CashLocal.removeCacheContains(getkey(cashKey, url));
          CashLocal.saveCash(getkey(cashKey, url), respStr,
              duration: const Duration(hours: DurationHours));
        }

        if (respStr.isEmpty) {
          Response cashRespone = Response("", 200);
          // return ApiResponse(cashRespone, null, cashRespone.statusCode);

          onResult!(
              ApiResponse(cashRespone, null, cashRespone.statusCode, false));
        } else {
          Response cashRespone = Response(respStr, 200);
          // return ApiResponse(cashRespone, null, cashRespone.statusCode);
          onResult!(
              ApiResponse(cashRespone, null, cashRespone.statusCode, false));
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

  Future<void> post(String path,
      {Map<String, dynamic> body = const {},
      bool isCaching = false,
      String cashKey = "",
      Map<String, String> headers = const {},
      Function(ApiResponse)? onResult}) async {
    try {
      var url = path;

      log("$cashKey con Url POST: $url");

      // ======================================================================
      // check Cash
      if (isCaching == true) {
        final localData = await CashLocal.getStringCash(getkey(cashKey, url));
        if (localData.isNotEmpty) {
          log("$cashKey return Cashed data");

          Response cashRespone = Response(localData, 200);
          // return ApiResponse(cashRespone, null, cashRespone.statusCode);
          onResult!(
              ApiResponse(cashRespone, null, cashRespone.statusCode, true));
        }
      }
      // ======================================================================
      Response response;
      var uri = Uri.parse(path);

      String bodyJson = json.encode(body);

      var requestJson = jsonEncode(body);

      var client = http.Client();

      response = await client.post(uri, headers: headers, body: requestJson);

      final respStr = response.body;
      var res = json.decode(respStr);
      log("===================== $cashKey ==============================");
      log("$cashKey con Url: $url");
      log("$cashKey con POST: $bodyJson");
      log("=====================");
      log("$cashKey con response:\n $res");
      log("==========================================================");

      // response = await post(path, headers: req_headers,body: bodyJson);
      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 299) {
        String message = "";

        try {
          message = res?.select("error.message") ?? "";
        } catch (e) {
          message = "";
        }

        if (message.isNotEmpty) {
          onResult!(ApiResponse(response, res, 500, false));
        }

        if (isCaching) {
          CashLocal.removeCacheContains(getkey(cashKey, url));
          CashLocal.saveCash(getkey(cashKey, url), respStr,
              duration: const Duration(hours: DurationHours));
        }
        onResult!(ApiResponse(response, res, response.statusCode, false));
      } else {
        onResult!(ApiResponse(response, res, response.statusCode, false));
      }
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> uploadFile(
      String path, Map<String, String> body, String? image_name, File? image,
      {bool isCaching = false, Map<String, String> headers = const {}}) async {
    // Response response;

    try {
      var url = path;

      // ======================================================================

      String bodyJson = json.encode(body);

      print("con: $url");
      print("con: $bodyJson");

      var uri = Uri.parse(path);

      var request = MultipartRequest('POST', uri)
        ..headers.addAll(
            headers) //if u have headers, basic auth, token bearer... Else remove line
        ..fields.addAll(body);

      if (image != null) {
        var pic = await http.MultipartFile.fromPath(image_name!, image.path);
        request.files.add(pic);
      }

      var response = await request.send();
      // response = await post(path, headers: req_headers,body: bodyJson);
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        final respStr = await response.stream.bytesToString();

        if (isCaching) {
          CashLocal.saveCash("veli-$url-get", respStr,
              duration: const Duration(hours: DurationHours));
        }

        if (respStr.isEmpty) {
          return []; //List<dynamic>();
        } else {
          var res = json.decode(respStr);
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
