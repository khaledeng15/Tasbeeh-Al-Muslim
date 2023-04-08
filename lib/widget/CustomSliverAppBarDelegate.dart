import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/main.dart';

import '../models/ZekerBuildNotifications/BuildAzkar.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 120;
    final top = expandedHeight - shrinkOffset - size / 0.6;
    final width = context.width();

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset, width),
        Positioned(
          top: top,
          left: 16,
          right: 16,
          child: buildFloating(shrinkOffset),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildBackground(double shrinkOffset, double width) {
    return Opacity(
      opacity: disappear(shrinkOffset),
      child: Stack(
        children: [
          Image.asset("$assetPath/cover.jpg",
              height: 360, width: width, fit: BoxFit.cover),
          Container(
            padding: EdgeInsets.only(bottom: 16, top: 32),
            alignment: Alignment.topCenter,
            height: 360,
            decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(0),
                backgroundColor: Colors.black.withOpacity(0.6)),
            child:
                Container(), //searchWidget(Colors.white).paddingSymmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }

  String getSatutsAzkar() {
    bool isPlay = BuildAzkar.isPlay();
    if (isPlay) {
      BuildAzkar builder = BuildAzkar();
      String time = builder.everyTime.toStringFormated();

      String timeStop = "";
      if (builder.sleepTime.stopAt) {
        timeStop =
            "\n" + "يتوقف الذكر من " + builder.sleepTime.toStringFormated();
      }
      return "التسبيح كل " + time + timeStop;
    }

    return "خاصيه التسبيح متوقفه";
  }

  Widget buildFloating(double shrinkOffset) {
    return Opacity(
      opacity: disappear(shrinkOffset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('تسبيح المسلم', style: boldTextStyle(size: 30, color: white)),
          Text('اذكر الله', style: boldTextStyle(size: 20, color: white)),
          8.height,
          Container(
            //height: 80,
            // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: boxDecorationWithShadow(
                borderRadius: radius(12),
                backgroundColor: white,
                offset: Offset(0, 5)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    "$assetPath/logo.png",
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                8.width,
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('التسبيح', style: boldTextStyle()),
                        4.height,
                        Text(
                          getSatutsAzkar(),
                          style: secondaryTextStyle(),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
