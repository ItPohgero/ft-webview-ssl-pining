import 'package:get/get.dart';

class Navigation {
  /// Navigasi ke halaman tanpa argument
  static void navigateTo(String routeName) {
    Get.toNamed(routeName);
  }

  /// Navigasi ke halaman dengan argument
  static void navigateToWithArguments(String routeName,
      {required Map<String, dynamic> arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }

  /// Navigasi ke halaman dengan parameter query
  static void navigateToWithParameters(
      String routeName, Map<String, String> parameters) {
    Get.toNamed(routeName, parameters: parameters);
  }

  /// Navigasi ke halaman dan menghapus semua halaman sebelumnya
  static void navigateAndRemoveAll(String routeName) {
    Get.offAllNamed(routeName);
  }

  /// Navigasi ke halaman dan menggantikan halaman saat ini
  static void navigateAndReplace(String routeName) {
    Get.offNamed(routeName);
  }

  /// Kembali ke halaman sebelumnya
  static void goBack({dynamic result}) {
    Get.back(result: result);
  }

  /// Pergi ke halaman root
  static void navigateToRoot() {
    Get.until((route) => route.isFirst);
  }

  /// Kembali ke halaman tertentu
  static void goBackTo(String routeName) {
    Get.until((route) => Get.currentRoute == routeName);
  }

  /// Navigasi ke halaman dengan refresh ketika kembali
  static void navigateToWithRefreshOnBack(String routeName,
      {required Function onRefresh}) {
    Get.toNamed(routeName)?.then((_) {
      onRefresh();
    });
  }
}
