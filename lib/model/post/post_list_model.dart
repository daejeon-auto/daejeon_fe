import 'package:daejeon_fe/model/post/post_model.dart';

class PostListModel {
  final num totalPost, totalPage;
  final List<PostModel> postList;

  PostListModel.fromJson(
    Map<String, dynamic> json,
  )   : totalPage = json['totalPage'],
        totalPost = json['totalPost'],
        postList = json['postList'];
}
