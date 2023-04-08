 import 'package:flutter/material.dart';
import 'package:tsbeh/AppRoutes.dart';

import '../../../models/Base/ApiModel.dart';
import '../Controller/listViewController.dart';

class listViewScreen extends StatefulWidget {
  const listViewScreen({Key? key, required this.model}) : super(key: key);

  final ApiModel model;

  @override
  listViewScreenState createState() => listViewScreenState();
}

class listViewScreenState extends State<listViewScreen> {
  late listViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = listViewController(refresh,widget.model);
    _controller.onInit();
  }

  void refresh() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_controller.model.title),),
        body: RefreshIndicator(
            onRefresh:_controller.pullRefresh,
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    controller: _controller.loadMoreController,
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
                        // navigationBase(context, widget.model.title),
                      ],
                    )))));
  }

  Widget _buildListView() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controller.list.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          return cell(index);
        });
  }

  Widget cell( int index)
  {
    return InkWell(onTap: (){

           ApiModel obj = _controller.list[index];
           obj.titleParent = widget.model.title;
           AppRoutes.openAction(obj, _controller.list);
    },child: 
        Card(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              height: 80,
              
              child: ListTile(
                title: Text(_controller.list[index].title,maxLines: 2,overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,),
                trailing: Icon(Icons.arrow_forward_ios),
              ) ),
          )
        )
    );
  }

    Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _controller.isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
