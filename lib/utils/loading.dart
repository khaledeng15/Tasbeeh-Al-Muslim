import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:fudc/theme_utils/AppColors.dart';
// import 'package:fudc/app/main/utils/AppWidget.dart';

import 'package:tsbeh/main.dart';

void showloading(BuildContext context, String detail) async {
// 'Alert Dialog with Shape'
  AlertDialog Alert_Dialog_with_Shape = AlertDialog(
    backgroundColor: appStore.scaffoldBackground,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Lottie.asset(
          'res/material-loading.json',
          height: 50,
          width: 100,
          repeat: true,
        ),
        16.height,
        Text(
          detail,
          style:
              secondaryTextStyle(color: appStore.textSecondaryColor, size: 16),
        ),
      ],
    ),
    // contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
  );

  AlertDialog Alert_Dialog_with_Shape2 = AlertDialog(
      backgroundColor: appStore.scaffoldBackground,
      content: Center(
        // Aligns the container to center
        child: Container(
          // A simplified version of dialog.
          width: 200.0,
          height: 100.0,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset(
                'res/material-loading.json',
                height: 100,
                width: 200,
                repeat: true,
              ),
            ],
          ),
        ),
      )
      // contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
      );

  AlertDialog Alert_Dialog_with_Shape3 = AlertDialog(
    backgroundColor: appStore.scaffoldBackground,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            // Aligns the container to center
            child: Container(
          // A simplified version of dialog.
          width: 200.0,
          height: 100.0,
          child: Lottie.asset(
            'res/material-loading.json',
            height: 100,
            width: 200,
            repeat: true,
          ),
        ))
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
        return Alert_Dialog_with_Shape3;
      },
    );
  }

  return showDemoDialog<Null>(
      context: context,
      child: AlertDialog(
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
