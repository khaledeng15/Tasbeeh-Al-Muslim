import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tsbeh/appRoutes.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../Bloc/AppStates.dart';
import '../../../models/ZekerBuildNotifications/BuildAzkar.dart';
import '../../../models/ZekerBuildNotifications/BuildNotifications.dart';
import '../../../models/zekerModel.dart';

class AzkarController {
  final Function() refresh;

  AzkarController(this.refresh);

  double expandHeight = 350;
  late List<ZekerModel> zekerList = [];
  late List<ZekerModel> selectedZekerList = [];

  BuildAzkar builder = BuildAzkar();
  BuildNotifications buildNotifications = BuildNotifications();

  int selectedSegmentedListType = 0;

  List hours = [];
  List minutes = [];
  late AppCubit cubit;

  void update() {
    refresh();
  }

  Future<void> onInit(BuildContext context) async {
    setupTime();
    ZekerModel.getListOfRepeats(context).then((value) {
      zekerList.addAll(value);
      update();
    });

    selectedZekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);

    update();
  }

  void setupTime() {
    for (var i = 0; i < 60; i++) {
      if (i < 10) {
        minutes.add("0$i");
      } else {
        minutes.add("$i");
      }
    }

    for (var i = 0; i < 24; i++) {
      if (i < 10) {
        hours.add("0$i");
      } else {
        hours.add("$i");
      }
    }
  }

  void segmentedSelected(dynamic val, BuildContext context) {
    if (val == 0) {
      ZekerModel.getListOfRepeats(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    } else if (val == 1) {
      ZekerModel.getListOfazkar(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    } else if (val == 2) {
      ZekerModel.getListOfDoaa(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    } else if (val == 3) {
      ZekerModel.getListOfQuran(context).then((value) {
        zekerList.clear();
        zekerList.addAll(value);
        update();
      });
    }
  }

  void scheduleAzkar(BuildContext context) {
    zekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);
    if (zekerList.length == 0) {
      EasyLoading.showError("من فضلك اختار ذكر اولا");
      return;
    }

    if (builder.everyTime.hours == 0 && builder.everyTime.minutes < 25) {
      EasyLoading.showError("اقل وقت للتذكير ٢٥ دقيقه");
      return;
    }

    buildNotifications.build(builder, context);
    BuildAzkar.play();

    cubit.emit(InitialAppStates());

    AppRoutes.back();
  }
}
