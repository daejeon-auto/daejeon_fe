class PostModel {
  final int postId;
  int likedCount;
  bool isLiked, isReported;
  final String description, created;

  PostModel({
    required this.postId,
    required this.likedCount,
    required this.isLiked,
    required this.isReported,
    required this.description,
    required this.created,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : postId = json["postId"],
        likedCount = json["likedCount"],
        isLiked = json["isLiked"],
        isReported = json["isReported"],
        description = json["description"],
        created = json["created"];
}
