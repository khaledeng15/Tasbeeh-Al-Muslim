import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import 'package:tsbeh/main.dart';
import 'package:tsbeh/utils/language/appLocalizations.dart';

import '../ProKitLib/main/utils/AppColors.dart';
import '../ProKitLib/main/utils/AppWidget.dart';

void showAlertPopup(BuildContext context, String title, String detail) async {
// 'Alert_Dialog_with_Shape'
  AlertDialog Alert_Dialog_with_Shape = AlertDialog(
    backgroundColor: appStore.scaffoldBackground,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(appLocalizations.of(context)!.translate(title),
            style: boldTextStyle(color: appStore.textPrimaryColor, size: 16)),
        16.height,
        Text(
          appLocalizations.of(context)!.translate(detail),
          style:
              secondaryTextStyle(color: appStore.textSecondaryColor, size: 16),
        ),
        16.height,
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: boxDecoration(bgColor: appColorPrimary, radius: 10),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: text("Ok", textColor: white, fontSize: 16.0),
            ),
          ),
        )
      ],
    ),
    contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
  );

  void showDemoDialog<T>({BuildContext? context, Widget? child}) {
    showDialog<T>(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Alert_Dialog_with_Shape;
      },
    );
  }

  return showDemoDialog<Null>(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: [
          // FlatButton(
          //     child: Text('OK'),
          //     onPressed: () {
          //       Navigator.pop(context);
          //     }),
        ],
      ));
}
