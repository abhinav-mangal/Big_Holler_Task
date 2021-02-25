import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../imports.dart';

class RequestHelper {
  // next three lines makes this class a Singleton
  static RequestHelper _instance = RequestHelper.internal();
  RequestHelper.internal();
  factory RequestHelper() => _instance;

  final JsonDecoder _decoder = JsonDecoder();

  Future<dynamic> get(String url) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    var token = await SPHelper.getAppToken();
    headers[HttpHeaders.authorizationHeader] = token;
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
      final jsonResponse = json.decode(res);
      return jsonResponse;
    }).catchError((e) {
      print(e);
      return null;
    });
  }

  Future<dynamic> getUser(String url) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    var token = await SPHelper.getAppToken();
    headers[HttpHeaders.authorizationHeader] = token;
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception("Error while fetching data");
      }
            
      return res;
    }).catchError((e) {
      print(e);
      return null;
    });
  }

  Future<dynamic> post(String url, {body, encoding}) async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      var token = await SPHelper.getAppToken();
      headers[HttpHeaders.authorizationHeader] = token;
      return http
          .post(url,
              headers: headers, body: json.encode(body), encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw Exception("Error while fetching data");
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
