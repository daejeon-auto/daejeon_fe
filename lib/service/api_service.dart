import 'dart:convert';

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
}
