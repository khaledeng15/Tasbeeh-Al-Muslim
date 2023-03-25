import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../ProKitLib/main/utils/AppColors.dart';
import '../../ProKitLib/main/utils/AppConstant.dart';
import '../../ProKitLib/main/utils/AppWidget.dart';
import '../../ProKitLib/themes/themes11/model/T11Model.dart';
import '../../ProKitLib/themes/themes11/utils/T11DataGenerator.dart';
import '../../ProKitLib/themes/themes11/utils/T11Images.dart';
import '../../ProKitLib/themes/themes11/utils/T11Widget.dart';
import '../../main.dart';
import '../../utils/appColors.dart';
import 'model/BuildNotifications.dart';
import 'model/SleepHourClass.dart';
import 'model/BuildAzkar.dart';
import 'model/zekerModel.dart';

class AzkarMaker extends StatefulWidget {
  static String tag = '/T11ListingScreen';

  @override
  AzkarMakerState createState() => AzkarMakerState();
}

class AzkarMakerState extends State<AzkarMaker>
    with SingleTickerProviderStateMixin {
  double expandHeight = 350;
  late List<ZekerModel> zekerList = [];
  late List<ZekerModel> selectedZekerList = [];

  BuildAzkar builder = BuildAzkar();
  BuildNotifications buildNotifications = BuildNotifications();

  int selectedSegmentedListType = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    // zekerList = generateAlbumMusic();
    setupTime();
    ZekerModel.getListOfRepeats(context).then((value) {
      zekerList.addAll(value);
      setState(() {});
    });

    selectedZekerList = BuildAzkar.getZekerListFor(zekerListFor.selected);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: true,
                centerTitle: true,
                pinned: true,
                title: const Text("تسبيح المسلم",
                    style: TextStyle(
                      fontFamily: fontRegular,
                      color: t3_app_background,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: white,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Stack(children: [
                              commonCacheImageWidget(
                                  "images/app/quran-in-ramadan.jpg", 200,
                                  width: context.width(), fit: BoxFit.cover),
                              Container(
                                padding: EdgeInsets.all(0),
                                alignment: Alignment.topCenter,
                                height: 200,
                                decoration: boxDecorationWithRoundedCorners(
                                    borderRadius: radius(0),
                                    backgroundColor:
                                        appColorPrimary.withOpacity(0.6)),
                                child:
                                    Container(), //searchWidget(Colors.white).paddingSymmetric(horizontal: 16),
                              ),
                            ]),
                            Container(
                              width: context.width(),
                              padding:
                                  EdgeInsets.only(top: 20, left: 10, right: 10),
                              decoration: boxDecorationRoundedWithShadow(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  setting(),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Best of Boiler Music',
                                  //         style: boldTextStyle()),
                                  //     Text('1.5k listners',
                                  //         style: secondaryTextStyle()),
                                  //   ],
                                  // ),
                                  // Text('Edward Steel',
                                  //     style: secondaryTextStyle()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Positioned(
                        //   bottom: 120,
                        //   right:  30,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       commonCacheImageWidget(t11_ic_singer4, 60,
                        //               width: 60, fit: BoxFit.cover)
                        //           .cornerRadiusWithClipRRect(50),
                        //       Positioned(
                        //         bottom: 4,
                        //         right: 40,
                        //         child: Container(
                        //           alignment: Alignment.center,
                        //           decoration: boxDecorationWithShadow(
                        //               boxShape: BoxShape.circle),
                        //           child: Icon(
                        //             Icons.cloud_circle,
                        //             size: 12,
                        //             color: grey,
                        //           ).paddingAll(4),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      playBar(),
                      16.height,
                      segmentedListType(),
                      16.height,
                      list(),
                      16.height,
                    ],
                  )
                ]),
              ),
            ],
          ),
        ));
  }

  Widget list() {
    return Column(
      children: List.generate(zekerList.length, (index) {
        var num = index + 1;
        return cellList(num, index);
      }),
    );
  }

  Widget cellList(int num, int index) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: defaultBoxShadow(),
          color: context.scaffoldBackgroundColor),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          cellCheckBox(index),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                zekerList[index].zeker_name,
                                style: boldTextStyle(
                                    color: textPrimaryColorGlobal),
                                // maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ).expand(),
                          10.width,
                          cellPlayVideo(index),
                        ],
                      ),
                      16.height,
                      segmentedCell(zekerList[index])
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget cellPlayVideo(int index) {
    return GestureDetector(
      child: Icon(Icons.play_circle_fill, size: 24, color: t3_green),
      onTap: () {
        var temp = zekerList[index];

        playerAzkar.setAsset(temp.soundFileNamePath()).then((value) {
          playerAzkar.play();
        });
      },
    );
  }

  Widget cellCheckBox(int index) {
    var zeker = zekerList[index];
    var estateSelected = zeker;
    var estateSelectedIndex = selectedZekerList
        .indexWhere((elment) => elment.zeker_id == zeker.zeker_id);
    if (estateSelectedIndex != -1) {
      estateSelected = selectedZekerList[estateSelectedIndex];
    }

    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: estateSelected.selected == true
            ? appColorPrimary
            : Colors.transparent,
        border: Border.all(
          width: 1,
          color: t3_green,
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
                selectedZekerList.add(estateSelected);
              } else {
                if (estateSelected.selected == false) {
                  selectedZekerList.removeAt(estateSelectedIndex);
                } else {
                  selectedZekerList[estateSelectedIndex] = estateSelected;
                }
              }

              BuildAzkar.saveZekerListFor(
                  selectedZekerList, zekerListFor.selected);
            });
          },
          activeColor: Colors.transparent,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }

  Padding settingText(
    var text,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: fontRegular,
          color: appStore.textPrimaryColor,
          fontSize: textSizeMedium,
        ),
      ),
    );
  }

  List hours = [];
  List minutes = [];
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

  Future<void> pickerBottomSheet(context) async {
    int selectedHours = builder.everyTime.hours;
    int selectedMinutes = builder.everyTime.minutes;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 280,
          child: Column(
            children: [
              Container(
                color: appStore.appBarColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cancel', style: primaryTextStyle(size: 18)).onTap(() {
                      finish(context);
                      // toasty(context, 'Please select value');
                      setState(() {});
                    }),
                    Text('Done', style: primaryTextStyle(size: 18)).onTap(() {
                      builder.everyTime.hours = selectedHours;
                      builder.everyTime.minutes = selectedMinutes;
                      builder.saveEveryTime();

                      finish(context);
                      // toasty(context, selectedValue!.isNotEmpty ? selectedValue : 'Please select value');
                    })
                  ],
                ).paddingAll(8.0),
              ),
              SizedBox(
                  height: 30,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [Text("ساعه"), Text("دقيقه")])),
              SizedBox(
                height: 200,
                child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        pickerTextStyle: primaryTextStyle(),
                      ),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                  initialItem: builder.everyTime.hours),

                              // backgroundColor: context.scaffoldBackgroundColor,
                              itemExtent: 24,
                              children: hours.map((e) {
                                return Text(e,
                                    style: primaryTextStyle(size: 20));
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
                                  initialItem: builder.everyTime.minutes),
                              // backgroundColor: context.scaffoldBackgroundColor,
                              itemExtent: 59,
                              children: minutes.map((e) {
                                return Text(e,
                                    style: primaryTextStyle(size: 20));
                              }).toList(),
                              onSelectedItemChanged: (int val) {
                                // selectedValue = countryName[val];
                                selectedMinutes = val;
                              },
                            ),
                          )
                        ])),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget setting() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text("تحديد أوقات الأذكار",
              textColor: Color(0XFF313384), fontFamily: fontMedium),
          SizedBox(height: 10),
          Container(
            decoration: boxDecoration(
                radius: 16,
                showShadow: true,
                bgColor: context.scaffoldBackgroundColor),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          settingText("تشغيل الذكر كل"),
                          const Icon(Icons.arrow_right,
                              size: 30, color: Colors.grey),
                          // CustomTheme(
                          //   child: DropdownButton<String>(
                          //     icon: Icon(Icons.arrow_drop_down,
                          //         color: Color(0XFF747474)),
                          //     underline: SizedBox(),
                          //     // value: _selectedLocation,
                          //     items: <String>['10 Sec', '20 Sec', '1 min']
                          //         .map((String value) {
                          //       return new DropdownMenuItem<String>(
                          //         value: value,
                          //         child: text(value,
                          //             fontSize: textSizeMedium,
                          //             textColor: Color(0XFF747474)),
                          //       );
                          //     }).toList(),
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         // _selectedLocation = newValue;
                          //       });
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      onTap: () {
                        pickerBottomSheet(context);
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      settingText("ايقاف الذكر فى وقت معين"),
                      CupertinoSwitch(
                        value: true,
                        onChanged: (bool val) {
                          // isDefault = val;
                          // setState(() {});
                        },
                      ),
                      GestureDetector(
                        child: Text("تحديد"),
                        onTap: () {
                          SleepHourClass.showTimeRange(context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20)
        ]);
  }

  Widget segmentedCell(ZekerModel zeker) {
    if (selectedSegmentedListType != 0) {
      return Container();
    }

    var estateSelected = zeker;
    var estateSelectedIndex = selectedZekerList
        .indexWhere((elment) => elment.zeker_id == zeker.zeker_id);
    if (estateSelectedIndex != -1) {
      estateSelected = selectedZekerList[estateSelectedIndex];
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
                  color: selectedValue == 1 ? white : appStore.textPrimaryColor,
                  size: 12))),
      2: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("مرتان",
              style: primaryTextStyle(
                  color: selectedValue == 2 ? white : appStore.textPrimaryColor,
                  size: 12))),
      3: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("ثلاث مرات",
              style: primaryTextStyle(
                  color: selectedValue == 3 ? white : appStore.textPrimaryColor,
                  size: 12)))
    };
    return Container(
        color: appStore.appBarColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("التكرار"),
              CupertinoSegmentedControl(
                borderColor: appColorPrimary,
                selectedColor: appColorPrimary,
                groupValue: selectedValue,
                onValueChanged: (dynamic val) {
                  if (estateSelectedIndex != -1) {
                    estateSelected.choose_repeat = val.toString();
                    BuildAzkar.saveZekerListFor(
                        selectedZekerList, zekerListFor.selected);
                    setState(() {});
                  }
                },
                children: sWidget,
              ),
            ]));
  }

  Widget segmentedListType() {
    final Map<int, Widget> sWidget = <int, Widget>{
      0: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("اذكار مع تكرار",
              style: primaryTextStyle(
                  color: selectedSegmentedListType == 0
                      ? white
                      : appStore.textPrimaryColor,
                  size: 12))),
      1: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("اذكار",
              style: primaryTextStyle(
                  color: selectedSegmentedListType == 1
                      ? white
                      : appStore.textPrimaryColor,
                  size: 12))),
      2: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("دعاه",
              style: primaryTextStyle(
                  color: selectedSegmentedListType == 2
                      ? white
                      : appStore.textPrimaryColor,
                  size: 12))),
      3: Padding(
          padding: const EdgeInsets.all(5),
          child: Text("أيات قرانيه",
              style: primaryTextStyle(
                  color: selectedSegmentedListType == 3
                      ? white
                      : appStore.textPrimaryColor,
                  size: 12)))
    };
    return Container(
        color: appStore.appBarColor,
        child: CupertinoSegmentedControl(
          borderColor: appColorPrimary,
          selectedColor: appColorPrimary,
          groupValue: selectedSegmentedListType,
          onValueChanged: (dynamic val) {
            selectedSegmentedListType = val;

            if (val == 0) {
              ZekerModel.getListOfRepeats(context).then((value) {
                zekerList.clear();
                zekerList.addAll(value);
                setState(() {});
              });
            } else if (val == 1) {
              ZekerModel.getListOfazkar(context).then((value) {
                zekerList.clear();
                zekerList.addAll(value);
                setState(() {});
              });
            } else if (val == 2) {
              ZekerModel.getListOfDoaa(context).then((value) {
                zekerList.clear();
                zekerList.addAll(value);
                setState(() {});
              });
            } else if (val == 3) {
              ZekerModel.getListOfQuran(context).then((value) {
                zekerList.clear();
                zekerList.addAll(value);
                setState(() {});
              });
            }
          },
          children: sWidget,
        ));
  }

  Widget playBar() {
    return FloatingActionButton(
        elevation: 0.0,
        child: AnimatedIcon(
            progress: _animationController,
            icon: BuildAzkar.isPlay() == false
                ? AnimatedIcons.play_pause
                : AnimatedIcons.pause_play,
            color: appColorPrimary),
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          bool isPlay = BuildAzkar.isPlay();
          if (isPlay == false) {
            buildNotifications.build(builder, context);
            BuildAzkar.play();
          } else {
            buildNotifications.stop(context);
            BuildAzkar.stop();
          }
          setState(() {});
        });
  }

  Widget playBarOld() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.skip_previous,
                color: appColorPrimary),
            label: ''),
        BottomNavigationBarItem(
            icon: AnimatedIcon(
                progress: _animationController,
                icon: AnimatedIcons.play_pause,
                color: appColorPrimary),
            label: ''),
        BottomNavigationBarItem(
            icon:
                Icon(MaterialCommunityIcons.skip_next, color: appColorPrimary),
            label: ''),
      ],
      selectedLabelStyle: TextStyle(fontSize: 0),
      unselectedLabelStyle: TextStyle(fontSize: 0),
      backgroundColor: Colors.white,
      onTap: (v) {
        print(v);
        setState(() {
          // isPlaying = !isPlaying;
          // isPlaying
          //     ? _animationController.forward()
          //     : _animationController.reverse();
          buildNotifications.build(builder, context);
        });
      },
    );
  }
}
