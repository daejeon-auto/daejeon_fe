class LoginResult {
  final String message, result;

  LoginResult(this.message, this.result);

  LoginResult.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        result = json['result'];
}
