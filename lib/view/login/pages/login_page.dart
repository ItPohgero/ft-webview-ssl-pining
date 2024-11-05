import 'package:ftwv_saqu/app/route/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/route/navigation_helper.dart';
import '../../../base/base_page.dart';
import '../../../models/view_data_model/login_dm.dart';
import '../controller/login_controller.dart';

class LoginPage extends BasePage<LoginController> {
  const LoginPage({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final controller = this.controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Input URL')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.url,
              decoration: const InputDecoration(labelText: 'https://example.com'),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: (){
                  Navigation.navigateToWithArguments(
                    Screen.home,
                    arguments: {
                      'loginDM': LoginDM(urlCurrent: 'example_token',),
                    },
                  );

                },
                child: const Text('View'),
              );
            }),
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
