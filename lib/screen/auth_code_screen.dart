import 'package:flutter/material.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/services.dart';

class AuthCodeScreen extends StatefulWidget {
  const AuthCodeScreen({super.key, required this.redirectLink});
  final Widget redirectLink;

  @override
  State<AuthCodeScreen> createState() => _AuthCodeScreenState();
}

class _AuthCodeScreenState extends State<AuthCodeScreen> {
  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final chkCodeController = TextEditingController();

    void chkCode() async {
      try {
        await ApiService().chkAuthCode(
          phoneNumberController.text,
          chkCodeController.text,
        );

        setState(() {});

        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => widget.redirectLink));
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
            title: Text("코드를 다시 확인해 주십시오."),
          ),
        );
      }
    }

    Widget codeChkWidget() {
      return AlertDialog(
        title: const Text("인증번호 확인"),
        content: Form(
          child: SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: chkCodeController,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                ElevatedButton(
                  onPressed: chkCode,
                  child: const Text("확인하기"),
                )
              ],
            ),
          ),
        ),
      );
    }

    void pushChkCode(BuildContext context) async {
      try {
        await ApiService().pushAuthCode(phoneNumberController.text);

        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (_) => codeChkWidget());
      } catch (e) {
        if (e.toString() == "Exception: phoneNumber valid fail") {
          showDialog(
            context: context,
            builder: (ctx) => const AlertDialog(
              title: Text("전화번호를 다시 확인해 주십시오."),
            ),
          );
        }

        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: 400,
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: phoneNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    validator: (String? val) {
                      if (val != null) {
                        return (val.length < 11)
                            ? "전화번호는 11자 이하이어야 합니다."
                            : null;
                      }
                      return "전화번호는 필수 기입 사항입니다.";
                    },
                    decoration: const InputDecoration(hintText: "전화번호"),
                  ),
                  TextButton(
                    onPressed: () => pushChkCode(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      child: Text("인증하기"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
