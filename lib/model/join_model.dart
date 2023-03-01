class JoinModel {
  final String id, password, name, birthday, phoneNumber, stdNum, code, schoolId;

  JoinModel({
    required this.id,
    required this.password,
    required this.name,
    required this.birthday,
    required this.phoneNumber,
    required this.stdNum,
    required this.code,
    required this.schoolId
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': id,
      'password': password,
      'name': birthday,
      'birthDay': birthday,
      'phoneNumber': phoneNumber,
      'studentNumber': stdNum,
      'referCode': code,
      'schoolId': schoolId
    };
  }
}
