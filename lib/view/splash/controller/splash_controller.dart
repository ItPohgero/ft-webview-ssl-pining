import 'package:ftwv_saqu/app/route/navigation_helper.dart';
import 'package:get/get.dart';

import '../../../app/route/screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      Navigation.navigateTo(Screen.login);
    });
  }
}
