import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController _webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // const google = 'https://google.com';
    const sit = 'https://sit-obwebview.sta-wlabid.net/web/partnerAuthenticate?jwt_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI3MzZmN2FmNmQxNjFmNGI5ZWU1ODZlYzI4MDY0ZmNjZiIsImlwYWRkcmVzcyI6IjExMi4yMTUuMjMxLjkiLCJ1c2VyX3R5cGUiOiJpbTMiLCJjdXN0aWQiOiJhNDg3OWI0Y2ZkYjQyOGQ5MWJlY2Y3M2ZiNmQ5YzAyYiIsImRldmljZV9pZCI6InRlc3RpbmcxMjMiLCJwcm9maWxlcyI6IndlZWtfdXNlciIsInN1YnN0eXBlIjoiZGFkMjMyMGVmMmM0ZGRiMWZiMDQ1YmJhOTE5NjIxNmYiLCJleHAiOjE4MTkyODQ4NjAsImlhdCI6MTgxOTI4NDg2MCwibGF0IjoiLTYuMjUyMjUyMjUyMjUyMjUyIiwibG9uZyI6IjEwNi42ODg2MzE4NTAyMDg4OSJ9.XYe5t_BTmk1Ey-MPsLXBGd_AhA6lRVi2bTWDgxF74io&jwt_client=Bank-Saqu&partnerId=450acc1cdb9447d2867b41a935b75c5e';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Testing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _webViewController.canGoBack()) {
                _webViewController.goBack();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await _webViewController.canGoForward()) {
                _webViewController.goForward();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _webViewController.reload(),
          ),
        ],
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri(sit)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
      ),
    );
  }
}