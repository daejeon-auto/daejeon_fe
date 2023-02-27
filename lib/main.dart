import 'package:daejeon_fe/widget/card_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
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
