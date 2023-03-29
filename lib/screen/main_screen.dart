import 'package:daejeon_fe/screen/home_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/school_list_model.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    getSchoolList();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  width: 1500,
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
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
                            fontSize: 40.0,
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
                  width: 1500,
                  height: 500,
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
                                fontSize: 30,
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