import 'dart:io';

import 'package:daejeon_fe/screen/main_screen.dart';
import 'package:daejeon_fe/screen/join_screen.dart';
import 'package:daejeon_fe/screen/login_screen.dart';
import 'package:daejeon_fe/screen/my_page_screen.dart';
import 'package:daejeon_fe/screen/home_screen.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      title: "AnonPost",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/join": (context) => const JoinScreen(),
        "/my-page": (context) => const MyPageScreen(),
        "/home": (context) => const HomeScreen(),
      },
      theme: ThemeData(fontFamily: "NotoSans"),
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
