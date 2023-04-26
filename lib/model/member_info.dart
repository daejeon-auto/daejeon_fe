import 'package:daejeon_fe/model/punish.dart';

class MemberInfo {
  final String phoneNumber, schoolName, schoolLocate;
  List<Punish> punishes = [];

  MemberInfo({
    required this.phoneNumber,
    required this.schoolName,
    required this.schoolLocate,
  });

  MemberInfo.fromJson(Map<String, dynamic> json)
      : phoneNumber = json['phoneNumber'],
        schoolName = json['schoolName'],
        schoolLocate = json['schoolLocate'];
}
