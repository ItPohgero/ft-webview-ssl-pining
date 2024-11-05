import 'package:ftwv_saqu/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends BasePage<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: controller.onboardingPages.length,
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.onboardingPages[index],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Description for the onboarding page goes here.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: const Text("Skip"),
                  ),
                  Row(
                    children: List.generate(
                      controller.onboardingPages.length,
                          (index) => Container(
                        margin: const EdgeInsets.all(4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index ? Colors.blue : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.nextPage,
                    child: Text(
                      controller.currentPage.value == controller.onboardingPages.length - 1
                          ? "Finish"
                          : "Next",
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
