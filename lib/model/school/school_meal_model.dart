class SchoolMealModel {
  final List<String>? breakfast, lunch, dinner;

  SchoolMealModel.fromJson(Map<String, dynamic> json)
      : breakfast = json["breakfast"],
        lunch = json["lunch"],
        dinner = json["dinner"];
}
