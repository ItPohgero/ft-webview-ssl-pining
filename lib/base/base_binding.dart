import 'package:get/get.dart';

abstract class BaseBinding extends Bindings {
  Map<String, dynamic>? getArguments() {
    return extractArguments();
  }

  void handleArguments();

  @override
  void dependencies() {
    handleArguments();
  }
}

Map<String, dynamic>? extractArguments() {
  return Get.arguments as Map<String, dynamic>?;
}