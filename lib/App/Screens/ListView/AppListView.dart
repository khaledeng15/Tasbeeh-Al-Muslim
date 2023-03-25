import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsbeh/App/Screens/ListView/AppListViewCell.dart';
import 'package:tsbeh/App/model/ApiModel.dart';
import 'package:tsbeh/App/model/Apis.dart';

import 'package:tsbeh/utils/baseUi.dart';

import '../../../AppRoutes.dart';

// T3Listing
class AppListView extends StatefulWidget {
  static var tag = "/T3Listing";

  final ApiModel model;

  const AppListView({Key? key, required this.model}) : super(key: key);

  @override
  AppListViewState createState() => AppListViewState();
}

class AppListViewState extends State<AppListView> {
  static const Color background = Color(0xFFF2F3F8);

  List<ApiModel> _List = [];
  Apis api = Apis();
  final _controller = ScrollController();

  int page = 1;
  bool isLoading = true;

  String searchTxt = "";
  String categID = "1";
  bool ltr = false;

  @override
  void initState() {
    // PreferenceUtils.init();

    super.initState();

    getListOnline(false);

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        if (isLoading == false) {
          setState(() {
            isLoading = true;
          });

          page = page + 1;

          getListOnline(false);
        }
      }
    });
  }

  Future<void> _pullRefresh() async {
    page = 1;
    await getListOnline(false);
  }

  Future<void> getListOnline(bool isCaching) async {
    setState(() {
      isLoading = true;
    });

    var lst = await api.getList(widget.model.url, page, isCaching);
    // print(lst);

    setState(() {
      isLoading = false;
      _List.addAll(lst);
    });

    if (page == 1) {
      // _controller.jumpTo(0);
      _controller.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }

    if (lst.length == 0) {
      page = page - 1;
      if (page <= 0) {
        page = 1;
      }
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                    color: background,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    controller: _controller,
                                    child: Column(children: <Widget>[
                                      SizedBox(height: 10),
                                      _buildListView(),
                                      _buildProgressIndicator(),
                                    ])),
                              ),
                            ],
                            // ),
                          ),
                        ),
                        navigationBase(context, widget.model.title),
                      ],
                    )))));
  }

  Widget _buildListView() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _List.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
              child: AppListViewCell(_List[index], index, ltr),
              onTap: () {
                ApiModel obj = _List[index];
                obj.titleParent = widget.model.title;
                AppRoutes(context).openAction(obj, _List);
              });
        });
  }
}
