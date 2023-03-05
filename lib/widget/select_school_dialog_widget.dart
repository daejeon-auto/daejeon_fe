import 'package:daejeon_fe/model/school_list_model.dart';
import 'package:flutter/material.dart';

import '../service/api_service.dart';

class SelectSchoolDialog extends StatefulWidget {
  const SelectSchoolDialog({Key? key}) : super(key: key);

  @override
  State<SelectSchoolDialog> createState() => _SelectSchoolDialogState();
}

class _SelectSchoolDialogState extends State<SelectSchoolDialog> {
  List<SchoolListModel> schoolList = [];
  List<SchoolListModel> _displaySchool = [];

  @override
  void initState() {
    getSchoolList();
    super.initState();
    setState(() {});
  }

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
    _displaySchool = displayedSchools;
    setState(() {});
  }

  void getSchoolList() async {
    try {
      final schools = await ApiService().getSchoolList();
      _displaySchool = schools;
      setState(() => schoolList = schools);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("학교 검색하기"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => _filterSchools(value, schoolList),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            width: 400,
            child: ListView.separated(
              itemCount: _displaySchool.length,
              itemBuilder: (context, idx) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_displaySchool[idx]);
                  },
                  child: Text(
                    "${_displaySchool[idx].name} / ${_displaySchool[idx].locate}",
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
