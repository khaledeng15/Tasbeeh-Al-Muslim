import 'package:tsbeh/appRoutes.dart';

import '../../../Bloc/AppCubit.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/Base/Apis.dart';

class HomeController {
  final Function() refresh;

  HomeController(this.refresh);
  late AppCubit cubit;

  bool isLoading = true;
  Apis api = Apis();

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    update();
  }

  void openScreenBy(ApiModel model) {
    AppRoutes.openAction(model, []);
  }
}
