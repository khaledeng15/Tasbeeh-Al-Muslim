import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/helper/String+ext.dart';
import 'package:tsbeh/main.dart';

import '../../../models/Base/ApiModel.dart';
import '../../../models/Base/Apis.dart';
import '../Controller/WebController.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html_character_entities/html_character_entities.dart';

enum pages { none, api, youtubeLink, resources, link, database }

class WebScreen extends StatefulWidget {
  late ApiModel model;
  bool ltr = true;
  late pages loadpage;
  late String? url;

  WebScreen(ApiModel _model, bool _ltr, pages _loadpage, {String? urlLink}) {
    this.model = _model;
    this.ltr = _ltr;
    this.loadpage = _loadpage;
    this.url = urlLink;
  }

  @override
  WebScreenState createState() => WebScreenState();
}

class WebScreenState extends State<WebScreen> {
  late WebController _controller;

  bool loading = true;
  late final WebViewController _webcontroller;

  @override
  void initState() {
    super.initState();
    _controller = WebController(refresh, widget.model);
    _controller.onInit();

    loadWebContent(context);
  }

  void refresh() {
    setState(() {});
  }

  void getApi() {
    final _apis = Apis();
    _apis.getContent(widget.url!, true).then((value) async {
      widget.ltr = false;
      _controller.model.html = value.html;
      loadWebContent(context);
    });
  }

  void loadWebContent(BuildContext context) async {
    // final String contentBase64 =
    // base64Encode(const Utf8Encoder().convert(html));

    late final PlatformWebViewControllerCreationParams params;

    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            loading = false;
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {
            log('''
                Page resource error:
                  code: ${error.errorCode}
                  description: ${error.description}
                  errorType: ${error.errorType}
                  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   debugPrint('blocking navigation to ${request.url}');
            //   return NavigationDecision.prevent;
            // }
            log('allowing navigation to ${request.url}');

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    if (widget.loadpage == pages.youtubeLink) {
      // await controller.loadRequest( Uri.parse(  widget.html)  )  ;
    } else if (widget.loadpage == pages.link) {
      await controller.loadRequest(Uri.parse(widget.url!));
    } else if (widget.loadpage == pages.resources) {
      await controller.loadFlutterAsset("assets/${widget.url!}");
    } else {
      String text_align = "text-align: left;";
      if (widget.ltr == false) {
        text_align = "text-align: right;";
      }

      String enc_html = HtmlCharacterEntities.decode(_controller.model.html);
      enc_html = """<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='margin: 0; padding: 10px;'>
        <div style='margin-top: 10px; $text_align '>
          $enc_html
        </div>
      </body>
    </html>""";
    }

    _webcontroller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.title)),
      // bottomSheet: BottomSheet(
      //   elevation: 10,
      //   enableDrag: false,
      //   builder: (context) {
      //     return btnShare();
      //   },
      //   onClosing: () {},
      // ),
      body: Builder(builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              color: Color(0xFFF2F3F8),
              child: Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: loading
                      ? Loader()
                      : WebViewWidget(controller: _webcontroller)),
            ));
      }),
    );
  }

  Widget btnShare() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
            width: double.maxFinite,
            height: 45,
            child: TextButton(
              onPressed: () {
                String enc_html =
                    HtmlCharacterEntities.decode(_controller.model.html);

                Share.share(enc_html.removeAllHtmlTags(),
                    subject: widget.model.title);
              },
              style: TextButton.styleFrom(
                // backgroundColor: t3_green,
                // primary: getColorFromHex('#f2866c'),
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
