import 'package:flutter/cupertino.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import 'Base/ApiModel.dart';

class DoaaInQuranModel extends ApiModel {
  DoaaInQuranModel();

  static Future<List<ApiModel>> getList({int? categid}) async {
    String sql = "";
    ApiSubType openScreen = ApiSubType.Open_view;

    sql = """
        select CAST(id AS VARCHAR(10)) as itemId,  title from doaaquran 
     """;

    final db = await dbSQLiteProvider.db.database;

    List<Map> results = await db.rawQuery(sql);

    List<ApiModel> lst = ApiModel.fromList(results,
        type: ApiType.open,
        subtype: openScreen,
        appModel: AppModel.doaaInQuran,
        readFrom: ApiReadFrom.database);

    return lst;
  }

  static Future<ApiModel> getrow(int id) async {
    String sql = """
                 select CAST(id AS VARCHAR(10)) as itemId,  title from doaaquran  where id=$id   
     """;
    final db = await dbSQLiteProvider.db.database;

    List<Map<String, dynamic>> results = await db.rawQuery(sql);

    return ApiModel(data: results.first);
  }
}
