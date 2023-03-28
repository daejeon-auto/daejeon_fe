class JoinModel {
  final String id, password, phoneNumber, code, schoolId, authType;

  JoinModel({
    required this.id,
    required this.password,
    required this.phoneNumber,
    required this.code,
    required this.schoolId,
    required this.authType,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': id,
      'password': password,
      'phoneNumber': phoneNumber,
      'referCode': code,
      'schoolId': schoolId,
      'authType': authType.toString(),
    };
  }
}
