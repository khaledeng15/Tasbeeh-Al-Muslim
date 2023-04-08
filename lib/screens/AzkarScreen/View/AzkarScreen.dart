import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/main.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../Bloc/AppStates.dart';
import '../../../models/ZekerBuildNotifications/BuildAzkar.dart';
import '../../../models/ZekerBuildNotifications/SleepHourClass.dart';
import '../../../models/zekerModel.dart';
import '../Controller/AzkarController.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  AzkarScreenState createState() => AzkarScreenState();
}

class AzkarScreenState extends State<AzkarScreen>
    with SingleTickerProviderStateMixin {
  late AzkarController _controller;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = AzkarController(refresh);
    _controller.onInit(context);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          _controller.cubit = AppCubit.get(context);

          return body();
        });
  }

  Widget body() {
    return Scaffold(
      appBar: AppBar(title: Text("الاذكار")),
      body: list(),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 45),
              ),
              child: Text(
                "تشغيل الاذكار",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _controller.scheduleAzkar(context);
              },
            ),
          );
        },
        onClosing: () {},
      ),
    );
  }

  Widget list() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 70),
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(children: [
              16.height,
              setting(),
              16.height,
              categoryAzkarSegmented(),
              16.height,
              azkarList(),
              16.height,
            ]),
          )),
    );
  }

  Widget setting() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Text(
        "تحديد أوقات الأذكار",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary),
      ),
      SizedBox(height: 10),
      Card(
          child: Padding(
              padding: EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  pickerTimeEveryBottomSheet(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("تشغيل الذكر كل"),
                    Expanded(
                      child: Text(
                        "${_controller.builder.everyTime.hours}:${_controller.builder.everyTime.minutes}",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const Icon(Icons.arrow_right, size: 30, color: Colors.grey),
                  ],
                ),
              ))),
      SizedBox(height: 10),
      Card(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await SleepHourClass.showTimeRange(context);
                  _controller.builder.sleepTime = SleepHourClass.get();
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoSwitch(
                      value: _controller.builder.sleepTime.stopAt,
                      onChanged: (bool val) {
                        _controller.builder.sleepTime.stopAt =
                            !_controller.builder.sleepTime.stopAt;
                        _controller.builder.sleepTime.save();
                        setState(() {});
                      },
                    ),
                    10.width,
                    Text("ايقاف الذكر فى   "),
                    Expanded(
                        child: Text(
                      "${_controller.builder.stopTimeFormate()}",
                      textAlign: TextAlign.left,
                    )),
                    const Icon(Icons.arrow_right, size: 30, color: Colors.grey),
                  ],
                ),
              ))),
      SizedBox(height: 20)
    ]);
  }

  Future<void> pickerTimeEveryBottomSheet(context) async {
    int selectedHours = _controller.builder.everyTime.hours;
    int selectedMinutes = _controller.builder.everyTime.minutes;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 350,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الغاء',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary))
                        .onTap(() {
                      finish(context);
                      // toasty(context, 'Please select value');
                      setState(() {});
                    }),
                    Text('موافق',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary))
                        .onTap(() {
                      if (selectedHours == 0 && selectedMinutes < 25) {
                        EasyLoading.showInfo("اقل وقت للتذكير هو ٢٥ دقيقه",
                            duration: Duration(seconds: 5));
                      } else {
                        _controller.builder.everyTime.hours = selectedHours;
                        _controller.builder.everyTime.minutes = selectedMinutes;
                        _controller.builder.saveEveryTime();
                        finish(context);

                        setState(() {});
                      }
                    }),
                  ],
                ).paddingAll(8.0),
              ),
              20.height,
              SizedBox(
                  height: 30,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text("ساعه",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("دقيقه",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))
                      ])),
              SizedBox(
                  height: 200,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem:
                                    _controller.builder.everyTime.hours),

                            // backgroundColor: context.scaffoldBackgroundColor,
                            itemExtent: 35,

                            children: _controller.hours.map((e) {
                              return Text(e, style: TextStyle(fontSize: 20));
                            }).toList(),
                            onSelectedItemChanged: (int val) {
                              // selectedValue = countryName[val];
                              selectedHours = val;
                            },
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem:
                                    _controller.builder.everyTime.minutes),
                            // backgroundColor: context.scaffoldBackgroundColor,
                            itemExtent: 35,
                            children: _controller.minutes.map((e) {
                              return Text(e, style: TextStyle(fontSize: 20));
                            }).toList(),
                            onSelectedItemChanged: (int val) {
                              // selectedValue = countryName[val];
                              selectedMinutes = val;
                            },
                          ),
                        )
                      ])),
            ],
          ),
        );
      },
    );
  }

  Widget categoryAzkarSegmented() {
    final Map<int, Widget> sWidget = <int, Widget>{
      0: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("اذكار مع تكرار",
              style: primaryTextStyle(
                  color: _controller.selectedSegmentedListType == 0
                      ? white
                      : Theme.of(context).colorScheme.primary,
                  size: 12))),
      1: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("اذكار",
              style: primaryTextStyle(
                  color: _controller.selectedSegmentedListType == 1
                      ? white
                      : Theme.of(context).colorScheme.primary,
                  size: 12))),
      2: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("دعاه",
              style: primaryTextStyle(
                  color: _controller.selectedSegmentedListType == 2
                      ? white
                      : Theme.of(context).colorScheme.primary,
                  size: 12))),
      3: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("أيات قرانيه",
              style: primaryTextStyle(
                  color: _controller.selectedSegmentedListType == 3
                      ? white
                      : Theme.of(context).colorScheme.primary,
                  size: 12)))
    };
    return Container(
        // color: appStore.appBarColor,
        child: CupertinoSegmentedControl(
      borderColor: Theme.of(context).colorScheme.secondary,
      selectedColor: Theme.of(context).colorScheme.primary,
      groupValue: _controller.selectedSegmentedListType,
      onValueChanged: (dynamic val) {
        _controller.selectedSegmentedListType = val;

        _controller.segmentedSelected(val, context);
      },
      children: sWidget,
    ));
  }

  Widget azkarList() {
    return Column(
      children: List.generate(_controller.zekerList.length, (index) {
        var num = index + 1;
        return cellList(num, index);
      }),
    );
  }

  Widget cellList(int num, int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    cellCheckBox(index),
                    10.width,
                    Text(
                      _controller.zekerList[index].zeker_name,
                      style: boldTextStyle(color: textPrimaryColorGlobal),
                      // maxLines: 1,
                      overflow: TextOverflow.visible,
                    ).expand(),
                    10.width,
                    cellPlayAudio(index),
                  ],
                ),
              ),
              segmentedCell(_controller.zekerList[index]),
              16.height,
            ],
          )),
    );
  }

  Widget segmentedCell(ZekerModel zeker) {
    if (_controller.selectedSegmentedListType != 0) {
      return Container();
    }

    var estateSelected = zeker;
    var estateSelectedIndex = _controller.selectedZekerList
        .indexWhere((elment) => elment.zeker_id == zeker.zeker_id);
    if (estateSelectedIndex != -1) {
      estateSelected = _controller.selectedZekerList[estateSelectedIndex];
    }
    if (estateSelected.choose_repeat.isEmpty) {
      estateSelected.choose_repeat = "1";
    }

    int selectedValue = estateSelected.choose_repeat.toInt();

    final Map<int, Widget> sWidget = <int, Widget>{
      1: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("مره واحده",
              style: primaryTextStyle(
                  color: selectedValue == 1
                      ? white
                      : Theme.of(context).colorScheme.secondary,
                  size: 12))),
      2: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("مرتان",
              style: primaryTextStyle(
                  color: selectedValue == 2
                      ? white
                      : Theme.of(context).colorScheme.secondary,
                  size: 12))),
      3: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("ثلاث مرات",
              style: primaryTextStyle(
                  color: selectedValue == 3
                      ? white
                      : Theme.of(context).colorScheme.secondary,
                  size: 12)))
    };
    return Container(
        // color: appStore.appBarColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
          Text("التكرار"),
          CupertinoSegmentedControl(
            borderColor: Theme.of(context).colorScheme.secondary,
            selectedColor: Theme.of(context).colorScheme.primary,
            groupValue: selectedValue,
            onValueChanged: (dynamic val) {
              if (estateSelectedIndex != -1) {
                estateSelected.choose_repeat = val.toString();
                BuildAzkar.saveZekerListFor(
                    _controller.selectedZekerList, zekerListFor.selected);
                setState(() {});
              }
            },
            children: sWidget,
          ),
        ]));
  }

  Widget cellPlayAudio(int index) {
    return GestureDetector(
      child: Icon(Icons.play_circle_fill,
          size: 24, color: Theme.of(context).colorScheme.secondary),
      onTap: () {
        var temp = _controller.zekerList[index];
        Uri fileUrl = temp.soundFileNamePath();
        var audio = AudioSource.uri(fileUrl);

        playerAzkar.setAudioSource(audio).then((value) {
          playerAzkar.play();
        });
        // playerAzkar.setAsset(temp.soundFileNamePath()).then((value) {
        //   playerAzkar.play();
        // });
      },
    );
  }

  Widget cellCheckBox(int index) {
    var zeker = _controller.zekerList[index];
    var estateSelected = zeker;
    var estateSelectedIndex = _controller.selectedZekerList
        .indexWhere((elment) => elment.zeker_id == zeker.zeker_id);
    if (estateSelectedIndex != -1) {
      estateSelected = _controller.selectedZekerList[estateSelectedIndex];
    }

    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: estateSelected.selected == true
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: new BorderRadius.circular(5),
      ),
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.transparent,
        ),
        child: Checkbox(
          value: estateSelected.selected,
          onChanged: (state) {
            setState(() {
              estateSelected.selected = state!;

              if (estateSelectedIndex == -1) {
                _controller.selectedZekerList.add(estateSelected);
              } else {
                if (estateSelected.selected == false) {
                  _controller.selectedZekerList.removeAt(estateSelectedIndex);
                } else {
                  _controller.selectedZekerList[estateSelectedIndex] =
                      estateSelected;
                }
              }

              BuildAzkar.saveZekerListFor(
                  _controller.selectedZekerList, zekerListFor.selected);
            });
          },
          activeColor: Colors.transparent,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}
