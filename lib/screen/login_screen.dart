import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    try {
      await ApiService.loginPost(
        id: idController.text,
        password: passwordController.text,
      );
    } on Exception catch (e) {
      var msg = e.toString();
      if (e.toString() == "Exception: id or password not exist") {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("로그인 문제"),
            content: const Text("아이디 혹은 비밀번호를 재확인 해주십시오."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("확인"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: idController,
                            maxLength: 100,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "id",
                            ),
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            controller: passwordController,
                            maxLength: 100,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "password",
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Container(),
                                ),
                              ),
                              child: const Text("회원가입"),
                            ),
                            TextButton(
                              onPressed: login,
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                backgroundColor: Colors.blueAccent.shade200,
                              ),
                              child: const Text(
                                "로그인",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
