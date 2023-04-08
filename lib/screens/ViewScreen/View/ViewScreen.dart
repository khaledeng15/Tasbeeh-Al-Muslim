import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
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
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Text(
              HtmlToMarkdown().convert(_controller.model.html),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 20),
            ),
          ),
          // child:   loading ? CircularProgressIndicator() : WebViewWidget(controller: webController)
        ));
  }
}
