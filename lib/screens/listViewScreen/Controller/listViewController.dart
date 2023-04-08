import 'package:flutter/cupertino.dart';
import 'package:tsbeh/models/hadesModel.dart';

import '../../../models/AzkarElyomeModel.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/Base/Apis.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import '../../../models/DoaaInQuranModel.dart';
import '../../../models/FirstInIslamHadesModel.dart';
import '../../../models/IslamEventsModel.dart';

class listViewController {
  final Function() refresh;

  listViewController(this.refresh, this.model);

  List<ApiModel> list = [];
  Apis api = Apis();
  final loadMoreController = ScrollController();
  final ApiModel model;

  int page = 1;
  bool isLoading = true;

  String searchTxt = "";
  String categID = "1";
  bool ltr = false;

  void update() {
    refresh();
  }

  Future<void> pullRefresh() async {
    page = 1;
    await getListOnline(false);
  }

  Future<void> onInit() async {
    if (model.subtype == ApiSubType.Open_list_db) {
      isLoading = false;
      getFromDB();
    } else {
      getFromApi();
    }

    update();
  }

  Future<void> getFromDB() async {
    if (model.appModel == AppModel.hades) {
      list = await HadesModel.getMainList();
    } else if (model.appModel == AppModel.firstInIslam) {
      list = await FirstInIslamHadesModel.getList(model.catID);
    } else if (model.appModel == AppModel.doaaInQuran) {
      list = await DoaaInQuranModel.getList();
    } else if (model.appModel == AppModel.azkarElyome) {
      list = await AzkarElyomeModel.getList(categid: model.catID);
    } else if (model.appModel == AppModel.islamEvents) {
      list = await IslamEventsModel.getList(categid: model.catID);
    }

    update();
  }

  void getFromApi() {
    getListOnline(true);

    // loadMoreController.addListener(() {
    //   if (loadMoreController.position.maxScrollExtent ==
    //       loadMoreController.position.pixels) {
    //     if (isLoading == false) {
    //       isLoading = true;
    //       update();

    //       page = page + 1;

    //       getListOnline(true);
    //     }
    //   }
    // });
  }

  void _pullRefresh() {
    // page = 1;
    getListOnline(false);
  }

  Future<void> getListOnline(bool isCaching) async {
    isLoading = true;
    update();

    api.getList(
      url: model.url!,
      page: page,
      isCaching: isCaching,
      cashKey: model.title + "_$page",
      onResult: (lst) {
        isLoading = false;
        list.clear();
        list.addAll(lst);
        update();

        if (page == 1) {
          loadMoreController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }

        if (lst.length == 0) {
          page = page - 1;
          if (page <= 0) {
            page = 1;
          }
        }
      },
    );
  }
}
