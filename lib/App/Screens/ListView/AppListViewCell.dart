// ignore: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import 'package:tsbeh/App/model/ApiModel.dart';
import 'package:tsbeh/utils/String+ext.dart';

import '../../../main.dart';


class AppListViewCell extends StatefulWidget {
  static var tag = "/T3Listing";

  // const feedCell(feedClass feedList, {Key? key}) : super(key: key);

  late ApiModel model;

  bool ltr = true;

  AppListViewCell(ApiModel model, int pos ,  bool _ltr  ) {
    this.model = model;
    this.ltr = _ltr;



  }

  @override
  AppListViewCellState createState() => AppListViewCellState();
}

class AppListViewCellState extends State<AppListViewCell> {



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          boxShadow: defaultBoxShadow(),
          color: context.scaffoldBackgroundColor),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    title(),



                  ],
                ),
              ),

            ],
          ),
        ],
      ),

    );
  }





  Widget title() {
    if (widget.model.title.isEmptyOrNull || widget.model.title == "-") {
      return Container();
    }
    else {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                widget.model.title  , style: primaryTextStyle(size: 14),
                maxLines: 2,
                textAlign: widget.ltr ? TextAlign.left : TextAlign.right

            ).expand(),
          ),
        ],
      );
    }
  }

  Widget description() {
    // return Text(model.content ?? "", style: secondaryTextStyle(size: 16), maxLines: 2,textAlign: TextAlign.right,softWrap: true);
    // return Container(
    //     padding: EdgeInsets.all(10),
    //     width: double.infinity,
    //     child: Center(
    //         child: Text(model.content ?? "", style: secondaryTextStyle(size: 16), maxLines: 2,textAlign: TextAlign.right,softWrap: true)
    //     )
    // );

    return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Center(
            child:
            ReadMoreText(
              widget.model.title  ,
              trimLines: 2,

              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '\n' + 'Read more'.translate(context),
              trimExpandedText:  'Read less'.translate(context),
              // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: Colors.black),
              style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
              textDirection: TextDirection.rtl,

            )
        )
    );
  }

  // Widget mOption(var icon, var value, bool highlighted) {
  //   return Container(
  //     child: Row(
  //       children: <Widget>[
  //         Icon(icon, color: highlighted ? blue_color : t3_icon_color, size: 20),
  //         Text(value, style: primaryTextStyle(size: 14)),
  //       ],
  //     ),
  //   );
  // }






  Widget sheet_mOption(var icon, var value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: appStore.iconColor,
          ),
          16.width,
          Text(value, style: primaryTextStyle(
              size: 16, color: appStore.textPrimaryColor))
        ],
      ),
    );
  }
}