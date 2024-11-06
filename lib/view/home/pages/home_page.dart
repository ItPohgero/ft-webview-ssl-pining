import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ftwv_saqu/view/home/controller/home_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController _webViewController;
  final GlobalKey webViewKey = GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
            },
            // onPermissionRequest: (controller, request) async {
            //   // Assuming you want to allow the requested permissions
            // },
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
