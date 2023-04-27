class JoinModel {
  final String id, password, phoneNumber, schoolId;

  JoinModel({
    required this.id,
    required this.password,
    required this.phoneNumber,
    required this.schoolId,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginId': id,
      'password': password,
      'phoneNumber': phoneNumber,
      'schoolId': schoolId,
    };
  }
}
