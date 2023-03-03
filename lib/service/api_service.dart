import 'dart:convert';

import 'package:daejeon_fe/model/common/login_result_model.dart';
import 'package:daejeon_fe/model/common/result_model.dart';
import 'package:daejeon_fe/model/join_model.dart';
import 'package:daejeon_fe/model/post/post_list_model.dart';
import 'package:daejeon_fe/model/school_list_model.dart';
import 'package:http/http.dart' as http;

import '../model/post/post_model.dart';

class ApiService {
  static const String _domain = "https://172.30.1.51";
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "withCredentials": "true"
  };

  static Future<PostListModel> getPostList({
    required int page,
  }) async {
    var url = Uri.parse("$_domain/posts/?page=$page");

    var res = await http.post(url, headers: headers);
    if (res.statusCode != 200) throw Exception(res.statusCode);
    // var postList = PostListModel.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    var body = jsonDecode(utf8.decode(res.bodyBytes))['data'];
    List<dynamic> postListDy = body['postList'];
    var postList = postListDy
        .map((e) => PostModel(
              postId: e['postId'],
              description: e['description'],
              created: e['created'],
              isLiked: e['isLiked'],
              isReported: e['isReported'],
              likedCount: e['likedCount'],
            ))
        .toList();

    var postListModel = PostListModel(
        totalPost: body['totalPost'],
        totalPage: body['totalPage'],
        postList: postList);

    return postListModel;
  }

  static writePost({required String description}) async {
    var url = Uri.parse("$_domain/post/write");

    var res = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'description': description}),
    );

    if (res.statusCode == 200) return;
    throw Exception(res.statusCode.toString());
  }

  static loginPost({required String id, required String password}) async {
    var url = Uri.parse("$_domain/login");

    var res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "withCredentials": "true",
      },
      body: <String, String>{'loginId': id, 'password': password},
    );

    _updateCookie(res);

    if (res.statusCode != 200) throw Error();
    var body = LoginResult.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    if (body.result == "fail") {
      throw Exception(body.message);
    }
  }

  static join({required JoinModel body}) async {
    var url = Uri.parse("$_domain/sign-up");
    var res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  static Future<List<SchoolListModel>> getSchoolList() async {
    List<SchoolListModel> schoolList = [];
    var url = Uri.parse("$_domain/school/list");
    var res = await http.get(url);

    if (res.statusCode != 200) throw Exception(res.statusCode);
    var result = Result.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    for (var school in result.data) {
      schoolList.add(SchoolListModel.fromJson(school));
    }
    return schoolList;
  }

  static Future<bool> report(int postId, String reason) async {
    var url = Uri.parse("$_domain/post/report/$postId");
    var res = await http.post(url,
        headers: headers, body: jsonEncode({"reason": reason}));

    if (res.statusCode != 200) throw Exception(res.statusCode);

    return true;
  }

  static Future<bool> convertLike(int postId) async {
    var url = Uri.parse("$_domain/post/like/add/$postId");
    var res = await http.post(url, headers: headers);

    if (res.statusCode != 200) {
      throw Exception(res.statusCode);
    }

    return true;
  }

  static void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
