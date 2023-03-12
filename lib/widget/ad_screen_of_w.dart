import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class AdScreenOfW extends StatefulWidget {
  const AdScreenOfW({super.key});

  @override
  State<AdScreenOfW> createState() => _AdScreenOfWState();
}

class _AdScreenOfWState extends State<AdScreenOfW> {
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
      if (time <= 0) {
        timer.cancel();
        Navigator.pop(context);
      } else {
        setState(() {
          time--;
        });
      }
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
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
    );
  }
}
