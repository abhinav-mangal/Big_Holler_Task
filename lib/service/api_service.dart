import 'dart:convert';

import '../imports.dart';

class ApiService {
  RequestHelper helper = RequestHelper();

  Future<ApiResponse> loginUser(BuildContext context, Login login) async {
    ApiResponse response;
    try {
      return await helper
          .post(Uri.https(base_URL, e_token).toString(), body: login.toJson())
          .then(
        (body) {
          if (body != null)
            response = ApiResponse(success: true, response: body);
          else
            response =
                ApiResponse(success: false, response: msg_something_went_wrong);

          return response;
        },
      );
    } catch (e) {
      response = ApiResponse(success: false, response: false, statusCode: 200);
      return response;
    }
  }

  Future<ApiResponse> loginEndUser(
      BuildContext context, UserLogin login) async {
    ApiResponse response;
    try {
      var queryParameters = {
        j_username: login.username,
        j_password: login.password,
        j_organizationId: login.organizationId.toString()
      };
      print(Uri.https(base_URL, e_user_login, queryParameters).toString());
      return await helper
          .getUser(
              Uri.https(base_URL, e_user_login, queryParameters).toString())
          .then(
        (body) {
          var jsonResponse;

          if (body != null) {
            try {
              jsonResponse = json.decode(body);
              response = ApiResponse(success: true, response: jsonResponse);
            } catch (ex) {
              jsonResponse = body;
              response = ApiResponse(
                success: false,
                response: msg_invalid_user,
              );
            }
          } else
            response =
                ApiResponse(success: false, response: msg_something_went_wrong);

          return response;
        },
      );
    } catch (e) {
      response = ApiResponse(success: false, response: false, statusCode: 200);
      return response;
    }
  }

  Future<ApiResponse> getWebsiteDetails(
      BuildContext context, String locId) async {
    ApiResponse response;
    try {
      return await helper
          .get(Uri.http(base_URL, e_website + locId).toString())
          .then(
        (body) {
          if (body != null)
            response = ApiResponse(success: true, response: body[j_response]);
          else
            response =
                ApiResponse(success: false, response: msg_something_went_wrong);
          return response;
        },
      );
    } catch (e) {
      response = ApiResponse(
        success: false,
        message: msg_something_went_wrong,
        response: false,
        statusCode: 200,
      );
      return response;
    }
  }
}
