import 'package:ftwv_saqu/app/route/navigation_helper.dart';
import 'package:ftwv_saqu/base/base_controller.dart';
import 'package:get/get.dart';

import '../../../app/route/screen.dart';

class OnboardingController extends BaseController {
  var currentPage = 0.obs;

  final List<String> onboardingPages = [
    "Welcome to the App",
    "Discover Features",
    "Get Started"
  ];


  void nextPage() {
    if (currentPage < onboardingPages.length - 1) {
      currentPage.value++;
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() {
    Navigation.navigateTo(Screen.login);
  }

  void skipOnboarding() {
    finishOnboarding();
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
