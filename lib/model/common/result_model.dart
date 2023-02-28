class Result {
  final String message, result;

  Result(this.message, this.result);

  Result.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        result = json['result'];
}
