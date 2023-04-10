import 'package:daejeon_fe/model/member_info.dart';
import 'package:daejeon_fe/model/school/school_meal_model.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late final MemberInfo memberInfo;
  SchoolMealModel? meal;
  bool ready = false;

  @override
  void initState() {
    getMeal().then((value) => {
          meal = value,
          setState(() {}),
        });

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

  Future<SchoolMealModel> getMeal() async {
    try {
      return await ApiService().schoolMenu();
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
            SingleChildScrollView(
              child: Container(
                width: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WebViewX(
                        initialContent: '''
            <ins class="kakao_ad_area" style="display:none;"
            data-ad-unit = "DAN-TjiUKJ1Rui5HWK52"
            data-ad-width = "300"
            data-ad-height = "250"></ins>
            <script type="text/javascript" src="//t1.daumcdn.net/kas/static/ba.min.js" async></script>
            ''',
                        initialSourceType: SourceType.html,
                        javascriptMode: JavascriptMode.unrestricted,
                        height: 270,
                        width: MediaQuery.of(context).size.width - 10,
                      ),
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
                            const SizedBox(
                              height: 20,
                            ),
                            meal == null
                                ? const Text("급식 불러오는 중")
                                : Column(children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "조식",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    meal!.breakfast == null
                                        ? const Text(
                                            "조식이 없습니다.",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, idx) =>
                                                Text(meal!.breakfast![idx]),
                                            separatorBuilder: (context, idx) =>
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                            itemCount: meal!.breakfast!.length),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "중식",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    meal!.lunch == null
                                        ? const Text(
                                            "중식이 없습니다.",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, idx) => Center(
                                                child: Text(meal!.lunch![idx])),
                                            separatorBuilder: (context, idx) =>
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                            itemCount: meal!.lunch!.length),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "석식",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    meal!.dinner == null
                                        ? const Text(
                                            "석식이 없습니다.",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, idx) =>
                                                Text(meal!.dinner![idx]),
                                            separatorBuilder: (context, idx) =>
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                            itemCount: meal!.dinner!.length),
                                  ]),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
