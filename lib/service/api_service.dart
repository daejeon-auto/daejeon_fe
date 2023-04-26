import 'dart:convert';

import 'package:daejeon_fe/model/common/result_model.dart';
import 'package:daejeon_fe/model/join_model.dart';
import 'package:daejeon_fe/model/member_info.dart';
import 'package:daejeon_fe/model/post/post_list_model.dart';
import 'package:daejeon_fe/model/punish.dart';
import 'package:daejeon_fe/model/school/school_list_model.dart';
import 'package:daejeon_fe/model/school/school_meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/post/post_model.dart';

class ApiService {
  // static const String _domain = "http://localhost:8080";
  static const String _domain = "https://inab.site";
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  ApiService();
  late SharedPreferences prefs;

  _initCookie() async {
    prefs = await SharedPreferences.getInstance();
    var token = await getToken();

    headers['X-Auth-Token'] = token;
    headers['X-Refresh-Token'] = await getRefreshToken();
  }

  Future<SchoolMealModel> schoolMenu() async {
    await _initCookie();
    var url = Uri.parse("$_domain/school/meal");

    var res = await http.post(url, headers: headers);
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }
    var decode = utf8.decode(res.bodyBytes);
    var body = jsonDecode(decode)["data"];

    var meal = SchoolMealModel.fromJson(body);

    return meal;
  }

  Future<SchoolListModel> schoolName({required int schoolId}) async {
    await _initCookie();
    var url = Uri.parse("$_domain/school-info/$schoolId");

    var res = await http.get(url, headers: headers);
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }
    var body = jsonDecode(utf8.decode(res.bodyBytes))['data'];

    return SchoolListModel.fromJson(body);
  }

  Future<void> chkCode({
    required String code,
    required String phoneNumber,
  }) async {
    var url = Uri.parse("$_domain/chk-code");

    if (!RegExp(r'(^(?:[+0]9)?[0-9]{11,12}$)').hasMatch(phoneNumber)) {
      throw Exception("phoneNumber valid fail");
    }

    var res = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "phoneNumber": phoneNumber,
          "code": code,
        }));
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }
  }

  Future<void> pushChkCode({required String number}) async {
    var url = Uri.parse("$_domain/push-chk-code");

    if (!RegExp(r'(^(?:[+0]9)?[0-9]{11,12}$)').hasMatch(number)) {
      throw Exception("phoneNumber valid fail");
    }

    var res = await http.post(url,
        headers: headers, body: jsonEncode({"phoneNumber": number}));
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }
  }

  Future<PostListModel> getPostList(
      {required int page, required int schoolId}) async {
    await _initCookie();

    var url = Uri.parse("$_domain/posts?page=$page&schoolId=$schoolId");

    var res = await http.post(url, headers: headers);
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }

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
    await _initCookie();

    if (description.trimRight().trimLeft().length < 10) {
      throw Exception(400);
    }
    var url = Uri.parse("$_domain/post/write");

    var res = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'description': description.trimLeft().replaceAll(RegExp('\\s+'), ' ')
      }),
    );
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode == 200) return;
    throw Exception(res.statusCode.toString());
  }

  Future<List<Punish>> loginPost({
    required String id,
    required String password,
    required bool rememberMe,
  }) async {
    await _initCookie();

    var url = Uri.parse("$_domain/login");

    var res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'loginId': id,
        'password': password,
        'rememberMe': rememberMe.toString(),
      },
    );
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) throw Error();
    var body = Result.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    var memberInfo = MemberInfo.fromJson(body.data);
    List<dynamic> punishes =
        body.data["punishes"].map((val) => Punish.fromJson(val)).toList();
    for (var element in punishes) {
      memberInfo.punishes.add(element);
    }

    if (body.hasError == true) {
      throw Exception(res.statusCode);
    }

    await _updateCookie(res);
    await _updateAccessToken(res);
    await _updateRefreshToken(res);

    return memberInfo.punishes;
  }

  join({required JoinModel body}) async {
    await _initCookie();

    if (body.id.length < 5) throw Exception("idLen");
    if (body.password.length < 8) throw Exception("passwordLen");
    if (body.phoneNumber.length > 11) throw Exception("phoneNumberLen");

    var url = Uri.parse("$_domain/sign-up");
    var res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body.toJson()),
    );
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 201) {
      throw Exception(res.statusCode);
    }
  }

  Future<List<SchoolListModel>> getSchoolList() async {
    await _initCookie();

    List<SchoolListModel> schoolList = [];
    var url = Uri.parse("$_domain/school/list");
    var res = await http.get(url);

    if (res.statusCode == 401) refreshAccessToken();
    var result = Result.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }
    for (var school in result.data) {
      schoolList.add(SchoolListModel.fromJson(school));
    }
    return schoolList;
  }

  Future<bool> report(int postId, String reason) async {
    await _initCookie();

    var url = Uri.parse("$_domain/post/report/$postId");
    var res = await http.post(url,
        headers: headers, body: jsonEncode({"reason": reason}));
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }

    return true;
  }

  Future<bool> convertLike(int postId) async {
    await _initCookie();

    var url = Uri.parse("$_domain/post/like/add/$postId");
    var res = await http.post(url, headers: headers);
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 200 && res.statusCode != 401) {
      throw Exception(res.statusCode);
    }

    return true;
  }

  Future<MemberInfo> getMemberInfo() async {
    var url = Uri.parse("$_domain/member/info");
    var res = await http.post(
      url,
      headers: headers,
    );
    if (res.statusCode == 401) refreshAccessToken();
    if (res.statusCode != 202) throw Exception(res.statusCode);

    var result = Result.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    var memberInfo = MemberInfo.fromJson(result.data);

    return memberInfo;
  }

  Future<void> _updateCookie(http.Response response) async {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);

      prefs.setString(rawCookie.split('=')[0], rawCookie.split('=')[1]);
    }
  }

  Future<void> logout() async {
    await _initCookie();
    await http.post(Uri.parse("$_domain/logout"), headers: headers);

    prefs.clear();
  }

  Future<void> _updateAccessToken(http.Response res) async {
    String? rawToken = res.headers['x-auth-token'];

    if (rawToken != null) {
      prefs.setString('token', rawToken);
    }
  }

  Future<void> _updateRefreshToken(http.Response res) async {
    String? rawToken = res.headers['x-refresh-token'];

    if (rawToken != null) {
      prefs.setString('refreshToken', rawToken);
    }

    await _updateAccessToken(res);
  }

  Future<void> refreshAccessToken() async {
    var refreshToken = await getRefreshToken();
    if (refreshToken.isEmpty) throw Exception("401");
    var res = await http.post(Uri.parse("$_domain/refresh"), headers: headers);
    if (res.statusCode != 200 && res.statusCode != 401) throw Exception("401");
    await _updateAccessToken(res);
  }

  Future<bool> isLogin() async {
    await _initCookie();
    return await getToken() == "" ? headers["token"] != null : true;
  }

  Future<String> getToken() async {
    return prefs.getString("token") ?? "";
  }

  Future<String> getRefreshToken() async {
    return prefs.getString("refreshToken") ?? "";
  }
}
