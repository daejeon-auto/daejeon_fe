import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class AdScreenOfM extends StatefulWidget {
  const AdScreenOfM({super.key});

  @override
  State<AdScreenOfM> createState() => _AdScreenOfMState();
}

class _AdScreenOfMState extends State<AdScreenOfM> {
  WebViewController? _webViewController;

  int time = 10;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse('https://daejeon.inab-devs.repl.co'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time == 0) {
        timer.cancel();
        Navigator.pop(context);
      }
      setState(() {
        time--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("$time초 후 닫힘"),
      ),
      body: WebViewWidget(
        controller: _webViewController!,
      ),
    );
  }
}

class AdScreenOfW extends StatefulWidget {
  const AdScreenOfW({super.key});

  @override
  State<AdScreenOfW> createState() => _AdScreenOfWState();
}

class _AdScreenOfWState extends State<AdScreenOfW> {
  WebViewController? _webViewController;
  late final PlatformWebViewController _controller;
  int time = 10;

  @override
  void initState() {
    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse('https://daejeon.inab-devs.repl.co'),
        ),
      );
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time == 0) {
        timer.cancel();
        Navigator.pop(context);
      }
      setState(() {
        time--;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("$time초후 닫힘"),
      ),
      body: WebViewWidget(
        controller: _webViewController!,
      ),
    );
  }
}
