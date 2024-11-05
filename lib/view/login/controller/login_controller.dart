import 'package:ftwv_saqu/base/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/request/login_request.dart';
import '../../../repositories/login/login_repository.dart';

class LoginController extends BaseController<LoginRepository> {
  LoginController(super.repository);

  final url = TextEditingController();

  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = '';

    final request = LoginRequest(
      url: url.text,
    );

    try {
      final loginDM = await repository?.login(request);
      isLoading.value = false;

    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()}';
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    }
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
