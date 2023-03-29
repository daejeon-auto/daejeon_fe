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
  bool ready = false;

  @override
  void initState() {
    getMemberInfo().then((value) async {
      memberInfo = value;
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
