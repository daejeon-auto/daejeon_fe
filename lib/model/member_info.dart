class MemberInfo {
  final String name,
      studentNumber,
      birthDay,
      phoneNumber,
      schoolName,
      schoolLocate,
      authType;

  MemberInfo({
    required this.name,
    required this.studentNumber,
    required this.birthDay,
    required this.phoneNumber,
    required this.schoolName,
    required this.schoolLocate,
    required this.authType,
  });

  MemberInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        studentNumber = json['std_num'],
        birthDay = json['birthDay'],
        phoneNumber = json['phoneNumber'],
        schoolName = json['schoolName'],
        schoolLocate = json['schoolLocate'],
        authType = json['auth_type'];
}
