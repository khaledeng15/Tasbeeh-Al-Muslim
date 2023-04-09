import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:nb_utils/nb_utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.model.titleParent)),
        bottomSheet: BottomSheet(
          elevation: 10,
          enableDrag: false,
          builder: (context) {
            return btnShare();
          },
          onClosing: () {},
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Text(
              _controller.txt,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ));
  }

  Widget btnShare() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
            width: double.maxFinite,
            height: 45,
            child: TextButton(
              onPressed: () {
                Share.share(_controller.txt, subject: widget.model.title);
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                'قم بمشاركه المحتوى',
                style: boldTextStyle(size: 18),
              ),
            )));
  }
}
