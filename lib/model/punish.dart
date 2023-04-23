import 'package:daejeon_fe/model/punish_rating.dart';

class Punish {
  int id;
  String reason;
  DateTime expiredDate;
  bool isValid;
  PunishRating rating;
  String createdBy;
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
      id: json['punish_id'],
      reason: json['reason'],
      expiredDate: DateTime.parse(json['expired_date']),
      isValid: json['valid'],
      rating: PunishRating.values.firstWhere(
          (rating) => rating.toString() == json['rating']),
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
    );
  }
}