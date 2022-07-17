import 'package:flutter/cupertino.dart';
import 'package:tsbeh/utils/language/appLocalizations.dart';

extension ParseNumbers on String {

  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }

  String translate(BuildContext context)
  {
    return  appLocalizations.of(context)!.translate(this);
  }


  String removeAllHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return replaceAll(exp, '');
  }

}