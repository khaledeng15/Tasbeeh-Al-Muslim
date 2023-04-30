import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsbeh/Bloc/AppCubit.dart';
import 'package:tsbeh/helper/List+ext.dart';
import 'package:tsbeh/main.dart';

import '../../../Bloc/AppStates.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/UpdateNewVer.dart';
import '../../../widget/CustomSliverAppBarDelegate.dart';
import '../Controller/HomeController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;
  double expandHeight = 380;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(refresh);
    _controller.onInit();

    UpdateNewVer.check(false, context);
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          _controller.cubit = AppCubit.get(context);

          return Scaffold(body: body());
        });
  }

  Widget body() {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: CustomSliverAppBarDelegate(expandedHeight: expandHeight),
          pinned: false,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              lstButtons(),
            ],
          ),
        )
      ],
    );
  }

  Widget lstButtons() {
    var listSorted = _controller.cubit.menuList.sortedBy((it) => it.itemId);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 10),
        child: Wrap(
          // spacing: 25,
          // runSpacing: 20.0,
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            for (var item in listSorted) listItem(item),
          ],
        ),
      ),
    );
  }

  Widget listItem(ApiModel temp) {
    return GestureDetector(
        child: Container(
          width: 110,
          height: 140,
          child: Column(
            children: [
              Image.asset("$assetPath/${temp.photo}",
                  height: 90, width: 90, fit: BoxFit.cover),
              SizedBox(
                height: 8,
              ),
              Text(
                temp.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
        onTap: () {
          _controller.openScreenBy(temp);
        });
  }
}
