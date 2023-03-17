import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class AdScreenOfW extends StatefulWidget {
  const AdScreenOfW({super.key});

  @override
  State<AdScreenOfW> createState() => _AdScreenOfWState();
}

class _AdScreenOfWState extends State<AdScreenOfW> {
  int time = 10;

  @override
  void initState() {
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
      body: WebViewX(
        initialContent: 'https://daejeon.inab-devs.repl.co',
        initialSourceType: SourceType.url,
        javascriptMode: JavascriptMode.unrestricted,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
