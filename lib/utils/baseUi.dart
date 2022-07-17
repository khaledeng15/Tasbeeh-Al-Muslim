

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

Widget navigationBase(BuildContext context,String title) {
  final maxWidth = MediaQuery.of(context).size.width * 0.8;

  return Container(
    height:80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 20),
            child:  IconButton(

              onPressed: () {
                finish(context);
              },
              icon: Icon(Icons.arrow_back, color: null),
              // icon: iconBack,
            )),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              title,
              maxLines:1,
              overflow: TextOverflow.fade,
              softWrap: true,
              style: boldTextStyle(size: 16, color: Colors.black),
            ),
          ),
        )
      ],
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
  );
}


Widget navigationBaseTransparent(BuildContext context,String title) {
  final maxWidth = MediaQuery.of(context).size.width * 0.8;

  return Container(
    height:80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 10),
            child:  IconButton(

              onPressed: () {
                finish(context);
              },
              icon: Icon(Icons.arrow_back, color: null),
              // icon: iconBack,
            )),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              title,
              maxLines:1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: boldTextStyle(size: 16, color: Colors.black),
            ),
          ),
        )
      ],
    ),

  );
}
