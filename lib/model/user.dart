import '../imports.dart';

class User with ChangeNotifier {
  int id;
  int userTypeId;
  String firstName;
  String lastName;
  String emailAddress;
  String cellPhone;
  String companyName;
  double loyaltyThresholdBalance;
  double loyaltyRewardBalance;

  User({
    this.id,
    this.userTypeId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.cellPhone,
    this.companyName,
    this.loyaltyRewardBalance,
    this.loyaltyThresholdBalance,
  });

  Map<String, dynamic> toJson() {
    var map = Map<String, dynamic>();
    map[j_id] = id;
    map[j_userTypeId] = userTypeId;
    map[j_firstName] = firstName;
    map[j_lastName] = lastName;
    map[j_emailAddress] = emailAddress;
    map[j_cellPhone] = cellPhone;
    map[j_companyName] = companyName;
    map[j_loyaltyThresholdBalance] = loyaltyThresholdBalance;
    map[j_loyaltyRewardBalance] = loyaltyRewardBalance;
    return map;
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map[j_id],
      userTypeId: map[j_userTypeId],
      firstName: map[j_firstName],
      lastName: map[j_lastName],
      emailAddress: map[j_emailAddress],
      cellPhone: map[j_cellPhone],
      companyName: map[j_companyName],
      loyaltyThresholdBalance: map[j_loyaltyThresholdBalance],
      loyaltyRewardBalance: map[j_loyaltyRewardBalance],
    );
  }
}

class UserLogin {
  String username;
  String password;
  int organizationId;

  UserLogin({this.username, this.password, this.organizationId});

  Map<String, dynamic> toJson() => toMap(this);

  Map toMap(UserLogin u) {
    var map = new Map<String, dynamic>();
    map[j_username] = u.username;
    map[j_password] = u.password;
    map[j_organizationId] = u.organizationId;
    return map;
  }

  factory UserLogin.fromJson(Map<String, dynamic> map) {
    return UserLogin(
      username: map[j_username],
      password: map[j_password],
      organizationId: map[j_organizationId],
    );
  }
}
