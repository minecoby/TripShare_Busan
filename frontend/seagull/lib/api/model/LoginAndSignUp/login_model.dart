// models/user_model.dart
class UserModel {
  final String id;
  final String password;

  UserModel({required this.id, required this.password});

  Map<String, dynamic> toJson() {
    return {"userId": id, "password": password};
  }
}
