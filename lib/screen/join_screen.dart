import 'package:daejeon_fe/model/common/auth_type.dart';
import 'package:daejeon_fe/model/join_model.dart';
import 'package:daejeon_fe/model/school_list_model.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:daejeon_fe/widget/select_school_dialog_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);
  static const List<String> _inputList = [
    "아이디",
    "비밀번호",
    "이름",
    "생년월일 ex) 20050101",
    "전화번호 ex) 01012341234",
    "학번"
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
  late List<TextEditingController> controllerList = [];
  late TextEditingController invitedCode = TextEditingController();
  late TextEditingController inputSchoolName = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < JoinScreen._inputList.length; i++) {
      controllerList.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < controllerList.length; i++) {
      controllerList[i].dispose();
    }

    invitedCode.dispose();
    super.dispose();
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
      if (e.toString() == "Exception: 400") {
        showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
            title: Text("회원가입중 에러 발생"),
            content: Text("회원가입 정보를 다시한번 확인 해주세요."),
          ),
        );
      }

      var content = "알 수 없는 에러 발생";

      if (e.toString() == "Exception: idLen") {
        content = "아이디는 5자리 이상이어야 합니다.";
      }
      if (e.toString() == "Exception: passwordLen") {
        content = "비밀번호는 8자리 이상이어야 합니다.";
      }
      if (e.toString() == "Exception: phoneNumberLen") {
        content = "전화번호는 11자리 이하이어야 합니다.";
      }
      if (e.toString() == "Exception: birthDayLen") {
        content = "생일은 8자리여야 합니다.";
      }
      if (e.toString() == "Exception: stdNumLen") {
        content = "학번은 4자리 이상이어야 합니다.";
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
                          for (var i = 0; i < JoinScreen._inputList.length; i++)
                            Expanded(
                              child: TextField(
                                controller: controllerList[i],
                                decoration: InputDecoration(
                                    hintText: JoinScreen._inputList[i]),
                              ),
                            ),
                          TextButton(
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
                                                      id: controllerList[0]
                                                          .text,
                                                      password:
                                                          controllerList[1]
                                                              .text,
                                                      name: controllerList[2]
                                                          .text,
                                                      birthday:
                                                          controllerList[3]
                                                              .text,
                                                      phoneNumber:
                                                          controllerList[4]
                                                              .text,
                                                      stdNum: controllerList[5]
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
                                        id: controllerList[0].text,
                                        password: controllerList[1].text,
                                        name: controllerList[2].text,
                                        birthday: controllerList[3].text,
                                        phoneNumber: controllerList[4].text,
                                        stdNum: controllerList[5].text,
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
