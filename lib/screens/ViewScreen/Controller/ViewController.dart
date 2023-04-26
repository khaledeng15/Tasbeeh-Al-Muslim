import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Bloc/cubit/ThemeAppCubit.dart';
import '../../../helper/html/HtmlToMarkdown.dart';
import '../../../models/AzkarElyomeModel.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/DoaaInQuranModel.dart';
import '../../../models/FirstInIslamHadesModel.dart';
import '../../../models/HadesModel.dart';
import '../../../models/IslamEventsModel.dart';

class ViewController {
  final Function() refresh;

  ViewController(this.refresh, this.model);
  final ApiModel model;
  String txt = "";
  bool loading = true;

  late final WebViewController webcontroller;
  late final PlatformWebViewControllerCreationParams params =
      const PlatformWebViewControllerCreationParams();

  void initWeb(BuildContext context) {
    webcontroller = WebViewController.fromPlatformCreationParams(params);
    webcontroller
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
            update();
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

    String text_align = "text-align: right;";

    String enc_html = HtmlCharacterEntities.decode(model.html);
    enc_html = enc_html.replaceAll("Traditional Arabic", "Cairo");
    String fontColor = "black";
    if (ThemeAppCubit.get(context).IsDark) {
      fontColor = "white";
      enc_html = enc_html.replaceAll("black", "white");
    }
    enc_html = """<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cairo">
<style>
body {
  font-family: "Cairo";
  color : $fontColor ;
}
</style>
      </head>
      <body style='margin: 0; padding: 10px;'>
        <div style='margin-top: 10px; $text_align '>
          $enc_html
        </div>
      </body>
    </html>""";

    webcontroller.loadHtmlString(enc_html);
  }

  void update() {
    refresh();
  }

  Future<void> onInit(BuildContext context) async {
    if (model.readFrom == ApiReadFrom.database) {
      await readFromDB();

      txt = HtmlToMarkdown().convert(model.html);
      initWeb(context);
    }

    update();
  }

  Future<void> readFromDB() async {
    if (model.appModel == AppModel.hades) {
      ApiModel modelDB = await HadesModel.getrow(model.itemId.toInt());
      model.html = modelDB.html;
    } else if (model.appModel == AppModel.firstInIslam) {
      ApiModel modelDB =
          await FirstInIslamHadesModel.getrow(model.itemId.toInt());
      model.html = modelDB.title;
    } else if (model.appModel == AppModel.doaaInQuran) {
      ApiModel modelDB = await DoaaInQuranModel.getrow(model.itemId.toInt());
      model.html = modelDB.title;
    } else if (model.appModel == AppModel.azkarElyome) {
      ApiModel modelDB = await AzkarElyomeModel.getrow(model.itemId.toInt());
      model.html = modelDB.title;
    } else if (model.appModel == AppModel.islamEvents) {
      ApiModel modelDB = await IslamEventsModel.getrow(model.itemId.toInt());
      model.html = modelDB.html;
    }
  }
}
