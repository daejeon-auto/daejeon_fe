class Result {
  final bool hasError;
  final dynamic data;

  Result.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        hasError = json['hasError'];
}
