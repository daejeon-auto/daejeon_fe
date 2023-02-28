import 'dart:convert';

import 'package:daejeon_fe/model/common/result_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _domain = "http://172.30.1.51:80";

  static writePost({required String description}) async {
    var url = Uri.parse("$_domain/post/write");

    var res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'description': description}),
    );

    if (res.statusCode == 200) return;
    throw Exception(res.statusCode.toString());
  }

  static loginPost({required String id, required String password}) async {
    var url = Uri.parse("$_domain/login");

    var res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{'loginId': id, 'password': password},
    );

    if (res.statusCode != 200) throw Error();
    var body = Result.fromJson(jsonDecode(res.body));
    if (body.result == "fail") {
      throw Exception(body.message);
    }
  }
}
