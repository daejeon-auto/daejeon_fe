
class SchoolListModel {
  final String name, locate;
  final int id;

  SchoolListModel({
    required this.id,
    required this.name,
    required this.locate,
  });

  SchoolListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        locate = json['locate'],
        name = json['name'];
}
