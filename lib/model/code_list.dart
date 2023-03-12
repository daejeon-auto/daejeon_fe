class CodeList {
  final String code, createdAt;
  final String? usedBy;
  final bool isUsed;
  final int codeId;

  CodeList.fromJson(Map<String, dynamic> json)
      : codeId = json['code_id'],
        code = json['code'],
        usedBy = json['used_by'],
        createdAt = json['created_at'],
        isUsed = json['isUsed'];
}
