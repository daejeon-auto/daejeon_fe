import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePwd extends StatefulWidget {
  const ChangePwd({super.key});

  @override
  State<ChangePwd> createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  final phoneNumController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> changePwd() async {
    try {
      var res = await ApiService()
          .chagnePwd(phoneNumController.text, passwordController.text);

      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("비밀번호 재설정 중 에러 발생"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          child: SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                TextFormField(
                  controller: phoneNumController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  validator: (String? val) {
                    if (val != null) {
                      return (val.length < 11) ? "전화번호는 11자 이하이어야 합니다." : null;
                    }
                    return "전화번호는 필수 기입 사항입니다.";
                  },
                  decoration: const InputDecoration(hintText: "전화번호"),
                ),
                ElevatedButton(
                  onPressed: changePwd,
                  child: const Text("확인하기"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
