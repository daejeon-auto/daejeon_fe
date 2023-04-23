import 'package:daejeon_fe/model/punish.dart';

class MemberInfo {
  final String phoneNumber, schoolName, schoolLocate, authType;
  final List<Punish> punishes;

  MemberInfo({
    required this.phoneNumber,
    required this.schoolName,
    required this.schoolLocate,
    required this.authType,
    required this.punishes,
  });

  MemberInfo.fromJson(Map<String, dynamic> json)
      : phoneNumber = json['phoneNumber'],
        schoolName = json['schoolName'],
        schoolLocate = json['schoolLocate'],
        authType = json['auth_type'],
        punishes = json['punishes'] as List<Punish>;
}
