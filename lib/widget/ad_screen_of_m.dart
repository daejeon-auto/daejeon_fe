import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("$time초 후 닫힘"),
      ),
      body: const WebView(
        initialUrl: 'https://daejeon.inab-devs.repl.co',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
