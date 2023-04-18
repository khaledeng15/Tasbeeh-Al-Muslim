import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/helper/String+ext.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helper/html/HtmlToMarkdown.dart';
import '../../../models/Base/ApiModel.dart';
import '../Controller/ViewController.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key, required this.model}) : super(key: key);
  final ApiModel model;

  @override
  ViewScreenState createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  late ViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ViewController(refresh, widget.model);
    _controller.onInit();
  }

  void refresh() {
    setState(() {});
  }

  final globalKey = RectGetter.createGlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.model.titleParent),
          actions: [btnShare()],
        ),
        body: web());
  }

  Widget txtWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 50),
        child: Container(
          width: double.maxFinite,
          child: Text(
            _controller.txt,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 20, wordSpacing: 5, height: 2),
          ),
        ),
      ),
    );
  }

  Widget web() {
    return WebViewWidget(controller: _controller.webcontroller);
  }

  Widget btnShare() {
    if (Platform.isIOS) {
      return btnShareIpad();
    } else {
      return IconButton(
          onPressed: () async {
            await Share.share(
              _controller.txt,
              subject: widget.model.title,
            );
          },
          icon: Icon(Icons.share));
    }
  }

  Widget btnShareIpad() {
    return RectGetter(
      key: globalKey,
      child: IconButton(
          onPressed: () async {
            var rect = RectGetter.getRectFromKey(globalKey);
            await Share.share(
              _controller.txt,
              subject: widget.model.title,
              sharePositionOrigin:
                  Rect.fromLTWH(rect!.left + 40, rect.top + 20, 2, 2),
            );
          },
          icon: Icon(Icons.share)),
    );
  }
}
