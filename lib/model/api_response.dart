import '../imports.dart';

class ApiResponse {
  bool success;
  int statusCode;
  dynamic response;
  String message;

  ApiResponse({this.success, this.statusCode, this.response, this.message});

  ApiResponse.fromJson(Map<String, dynamic> parsedJson) {
    success = parsedJson[j_success];
    statusCode = parsedJson[j_statusCode];
    response = parsedJson[j_response];
  }
}
