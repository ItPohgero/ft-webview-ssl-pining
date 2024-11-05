import 'package:get/get.dart';
import '../services/network/base_repo.dart';

abstract class BaseController<R extends BaseRepo?> extends GetxController {
  final R? repository;

  BaseController([this.repository]);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  void handleArguments(Map<String, dynamic> arguments);

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.isNotEmpty) {
      handleArguments(arguments);
    }
  }
}
