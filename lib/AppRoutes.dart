import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsbeh/App/Screens/ListView/AppListView.dart';
import 'package:tsbeh/App/model/ApiModel.dart';

import 'App/AppAudioPlayer/AppAudioPlayer.dart';
import 'App/AppAudioPlayer/Example/example_caching.dart';
import 'App/AppAudioPlayer/Example/example_effects.dart';
import 'App/AppAudioPlayer/Example/example_playlist.dart';
import 'App/AppAudioPlayer/Example/example_radio.dart';
import 'App/AzkarMaker/AzkarMaker.dart';
import 'App/HomeScreen.dart';
import 'App/Screens/webview.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppRoutes {
  late BuildContext context;

  AppRoutes(BuildContext _context) {
    context = _context;
  }

  static Map<String, WidgetBuilder> routes() {
    return <String, WidgetBuilder>{
      HomeScreen.tag: (context) => const HomeScreen(),
    };
  }

  void openAction(ApiModel model, List<ApiModel> list) {
    if (model.subtype == ApiSubType.open) {
    } else if (model.subtype == ApiSubType.Open_list) {
      openList(model);
    } else if (model.subtype == ApiSubType.Open_view) {
      openView(model);
    } else if (model.subtype == ApiSubType.Open_url) {
      if(model.url.startsWith("tel"))
        {
          makeCall(model);
        }
      else
        {
          openUrl(model);
        }

    } else if (model.subtype == ApiSubType.Open_about) {
      openAbout(model);
    } else if (model.subtype == ApiSubType.Open_alert) {
      openAlert(model);
    } else if (model.subtype == ApiSubType.Open_twitter) {
      openTwitter(model);
    } else if (model.subtype == ApiSubType.Open_facebookpage) {
      openFacebookPage(model);
    } else if (model.subtype == ApiSubType.Open_buy) {
    } else if (model.subtype == ApiSubType.Open_email) {
      openSendEmail(model);
    } else if (model.subtype == ApiSubType.Open_share) {
      openShare(model);
    } else if (model.subtype == ApiSubType.Open_radio) {
      openRadio(model,list);
    } else if (model.subtype == ApiSubType.Open_radio_list) {
      openRadioList(model);
    } else if (model.subtype == ApiSubType.Open_sound) {
      openSound(model,list);
    }
    else if (model.subtype == ApiSubType.Zeker) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AzkarMaker(  ),
            fullscreenDialog: true),
      ).then((value) {});
    }
  }

  void openAbout(ApiModel model) {}
  void openRadio(ApiModel model, List<ApiModel> list) {
    openSound(model,list);
  }

  void openRadioList(ApiModel model) {
    openList(model) ;
  }

  void openSound(ApiModel model, List<ApiModel> list) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AppAudioPlayer(model: model, list: list ),
          fullscreenDialog: true),
    ).then((value) {});

  }

  void openList(ApiModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AppListView(model: model),
          fullscreenDialog: true),
    ).then((value) {});
  }

  void openUrl(ApiModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              webview(model, false, pages.link, urlLink: model.url),
          fullscreenDialog: true),
    ).then((value) {});
  }

  void openAlert(ApiModel model) {}

  void openTwitter(ApiModel model) {}

  void openFacebookPage(ApiModel model) {}

  void openShare(ApiModel model) {
    Share.share(model.share, subject: model.shareTitle);
  }

  void makeCall(ApiModel model)
  {
    String phone = model.url.replaceAll("tel:", "") ;
    canLaunchUrl(Uri(scheme: 'tel', path:phone)).then((bool result) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phone,
      );
        launchUrl(launchUri);
    });


  }

  void openSendEmail(ApiModel model)   {
    // final Email email = Email(
    //   body: model.share,
    //   subject: model.shareTitle
    // );
    //
    // String platformResponse;
    //
    // try {
    //   await FlutterEmailSender.send(email);
    //   platformResponse = 'success';
    // } catch (error) {
    //   print(error);
    //   platformResponse = error.toString();
    // }



    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(platformResponse),
    //   ),
    // );

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',//'smith@example.com',
      query: encodeQueryParameters(<String, String>{
        'subject': model.shareTitle,
        'body' : model.share
      }),
    );

    launchUrl(emailLaunchUri);

  }



  void openView(ApiModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              webview(model, false, pages.api, urlLink: model.url),
          fullscreenDialog: true),
    ).then((value) {});
  }
}
