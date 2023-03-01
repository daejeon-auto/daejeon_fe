class PostModel {
  final num postId, likedCount;
  final bool isLiked, isReported;
  final String description, created;

  PostModel.fromJson(Map<String, dynamic> json)
      : postId = json["postId"],
        likedCount = json["likedCount"],
        isLiked = json["isLiked"],
        isReported = json["isReported"],
        description = json["description"],
        created = json["created"];
}
