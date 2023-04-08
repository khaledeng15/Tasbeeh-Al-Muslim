import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsbeh/Bloc/AppCubit.dart';
import 'package:tsbeh/main.dart';

import '../../../Bloc/AppStates.dart';
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
  }

  void refresh() {
    setState(() {});
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  lstButtons(),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget lstButtons() {
    return GridView.builder(
      physics: ScrollPhysics(),
      itemCount: _controller.cubit.menuList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        var temp = _controller.cubit.menuList[index];
        return GestureDetector(
            child: Column(
              children: [
                Image.asset("$assetPath/${temp.photo}",
                    height: 90, width: 90, fit: BoxFit.cover),
                SizedBox(
                  height: 8,
                ),
                Text(temp.title),
              ],
            ),
            onTap: () {
              _controller.openScreenBy(temp);
            });
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 1),
    );
  }
}
