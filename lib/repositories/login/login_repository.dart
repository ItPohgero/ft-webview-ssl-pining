
import '../../models/request/login_request.dart';
import '../../models/response/login_response.dart';
import '../../models/view_data_model/login_dm.dart';
import '../../services/network/api_endpoints.dart';
import '../../services/network/base_repo.dart';
import '../../services/network/base_response.dart';

class LoginRepository extends BaseRepo {
  LoginRepository(super.dio);

  Future<LoginDM?> login(LoginRequest request) async {
    try {
      final result = await post<Map<String, dynamic>>(
        ApiEndpoints.getLogin,
        body: request.toJson(),
        isolate: false
      );

      final baseResponse = BaseResponse<LoginResponse>.fromJson(
        result.data!, (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      final loginResponse = baseResponse.data;
      return loginResponse != null
          ? LoginDM(urlCurrent: loginResponse.token)
          : null;
    } catch (e) {
      rethrow;
    }
  }
}

