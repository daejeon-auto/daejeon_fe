import 'package:flutter/material.dart';

import '../widget/card_widget.dart';
import 'post_add_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.circle,
              size: 50,
            ),
            GestureDetector(
              child: const Icon(
                Icons.post_add_outlined,
                size: 30,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostAddScreen(),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                  PostCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
