import 'dart:convert';

class User {
  String userId;
  String authId;
  String userName;
  String email;
  String password;
  String userPN;

  User({
    this.userId = "",
    this.authId = "",
    this.userName = "",
    this.email = "",
    this.password = "",
    this.userPN = "",
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? '',
      authId: map['authId'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userPN: map['userPN'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(User user) => {
    "userId": user.userId,
    "authId": user.authId,
    "userName": user.userName,
    "email": user.email,
    "password": user.password,
    "userPN": user.userPN,
  };

  static String encode(User user) => json.encode(User.toMap(user));

  static User decode(String user) => User.fromMap(json.decode(user) as Map<String, dynamic>);
}
