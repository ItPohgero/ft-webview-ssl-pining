import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BasePage<T extends GetxController> extends StatelessWidget {
  const BasePage({super.key});
  T get controller => Get.find<T>();

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
  Widget buildPage(BuildContext context);
}
