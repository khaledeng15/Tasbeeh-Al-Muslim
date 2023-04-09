import 'package:nb_utils/nb_utils.dart';

import '../../../helper/html/HtmlToMarkdown.dart';
import '../../../models/AzkarElyomeModel.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/DoaaInQuranModel.dart';
import '../../../models/FirstInIslamHadesModel.dart';
import '../../../models/HadesModel.dart';
import '../../../models/IslamEventsModel.dart';

class ViewController {
  final Function() refresh;

  ViewController(this.refresh, this.model);
  final ApiModel model;
  String txt = "";

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    if (model.readFrom == ApiReadFrom.database) {
      await readFromDB();

      txt = HtmlToMarkdown().convert(model.html);
    }

    update();
  }

  Future<void> readFromDB() async {
    if (model.appModel == AppModel.hades) {
      ApiModel modelDB = await HadesModel.getrow(model.itemId.toInt());
      model.html = modelDB.html;
    } else if (model.appModel == AppModel.firstInIslam) {
      ApiModel modelDB =
          await FirstInIslamHadesModel.getrow(model.itemId.toInt());
      model.html = modelDB.title;
    } else if (model.appModel == AppModel.doaaInQuran) {
      ApiModel modelDB = await DoaaInQuranModel.getrow(model.itemId.toInt());
      model.html = modelDB.title;
    } else if (model.appModel == AppModel.azkarElyome) {
      ApiModel modelDB = await AzkarElyomeModel.getrow(model.itemId.toInt());
      model.html = modelDB.title;
    } else if (model.appModel == AppModel.islamEvents) {
      ApiModel modelDB = await IslamEventsModel.getrow(model.itemId.toInt());
      model.html = modelDB.html;
    }
  }
}
