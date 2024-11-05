import 'package:get/get.dart';
import '../../base/base_binding.dart';
import '../../repositories/login/login_repository.dart';
import '../../services/network/dio_module.dart';
import '../../view/login/controller/login_controller.dart';


class LoginBinding extends BaseBinding {
  @override
  void handleArguments() {
    Get.lazyPut<LoginRepository>(() => LoginRepository(DioModule.getInstance()));
    Get.lazyPut<LoginController>(() => LoginController(Get.find<LoginRepository>()));
  }
}

