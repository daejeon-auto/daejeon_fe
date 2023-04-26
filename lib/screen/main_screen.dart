import 'package:daejeon_fe/screen/home_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/school/school_list_model.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<SchoolListModel> schoolList = [];
  List<SchoolListModel> filtedSchoolList = [];
  late TextEditingController searchSchoolController = TextEditingController();

  void _filterSchools(String query, List<SchoolListModel> schoolList) {
    List<SchoolListModel> displayedSchools = [];
    if (query.isNotEmpty) {
      for (final school in schoolList) {
        if (school.name.toLowerCase().contains(query.toLowerCase())) {
          displayedSchools.add(school);
        }
      }
    } else {
      displayedSchools = schoolList;
      setState(() {});
    }

    filtedSchoolList = displayedSchools;
    setState(() {});
  }

  void getSchoolList() async {
    try {
      schoolList = await ApiService().getSchoolList();
      filtedSchoolList = schoolList;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  late var isLogin = false;

  @override
  void initState() {
    getSchoolList();
    ApiService().isLogin().then(
          (value) => setState(() => isLogin = value),
        );
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "INAB",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          if (!isLogin)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/login"),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "로그인하기",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F8FF),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 90,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 5,
                        ),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                              RegExp(r'[:]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) =>
                              _filterSchools(value, schoolList),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30.0,
                          ),
                          controller: searchSchoolController,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width - 10,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: ListView.separated(
                      itemCount: filtedSchoolList.length,
                      itemBuilder: (context, idx) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(
                                      reqSchoolId: filtedSchoolList[idx].id),
                                ),
                              );
                            },
                            child: Text(
                              "${filtedSchoolList[idx].name} / ${filtedSchoolList[idx].locate}",
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (
                        BuildContext context,
                        int index,
                      ) =>
                          const SizedBox(
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
