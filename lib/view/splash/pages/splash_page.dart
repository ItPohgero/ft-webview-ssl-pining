import 'package:ftwv_saqu/view/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_component/shared_component.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'For Testing Webview',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Text(
              'v. 1.0.2',
              style: TextStyle(fontSize: 11),
            ),

          ],
        ),
      ),
    );
  }
}
