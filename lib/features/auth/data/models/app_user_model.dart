import 'package:metube/core/common/entities/user.dart';

class AppUserModel extends AppUser {
  AppUserModel({required super.email, required super.id, required super.name});

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      email: map['email'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
  AppUserModel copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
