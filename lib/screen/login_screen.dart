import 'package:daejeon_fe/screen/alert_screen.dart';
import 'package:daejeon_fe/screen/auth_code_screen.dart';
import 'package:daejeon_fe/screen/chage_password.dart';
import 'package:daejeon_fe/screen/join_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  bool isAutoLogin = false;
  String errText = "";

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    try {
      var res = await ApiService().loginPost(
        id: idController.text,
        password: passwordController.text,
        rememberMe: isAutoLogin,
      );

      if (res.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) =>
                  AlertScreen(res: res))),
          (route) => false,
        );
        return;
      }

      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } on Exception catch (e) {
      var content = "";
      if (e.toString() == "Exception: id or password not exist") {
        content = "아이디 혹은 비밀번호를 재확인 해주십시오.";
      }
      if (e.toString() == "Exception: account is pending") {
        content = "계정이 승인 대기 상태입니다.\n해당 학교에서 제공하는 본인인증 방식으로 인증해주십시오.";
      }
      if (e.toString() == "Exception: account is disabled") {
        content = "계정이 정지당했습니다.";
      }

      errText = content;
      setState(() {});
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
                height: errText == "" ? 300 : 350,
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9!@#$%^&*()_.,]'))
                            ],
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "id",
                            ),
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9!@#$%^&*()_.,]'))
                            ],
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "password",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isAutoLogin,
                              onChanged: (val) => setState(() {
                                isAutoLogin = val!;
                              }),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            const Text(
                              "자동 로그인",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: login,
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 115),
                            backgroundColor: Colors.blueAccent.shade200,
                          ),
                          child: const Text(
                            "로그인",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const JoinScreen(),
                                ),
                              ),
                              child: const Text("  회원가입 "),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthCodeScreen(
                                      redirectLink: ChangePwd()),
                                ),
                              ),
                              child: const Text("비밀번호 찾기"),
                            ),
                          ],
                        ),
                        if (errText != "")
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    strokeAlign: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    errText,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
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
