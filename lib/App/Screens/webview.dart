import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:share_plus/share_plus.dart';



import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:tsbeh/App/model/Apis.dart';
import 'package:tsbeh/utils/String+ext.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/appColors.dart';
import '../../utils/baseUi.dart';
import '../model/ApiModel.dart';


enum pages {none,api, youtubeLink,resources,link}

class webview extends StatefulWidget {
  static String tag = '/webview';

 late String html   ;
  late ApiModel model  ;
  bool ltr = true;
  late pages loadpage;
  late String url = "" ;

  webview(ApiModel _model,  bool _ltr,pages _loadpage ,{String urlLink = ""} ) {

    this.model = _model;
    this.ltr = _ltr;
    this.loadpage = _loadpage;
    this.url = urlLink;
  }

  @override
  webviewStateState createState() => webviewStateState();
}

class webviewStateState extends State<webview> {

  // final Completer<WebViewController> _controller =
  // Completer<WebViewController>();

  WebViewController? _controller;


  @override
  void initState() {

    super.initState();

  }



  void loadWebContent  ( WebViewController controller, BuildContext context) async {
    // final String contentBase64 =
    // base64Encode(const Utf8Encoder().convert(html));


    if (widget.loadpage == pages.youtubeLink )
    {

          await controller.loadUrl(   widget.html  )  ;

    }
    else if (widget.loadpage == pages.link)
    {

      await controller.loadUrl(   widget.url  )  ;

    }
    else
      {
        String text_align = "text-align: left;";
        if (widget.ltr == false)
        {
          text_align = "text-align: right;";
        }

        String enc_html = HtmlCharacterEntities.decode(widget.html) ;
        enc_html =  """<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='margin: 0; padding: 10px;'>
        <div style='margin-top: 10px; $text_align '>
          $enc_html
        </div>
      </body>
    </html>""" ;

        // await controller.loadUrl('data:text/html;base64,$contentBase64');
        await controller.loadUrl( Uri.dataFromString(
            ' $enc_html',
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8')
        ).toString()) ;
      }




  }


  void getApi()
  {

    final _apis =   Apis();
    _apis.getContent(widget.url, true)
        .then((model) async {

      widget.ltr = false;
      widget.html = model.html;
      loadWebContent(_controller!, context);



    });

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body:Builder(builder: (BuildContext context) {
        return
          Directionality(
            textDirection: TextDirection.ltr,
            child:
                Container(
                    color: Color(0xFFF2F3F8),
                    child:
                    Stack(
                      children: [

                        btnShare(),

                        Padding(
                          padding: EdgeInsets.only(top: 80,bottom: 60),
                          child:
                          webview(),

                        ),

                        navigationBase(context, widget.model.title),
                      ],
                    )

                )
          )
         ;



      }),
    );



  }

  Widget btnShare()
  {
    return
    Align(
      alignment: Alignment.bottomCenter,
      child:
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:

        SizedBox(
          width: 300,
            height: 45,
            child:
            TextButton(
              onPressed: () {
                String enc_html = HtmlCharacterEntities.decode(widget.html) ;

                Share.share(enc_html.removeAllHtmlTags(), subject: widget.model.title);

              },
              style: TextButton.styleFrom(
                backgroundColor:t3_green,
                primary: getColorFromHex('#f2866c'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),

              child: Text(
                'قم بمشاركه المحتوى',
                style: boldTextStyle(size:  18),
              ),
            )
          )
          ),
    )
        ;

  }

  Widget webview() {
    return  WebView(
      // initialUrl: widget.loadpage == pages.link ? widget.url : null ,// 'https://flutter.dev',
      javascriptMode: JavascriptMode.unrestricted,
      zoomEnabled: false,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;

        if (widget.loadpage == pages.api)
        {
          getApi() ;
        }

        else
        {
          loadWebContent(_controller!, context);

        }

      },
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
      javascriptChannels: <JavascriptChannel>{
        // _toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
        // if (request.url.startsWith('https://www.youtube.com/')) {
        //   print('blocking navigation to $request}');
        //   return NavigationDecision.prevent;
        // }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }






}


