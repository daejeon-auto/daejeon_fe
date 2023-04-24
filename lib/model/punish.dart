class Punish {
  int id;
  String reason;
  DateTime expiredDate;
  bool isValid;
  String createdBy, rating;
  String lastModifiedBy;

  Punish({
    required this.id,
    required this.reason,
    required this.expiredDate,
    required this.isValid,
    required this.rating,
    required this.createdBy,
    required this.lastModifiedBy,
  });

  factory Punish.fromJson(Map<String, dynamic> json) {
    return Punish(
      id: json['id'],
      reason: json['reason'],
      expiredDate: DateTime.parse(json['expired_date']),
      isValid: json['valid'],
      rating: json["rating"],
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
    );
  }
}
