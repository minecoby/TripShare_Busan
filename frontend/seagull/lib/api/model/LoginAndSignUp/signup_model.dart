// models/user_model.dart
class UserModel {
  final String id;
  final String password;
  final String name;
  final String email;
  // final String code;

  UserModel({
    required this.id,
    required this.password,
    required this.name,
    required this.email,
    // required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": id,
      "password": password,
      "name": name,
      "email": email,
      // "code": code,
    };
  }
}
