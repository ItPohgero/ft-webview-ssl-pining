import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ftwv_saqu/view/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController _webViewController;
  final GlobalKey webViewKey = GlobalKey();
  bool _isLoading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
    await Permission.camera.request();
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _injectLocationToWebView() async {
    if (_currentPosition != null) {
      final String javascript = '''
        window.latitude = ${_currentPosition!.latitude};
        window.longitude = ${_currentPosition!.longitude};
        // Trigger a custom event that the webpage can listen to
        const event = new CustomEvent('locationUpdated', {
          detail: {
            latitude: ${_currentPosition!.latitude},
            longitude: ${_currentPosition!.longitude}
          }
        });
        window.dispatchEvent(event);
      ''';
      await _webViewController.evaluateJavascript(source: javascript);
    }
  }

  Future<void> clearStorageAndCookies() async {
    // Clear local storage and cookies
    await InAppWebViewController.clearAllCache();
    // Use this method to clear session storage
    String clearScript = '''
      localStorage.clear();
      sessionStorage.clear();
      document.cookie.split(";").forEach(function(c) { 
        document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
      });
      true;
    ''';
    await _webViewController.evaluateJavascript(source: clearScript);
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final String url = controller.loginDM.urlCurrent;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await clearStorageAndCookies();
              _webViewController.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(url)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
              await _injectLocationToWebView();
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED
              );
            },
            onPermissionRequest: (controller, request) async {
              Map<PermissionResourceType, bool> permissions = {};

              for (var resource in request.resources) {
                if (resource == PermissionResourceType.CAMERA) {
                  permissions[resource] = await Permission.camera.isGranted;
                }
                if (resource == PermissionResourceType.GEOLOCATION) {
                  permissions[resource] = await Permission.location.isGranted;
                }
              }

              return PermissionResponse(
                  resources: permissions.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList(),
                  action: permissions.isNotEmpty
                      ? PermissionResponseAction.GRANT
                      : PermissionResponseAction.DENY
              );
            },
            onGeolocationPermissionsShowPrompt:
                (InAppWebViewController controller, String origin) async {
              bool permission = await Permission.location.isGranted;
              return GeolocationPermissionShowPromptResponse(
                  origin: origin, allow: permission, retain: true);
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}