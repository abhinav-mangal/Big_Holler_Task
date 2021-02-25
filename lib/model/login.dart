import '../imports.dart';

class Login {
  final String username;
  final String password;

  Login(this.username, this.password);

  Map<String, dynamic> toJson() => toMap(this);

  Map toMap(Login v) {
    var map = new Map<String, dynamic>();
    map[j_username] = v.username;
    map[j_password] = v.password;
    return map;
  }
}
