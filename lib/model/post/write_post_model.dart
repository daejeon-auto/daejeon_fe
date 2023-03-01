class WritePostModel {
  late final String description = "";

  WritePostModel({required String description});
  toJson() {
    return {'description': description};
  }
}
