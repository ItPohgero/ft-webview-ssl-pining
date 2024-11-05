import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../repositories/login/login_repository.dart';
import 'package:ftwv_saqu/base/base_controller.dart';

class LoginController extends BaseController<LoginRepository> {
  LoginController(super.repository);

  final url = TextEditingController();

  var hasCameraPermission = false.obs;
  var hasLocationPermission = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Meminta izin kamera
    PermissionStatus cameraStatus = await Permission.camera.request();
    hasCameraPermission.value = cameraStatus.isGranted;
    if (cameraStatus.isDenied) {
      errorMessage.value = 'Camera permission denied';
    }

    // Meminta izin lokasi
    PermissionStatus locationStatus = await Permission.location.request();
    hasLocationPermission.value = locationStatus.isGranted;
    if (locationStatus.isDenied) {
      errorMessage.value = 'Location permission denied';
    }

    // Cek apakah kedua izin diberikan
    if (cameraStatus.isGranted && locationStatus.isGranted) {
      errorMessage.value = '';
    }
  }

  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    hasCameraPermission.value = status.isGranted;
    if (status.isDenied) {
      errorMessage.value = 'Camera permission denied. Please enable it in settings.';
    } else {
      errorMessage.value = '';
    }
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    hasLocationPermission.value = status.isGranted;
    if (status.isDenied) {
      errorMessage.value = 'Location permission denied. Please enable it in settings.';
    } else {
      errorMessage.value = '';
    }
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // Implementasi kosong karena tidak digunakan dalam controller ini
  }
}
