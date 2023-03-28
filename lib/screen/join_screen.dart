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
  static const List<String> _inputList = [
    "아이디",
    "비밀번호",
    "전화번호 ex) 01012341234",
  ];

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  bool isChecked = false;
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

  // 인증 코드 확인
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
    try {
      isLoading = true;
      setState(() {});
      await ApiService().join(body: joinModel);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    } on Exception catch (e) {
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
                                  controller: idController,
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
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: idController,
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
                                      onPressed: () => {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("인증번호 확인"),
                                            content: Form(
                                              child: SizedBox(
                                                height: 120,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          chkCodeController,
                                                      maxLength: 6,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      child: const Text("확인하기"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 100,
                                        ),
                                        child: Text("인증하기"),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
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
                                child: isSchoolSet
                                    ? Text("${school.name} / ${school.locate}")
                                    : const Text("학교 검색하기"),
                              ),
                              const SizedBox(height: 30),
                              TextButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(50, 25),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                child: const Text(
                                  '개인정보이용약관 확인',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  txtFile(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (val) =>
                                    setState(() => isChecked = val!),
                              ),
                              const Text("추천 코드 사용"),
                            ],
                          ),
                          isLoading
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.blueAccent,
                                  size: 50,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (isChecked) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("추천코드 입력"),
                                          content: SizedBox(
                                            width: 100,
                                            height: 120,
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: invitedCode,
                                                  maxLength: 13,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    joinModel = JoinModel(
                                                      id: idController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                      phoneNumber:
                                                          phoneNumberController
                                                              .text,
                                                      code: invitedCode.text,
                                                      schoolId:
                                                          school.id.toString(),
                                                      authType: describeEnum(
                                                          AuthType.INDIRECT),
                                                    );
                                                    join();
                                                  },
                                                  child:
                                                      const Text("추천코드로 회원가입"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      joinModel = JoinModel(
                                        id: idController.text,
                                        password: passwordController.text,
                                        phoneNumber: phoneNumberController.text,
                                        code: "",
                                        schoolId: school.id.toString(),
                                        authType: describeEnum(AuthType.DIRECT),
                                      );
                                      join();
                                    }
                                  },
                                  child: const Text("회원가입"),
                                )
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
