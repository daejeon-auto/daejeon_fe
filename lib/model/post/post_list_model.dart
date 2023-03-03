import 'package:daejeon_fe/model/post/post_model.dart';

class PostListModel {
  final num totalPost, totalPage;
  final List<PostModel> postList;

  PostListModel({
    required this.totalPost,
    required this.totalPage,
    required this.postList,
  });

  PostListModel.fromJson(
    Map<String, dynamic> json,
  )   : totalPage = json['totalPage'] as int,
        totalPost = json['totalPost'] as int,
        postList = json['postList'] as List<PostModel>;
}
