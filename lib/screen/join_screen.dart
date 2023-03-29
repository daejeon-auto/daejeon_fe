import 'package:daejeon_fe/model/common/auth_type.dart';
import 'package:daejeon_fe/model/join_model.dart';
import 'package:daejeon_fe/model/school_list_model.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:daejeon_fe/widget/select_school_dialog_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, rootBundle;

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  bool isChecked = false, isPhoneChk = false;
  bool isSchoolSet = false, isLoading = false;
  String searchSchool = "";
  SchoolListModel school = SchoolListModel(id: 0, name: "", locate: "");

  late JoinModel joinModel;

  // 선택사항
  late TextEditingController invitedCode = TextEditingController();

  // 필수 기입 정보 컨트롤러
  late TextEditingController inputSchoolName = TextEditingController();
  late TextEditingController idController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();

  late TextEditingController chkCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    invitedCode.dispose();
    super.dispose();
  }

  Future<void> txtFile(BuildContext context) async {
    String agree = await rootBundle.loadString('assets/agree.txt');

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('개인정보 이용약관'),
          content: SingleChildScrollView(child: Text(agree)),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void join() async {
    var formKeyState = _formKey.currentState!;
    try {
      if (formKeyState.validate()) {
        formKeyState.save();
        isLoading = true;
        setState(() {});

        await ApiService().join(body: joinModel);
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    } catch (e) {
      isLoading = false;
      setState(() {});

      var content = "알 수 없는 에러 발생";
      if (e.toString() == "Exception: 404") {
        content = "힉교를 찾지 못했습니다";
      }

      if (e.toString() == "Exception: 409") {
        content = "이미 등록된 아이디입니다.";
      }

      if (e.toString() == "Exception: idLen") {
        content = "아이디는 5자리 이상이어야 합니다.";
      }
      if (e.toString() == "Exception: passwordLen") {
        content = "비밀번호는 8자리 이상이어야 합니다.";
      }
      if (e.toString() == "Exception: phoneNumberLen") {
        content = "전화번호는 11자리 이하이어야 합니다.";
      }

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("회원가입중 에러 발생"),
          content: Text(content),
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
      await ApiService().pushChkCode(number: phoneNumberController.text);

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

  void chkCode() async {
    try {
      await ApiService().chkCode(
        code: chkCodeController.text,
        phoneNumber: phoneNumberController.text,
      );

      isPhoneChk = true;
      setState(() {});

      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 600,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 30,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: const Image(
                              image: AssetImage('assets/logo.png'),
                              width: 130,
                              height: 130,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: idController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[:]'))
                                  ],
                                  validator: (String? val) {
                                    if (val != null) {
                                      return (val.length < 5)
                                          ? "아이디는 5자 이상이어야 합니다."
                                          : null;
                                    }
                                    return "아이디는 필수 기입 사항입니다.";
                                  },
                                  decoration:
                                      const InputDecoration(hintText: "아이디"),
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[:]'))
                                  ],
                                  validator: (String? val) {
                                    if (val != null) {
                                      return (val.length < 8)
                                          ? "비밀번호는 8자 이상이어야 합니다."
                                          : null;
                                    }
                                    return "비밀번호는 필수 기입 사항입니다.";
                                  },
                                  decoration:
                                      const InputDecoration(hintText: "비밀번호"),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                      const Size(50, 25),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const SelectSchoolDialog()).then(
                                      (value) {
                                        if (value != null) {
                                          school = value;
                                          isSchoolSet = true;
                                          setState(() {});
                                        }
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      // horizontal: 50,
                                      vertical: 15,
                                    ),
                                    width: 300,
                                    // height: 30,
                                    child: isSchoolSet
                                        ? Text(
                                            "${school.name} / ${school.locate}")
                                        : const Text("학교 검색하기"),
                                  ),
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: phoneNumberController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'[:]'))
                                      ],
                                      validator: (String? val) {
                                        if (val != null) {
                                          return (val.length < 11)
                                              ? "전화번호는 11자 이하이어야 합니다."
                                              : null;
                                        }
                                        return "전화번호는 필수 기입 사항입니다.";
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "전화번호"),
                                    ),
                                    const SizedBox(
                                      width: 5,
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
                                    const SizedBox(height: 30),
                                    TextButton(
                                      style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                          const Size(50, 25),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                      ),
                                      child: const Text(
                                        '개인정보이용약관 확인',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        txtFile(context);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    isLoading
                                        ? LoadingAnimationWidget
                                            .staggeredDotsWave(
                                            color: Colors.blueAccent,
                                            size: 50,
                                          )
                                        : ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                isPhoneChk
                                                    ? Colors.blueAccent
                                                    : Colors.grey,
                                              ),
                                            ),
                                            onPressed: isPhoneChk
                                                ? () {
                                                    joinModel = JoinModel(
                                                      id: idController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                      phoneNumber:
                                                          phoneNumberController
                                                              .text,
                                                      code: "",
                                                      schoolId:
                                                          school.id.toString(),
                                                      authType: describeEnum(
                                                          AuthType.DIRECT),
                                                    );
                                                    join();
                                                  }
                                                : () {},
                                            child: const Text("회원가입"),
                                          )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
