import '../imports.dart';
import 'dart:convert';
import 'dart:async';

class SPHelper {
  static final String _notificationToken = "NotificationToken";
  static final String _appIntro = "ApplicationIntro";
  static final String _appToken = "token";
  static final String _metadata = 'Metadata';
  static final String _userdata = 'User';
  static final String _userlogindata = 'UserLogin';
  static final String _locationMetadata = 'LocationMetadat';
  static final String _imagedata = 'ImageData';

  static Future<bool> getAppIntro() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(_appIntro) ?? true;
  }

  static Future<bool> setAppIntro(bool status) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(_appIntro, status);
  }

  static Future<bool> setNotificationToken(String notificationToken) async {
    if (notificationToken == null || notificationToken.isEmpty) return false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_notificationToken, notificationToken);
  }

  static Future<String> getNotificationToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_notificationToken);
  }

  static Future<String> getAppToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_appToken) ?? '';
  }

  static Future<bool> setAppToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(_appToken, 'bearer $token');
  }

  static Future<bool> setMetaData(Metadatas metadatas) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = metadatas.toJson();
    var metadataJson = jsonEncode(data);
    return prefs.setString(_metadata, metadataJson);
  }

  static Future<Metadatas> getMetadata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonData = prefs.getString(_metadata);
    if (jsonData == null) {
      return null;
    }
    Map<String, dynamic> jsonMapObj = jsonDecode(jsonData);
    Metadatas metadata = Metadatas.fromJson(jsonMapObj[j_metadatas] as List);
    return metadata;
  }

  static Future<bool> setImagesData(imagesData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var imagesDataJson = jsonEncode(imagesData);
    return prefs.setString(_imagedata, imagesDataJson);
  }

  static Future getImagesData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonData = prefs.getString(_imagedata);
    if (jsonData == null) {
      return null;
    }
    var imageData = jsonDecode(jsonData);
    return imageData;
  }

  static Future<bool> setUserData(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = user.toJson();
    var userJson = jsonEncode(data);
    return prefs.setString(_userdata, userJson);
  }

  static Future<User> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonData = prefs.getString(_userdata);
    if (jsonData == null) {
      return null;
    }
    Map<String, dynamic> jsonMapObj = jsonDecode(jsonData);
    User user = User.fromJson(jsonMapObj);
    return user;
  }

  static Future<bool> setUserLoginData(UserLogin userLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = userLogin.toJson();
    var userJson = jsonEncode(data);
    return prefs.setString(_userlogindata, userJson);
  }

  static Future<UserLogin> getUserLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonData = prefs.getString(_userlogindata);
    if (jsonData == null) {
      return null;
    }
    Map<String, dynamic> jsonMapObj = jsonDecode(jsonData);
    UserLogin userLogin = UserLogin.fromJson(jsonMapObj);
    return userLogin;
  }

  static Future<bool> setLocationMetadata(Metadata metadata) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (metadata != null)
      FirebaseMessaging().subscribeToTopic(metadata.id.toString());

    var data = metadata.toJson();
    var locJson = jsonEncode(data);
    return prefs.setString(_locationMetadata, locJson);
  }

  static Future<Metadata> getLocationMetadat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonData = prefs.getString(_locationMetadata);
    if (jsonData == null) return null;

    Map<String, dynamic> jsonMapObj = jsonDecode(jsonData);
    Metadata metadata = Metadata.fromJson(jsonMapObj);
    return metadata;
  }

  static void clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
