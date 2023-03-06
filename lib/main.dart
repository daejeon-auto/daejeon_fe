import 'dart:io';

import 'package:daejeon_fe/screen/join_screen.dart';
import 'package:daejeon_fe/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MaterialApp(
      routes: {
        "/login": (context) => const LoginScreen(),
        "/join": (context) => const JoinScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: const App(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
