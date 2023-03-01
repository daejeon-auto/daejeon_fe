import 'package:daejeon_fe/screen/join_screen.dart';
import 'package:daejeon_fe/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      "/login": (context) => const LoginScreen(),
      "/join": (context) => const JoinScreen(),
    },
    home: const App(),
  ));
}
