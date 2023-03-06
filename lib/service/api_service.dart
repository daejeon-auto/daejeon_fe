import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:daejeon_fe/model/common/login_result_model.dart';
import 'package:daejeon_fe/model/common/result_model.dart';
import 'package:daejeon_fe/model/join_model.dart';
import 'package:daejeon_fe/model/post/post_list_model.dart';
import 'package:daejeon_fe/model/school_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sweet_cookie/sweet_cookie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/post/post_model.dart';

class ApiService {
  final LocalStorage storage = LocalStorage("JSESSION");

  // static const String _domain = "https://10.157.217.197";
  static const String _domain = "https://daejeon-be-production.up.railway.app";
  Cookie cookie = Cookie('JSESSIONID', '3712222644FB9ACF7E3DB7DD9659B6D0');
  Map<String, String> headers = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
    HttpHeaders.cookieHeader: "JSESSIONID=3712222644FB9ACF7E3DB7DD9659B6D0"
  };

  ApiService() {
    _initCookie();
  }

  _initCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("JSESSION") != null) {
      headers['cookie'] = prefs.getString("JSESSION")!;
    }
    headers['cookie'] = getCookie("JSESSION");
  }

  Future<PostListModel> getPostList({required int page}) async {
    var url = Uri.parse("$_domain/posts/?page=$page");

    var res = await http.post(url, headers: headers);
    if (res.statusCode != 200) throw Exception(res.statusCode);

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

  writePost({required String description}) async {
    var url = Uri.parse("$_domain/post/write");

    var res = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'description': description}),
    );

    if (res.statusCode == 200) return;
    throw Exception(res.statusCode.toString());
  }

  loginPost({
    required String id,
    required String password,
  }) async {
    var url = Uri.parse("$_domain/login");

    var res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{'loginId': id, 'password': password},
    );

    if (res.statusCode != 200) throw Error();
    var body = LoginResult.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));

    if (body.result == "fail") {
      throw Exception(body.message);
    }
    await _updateCookie(res);

    headers['cookie'] = getCookie("JSESSION");
  }

  join({required JoinModel body}) async {
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

  Future<List<SchoolListModel>> getSchoolList() async {
    List<SchoolListModel> schoolList = [];
    var url = Uri.parse("$_domain/school/list");
    var res = await http.get(url);

    var result = Result.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    if (res.statusCode != 200) throw Exception(res.statusCode);
    for (var school in result.data) {
      schoolList.add(SchoolListModel.fromJson(school));
    }
    return schoolList;
  }

  Future<bool> report(int postId, String reason) async {
    var url = Uri.parse("$_domain/post/report/$postId");
    var res = await http.post(url,
        headers: headers, body: jsonEncode({"reason": reason}));

    if (res.statusCode != 200) throw Exception(res.statusCode);

    return true;
  }

  Future<bool> convertLike(int postId) async {
    var url = Uri.parse("$_domain/post/like/add/$postId");
    var res = await http.post(url, headers: headers);

    if (res.statusCode != 200) {
      throw Exception(res.statusCode);
    }

    return true;
  }

  Future<void> _updateCookie(http.Response response) async {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(rawCookie.split('=')[0], rawCookie.split('=')[1]);

      SweetCookie.set(rawCookie.split('=')[0], rawCookie.split('=')[1]);
      window.localStorage['JSESSION'] = rawCookie;
    }
  }

  String getCookie(String name) {
    return SweetCookie.get(name) ?? "";
  }
}
