class MemberInfo {
  final String phoneNumber, schoolName, schoolLocate, authType;

  MemberInfo({
    required this.phoneNumber,
    required this.schoolName,
    required this.schoolLocate,
    required this.authType,
  });

  MemberInfo.fromJson(Map<String, dynamic> json)
      : phoneNumber = json['phoneNumber'],
        schoolName = json['schoolName'],
        schoolLocate = json['schoolLocate'],
        authType = json['auth_type'];
}
