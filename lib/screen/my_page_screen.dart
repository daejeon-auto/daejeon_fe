import 'package:clipboard/clipboard.dart';
import 'package:daejeon_fe/model/code_list.dart';
import 'package:daejeon_fe/model/member_info.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late final MemberInfo memberInfo;
  late final List<CodeList> codeList;
  bool ready = false;

  @override
  void initState() {
    getMemberInfo().then((value) async {
      memberInfo = value;
      if (value.authType == "DIRECT") codeList = await getCodeList();
      ready = true;
      setState(() {});
    });
    super.initState();
  }

  Future<MemberInfo> getMemberInfo() async {
    try {
      return await ApiService().getMemberInfo();
    } catch (e) {
      if (e.toString() == "Exception: 401") {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
      }

      throw ("");
    }
  }

  Future<List<CodeList>> getCodeList() async {
    try {
      return await ApiService().getCodeList();
    } catch (e) {
      if (e.toString() == "Exception: 401") {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
      }

      throw ("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("마이페이지"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 244, 247, 255),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 500,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!ready) const Text("데이터 로딩 중"),
                    if (ready)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "이름: ${memberInfo.name}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "학번: ${memberInfo.studentNumber}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "생년월일: ${memberInfo.birthDay}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "전화번호: ${memberInfo.phoneNumber}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "학교: ${memberInfo.schoolName}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "지역: ${memberInfo.schoolLocate}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromARGB(255, 178, 212, 255),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            codeList[index].code,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            codeList[index].createdAt,
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            codeList[index].isUsed
                                                ? "사용 불가"
                                                : "사용 가능",
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          FlutterClipboard.copy(
                                                  codeList[index].code)
                                              .then(
                                            (value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  '코드가 복사 되었습니다.',
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.copy,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: codeList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
