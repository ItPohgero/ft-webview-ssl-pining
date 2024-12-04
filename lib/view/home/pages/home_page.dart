import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ftwv_saqu/utils/id.dart';
import 'package:ftwv_saqu/view/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  List<String> consoleLogs = [];
  String vLinkingWebViewErrorDiv = "";
  List<String> postMessageContent = [];
  String? currentUrl;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _getCurrentLocation();
  }

  Future<void> _requestPermissions() async {
    await Future.wait([
      Permission.location.request(),
      Permission.camera.request(),
    ]);
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  // WebView interaction methods
  Future<void> _injectLocationToWebView() async {
    if (_currentPosition == null) return;

    final javascript = '''
      window.latitude = ${_currentPosition!.latitude};
      window.longitude = ${_currentPosition!.longitude};
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

  Future<void> clearStorageAndCookies() async {
    await InAppWebViewController.clearAllCache();
    const clearScript = '''
      localStorage.clear();
      sessionStorage.clear();
      document.cookie.split(";").forEach(function(c) { 
        document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
      });
      true;
    ''';
    await _webViewController.evaluateJavascript(source: clearScript);
  }

  Future<void> fetchElementContent() async {
    const script = '''
      (function() {
        var element = document.getElementById("${HiddenID.value}");
        return element ? element.innerText : "Element not found";
      })();
    ''';
    final result = await _webViewController.evaluateJavascript(source: script);
    setState(() => vLinkingWebViewErrorDiv = result ?? "..");
    _showBottomSheetWithContent();
  }

  // UI Components
  void _showBottomSheetWithContent() {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => _buildInfoBottomSheet(),
    );
  }

  Widget _buildPostMessageList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Post Messages",
            style: TextStyle(fontWeight: FontWeight.bold)),
        if (postMessageContent.isEmpty) const Text("No messages received"),
        ...postMessageContent.reversed
            .map((message) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 14),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildInfoBottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Information",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildInfoSection(
                title: "Get By Hidden ID",
                subtitle: HiddenID.value,
                content: vLinkingWebViewErrorDiv,
              ),
              const SizedBox(height: 10),
              _buildInfoSection(
                title: "Current URL",
                content: currentUrl ?? "",
              ),
              const SizedBox(height: 10),
              // Modify the _buildInfoSection method to accept a Widget instead of a String
              _buildPostMessageList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      {required String title, String? subtitle, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (subtitle != null)
          Text(subtitle, style: const TextStyle(color: Colors.blue)),
        Text(content),
      ],
    );
  }

  Widget _buildConsoleLogBottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Console Log",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: consoleLogs.length,
                itemBuilder: (context, index) =>
                    _buildConsoleLogItem(consoleLogs[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleLogItem(String log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              log,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // WebView Callbacks
  Future<ServerTrustAuthResponse?> _handleServerTrustAuth(
      InAppWebViewController controller,
      URLAuthenticationChallenge challenge) async {
    return ServerTrustAuthResponse(
        action: ServerTrustAuthResponseAction.PROCEED);
  }

  Future<PermissionResponse> _handlePermissionRequest(
      InAppWebViewController controller, PermissionRequest request) async {
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
            : PermissionResponseAction.DENY);
  }

  Future<GeolocationPermissionShowPromptResponse> _handleGeolocationPermission(
      InAppWebViewController controller, String origin) async {
    final permission = await Permission.location.isGranted;
    return GeolocationPermissionShowPromptResponse(
        origin: origin, allow: permission, retain: true);
  }

  void _handleConsoleMessage(
      InAppWebViewController controller, ConsoleMessage consoleMessage) {
    setState(() {
      consoleLogs
          .add('[${consoleMessage.messageLevel}]-${consoleMessage.message}');
    });
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
            icon: const Icon(Icons.bug_report),
            onPressed: () async {
              await clearStorageAndCookies();
              _webViewController.reload();
              showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => _buildConsoleLogBottomSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: fetchElementContent,
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
              _webViewController.addJavaScriptHandler(
                handlerName: "onPostMessage",
                callback: (args) {
                  if (args.isNotEmpty) {
                    setState(() {
                      // Parse the incoming message and add to the list
                      String newMessage = args[0] is String
                          ? args[0]
                          : (args[0] as Map<String, dynamic>)['data'] ?? "";

                      // Add the new message to the list
                      postMessageContent.add(newMessage);
                    });
                  }
                },
              );
              // _webViewController.addJavaScriptHandler(
              //   handlerName: "onPostMessage",
              //   callback: (args) {
              //     if (args.isNotEmpty) {
              //       setState(() {
              //         postMessageContent = args[0];
              //       });
              //     }
              //   },
              // );
            },
            onLoadStart: (controller, url) => setState(() => _isLoading = true),
            onLoadStop: (controller, url) async {
              await controller.evaluateJavascript(source: """              
              // Simulasi WebView React Native postMessage untuk Flutter
              window.ReactNativeWebView = {
                postMessage: function(message) {
                  console.log(message);
                  window.flutter_inappwebview.callHandler('onPostMessage', message);
                }
              };
            
              // Simulasi Capacitor WebView
              window.Capacitor = {
                Plugins: {
                  WebView: {
                    postMessage: function(message) {
                      console.log(message);
                      window.flutter_inappwebview.callHandler('onPostMessage', message);
                    }
                  }
                }
              };
            
              // Simulasi Cordova WebView
              window.cordova = {
                plugins: {
                  bridge: {
                    postMessage: function(message) {
                      console.log(message);
                      window.flutter_inappwebview.callHandler('onPostMessage', message);
                    }
                  }
                }
              };
            
              // Simulasi Native Android
              window.Android = {
                receiveMessage: function(message) {
                  console.log(message);
                  window.flutter_inappwebview.callHandler('onPostMessage', message);
                }
              };
            
              // Simulasi Native iOS
              window.webkit = {
                messageHandlers: {
                  iOSHandler: {
                    postMessage: function(message) {
                      console.log(message);
                      window.flutter_inappwebview.callHandler('onPostMessage', message);
                    }
                  }
                }
              };
            
              // Fallback untuk Generic WebView
              window.postMessage = function(message) {
                console.log(message);
                window.flutter_inappwebview.callHandler('onPostMessage', message);
              };
            """);
              setState(() => _isLoading = false);
              final regex = RegExp(r"^(https?:\/\/[^\/?]+\/[^?]*)");
              final match = regex.firstMatch(url?.toString() ?? "");
              currentUrl = match?.group(0);
              await _injectLocationToWebView();
            },
            onReceivedServerTrustAuthRequest: _handleServerTrustAuth,
            onPermissionRequest: _handlePermissionRequest,
            onGeolocationPermissionsShowPrompt: _handleGeolocationPermission,
            onConsoleMessage: _handleConsoleMessage,
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
