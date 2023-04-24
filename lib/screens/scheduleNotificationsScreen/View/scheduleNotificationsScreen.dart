import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../models/zekerModel.dart';
import '../Controller/scheduleNotificationsController.dart';

class scheduleNotificationsScreen extends StatefulWidget {
  const scheduleNotificationsScreen({Key? key}) : super(key: key);

  @override
  scheduleNotificationsScreenState createState() =>
      scheduleNotificationsScreenState();
}

class scheduleNotificationsScreenState
    extends State<scheduleNotificationsScreen> {
  late scheduleNotificationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = scheduleNotificationsController(refresh);
    _controller.onInit();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _controller.cubit = AppCubit.get(context);

    return Scaffold(
      appBar: AppBar(title: Text("قائمه التنبيهات")),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 45),
              ),
              child: Text(
                "ايقاف الاذكار",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _controller.stop();
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: body(),
    );
  }

  Widget body() {
    return azkarList();
  }

  Widget azkarList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        children: List.generate(
          _controller.pendingList.length,
          (index) => Container(
              child: cellList(
            _controller.pendingList[index],
          )),
        ),
      ),
    );
  }

  Widget cellList(PendingNotificationRequest notification) {
    ZekerModel zeker = _controller.getNotificationModel(notification);
    return InkWell(
      onTap: () {
        _controller.playSound(zeker);
      },
      child: Dismissible(
          key: ValueKey(notification.id),
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (dismissDirection) {
            _controller.deleteNotification(notification);
          },
          child: Container(
            child: Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(
                        zeker.zeker_name,
                        textAlign: TextAlign.right,
                      ),
                      subtitle: Text(
                        zeker.choose_repeat + " : عدد مرات التكرار",
                        textAlign: TextAlign.right,
                      ),
                      leading: Text(zeker.scheduledDate()),
                    )),
              ],
            )),
          )),
    );
  }
}
