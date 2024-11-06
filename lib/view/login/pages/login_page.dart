import 'package:ftwv_saqu/app/route/screen.dart';
import 'package:flutter/material.dart';
import 'package:ftwv_saqu/ui/textarea.dart';
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
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Web Testing Bank Saqu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontSize: 16, // Set font size to 14pt
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF5762),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/logo.png',
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL Required';
                  }
                  const urlPattern = r'^(http|https):\/\/([\w-]+(\.[\w-]+)+)([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?$';
                  if (!RegExp(urlPattern).hasMatch(value)) {
                    return 'Enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Camera permission status section
              Obx(() {
                bool hasCameraPermission = controller.hasCameraPermission.value;
                return Row(
                  children: [
                    Icon(
                      hasCameraPermission ? Icons.check_circle : Icons.cancel,
                      color: hasCameraPermission ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      hasCameraPermission
                          ? 'Camera permission granted'
                          : 'Camera permission denied',
                    ),
                    if (!hasCameraPermission)
                      TextButton(
                        onPressed: () async {
                          await controller.requestCameraPermission();
                        },
                        child: const Text('Request Permission'),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 10),

              // Location permission status section
              Obx(() {
                bool hasLocationPermission = controller.hasLocationPermission.value;
                return Row(
                  children: [
                    Icon(
                      hasLocationPermission ? Icons.check_circle : Icons.cancel,
                      color: hasLocationPermission ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      hasLocationPermission
                          ? 'Location permission granted'
                          : 'Location permission denied',
                    ),
                    if (!hasLocationPermission)
                      TextButton(
                        onPressed: () async {
                          await controller.requestLocationPermission();
                        },
                        child: const Text('Request Permission'),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 20),
              // View button section
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) { // Validasi form sebelum navigasi
                      String url = controller.url.text;
                      Navigation.navigateToWithArguments(
                        Screen.home,
                        arguments: {
                          'loginDM': LoginDM(urlCurrent: url),
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF003CF3),
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Load Webview',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 16, // Optional: set font size
                    ),
                  ),
                );
              }),

            ],
          ),
        ),
      ),
    );
  }
}