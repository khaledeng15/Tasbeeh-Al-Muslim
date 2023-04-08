import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactusScreen extends StatefulWidget {
  @override
  ContactusScreenState createState() => ContactusScreenState();
}

class ContactusScreenState extends State<ContactusScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(title: Text("About")),
          body: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 50),
              child: Column(children: [
                rowViewIcon(
                    "Company:", "Cybeasy", Icon(Icons.apartment, size: 20), () {
                  requestUrl("https://www.cybeasy.com/");
                }),
                rowViewIcon(
                    "Email:", "Info@Cybeasy.com", Icon(Icons.mail, size: 20),
                    () {
                  requestUrl("mailto:Info@Cybeasy.com");
                }),
                rowViewIcon(
                    "Phone:", "+20 103 072 2286", Icon(Icons.call, size: 20),
                    () {
                  requestUrl("tel:+201030722286");
                }),
              ])),
        ));
  }

  Future<void> requestUrl(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget rowViewIcon(
      String title, String value, Icon icon, GestureTapCallback? onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 05),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 34,
                  height: 34,
                  child: icon //Image.asset("$assetPath/$iconName"),
                  ),
              SizedBox(
                width: 10,
              ),
              Text(title,
                  style: Theme.of(context).textTheme.titleMedium?.apply(
                      color: Theme.of(context).colorScheme.onPrimaryContainer)
                  // titleTextStyle().apply(color: appTheme.appPrimaryColor)
                  ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  value,
                  // style: titleSubBoldTextStyle(),
                  style: Theme.of(context).textTheme.bodyMedium?.apply(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                  textAlign: TextAlign.right,
                ),
              ),
              Icon(
                size: 20,
                Icons.chevron_right,
                // color: appTheme.appIconColor //HexColor("#DD4CA3"),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
