import 'package:ftwv_saqu/app/route/screen.dart';
import 'package:get/get.dart';
import '../../view/home/pages/home_page.dart';
import '../../view/login/pages/login_page.dart';
import '../../view/splash/pages/splash_page.dart';
import '../binding/home_binding.dart';
import '../binding/login_binding.dart';
import '../binding/splash_binding.dart';

class AppRoutes {

  static List<GetPage> getPages() => [
    GetPage(
      name: Screen.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Screen.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Screen.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
