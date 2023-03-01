class SchoolListModel {
  final String id, name, locate;

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
