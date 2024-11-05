import '../../../base/base_controller.dart';
import '../../../models/view_data_model/login_dm.dart';

class HomeController extends BaseController {
  late LoginDM loginDM;
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    if (arguments.containsKey('loginDM')) {
      loginDM = arguments['loginDM'] as LoginDM;
      print('Received LoginDM: $loginDM');
    }
  }
}
