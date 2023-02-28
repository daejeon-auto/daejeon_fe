import 'package:daejeon_fe/widget/card_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F8FF),
        appBar: AppBar(
          title: const Icon(
            Icons.circle,
            size: 50,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                PostCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
