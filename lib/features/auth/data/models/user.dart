// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domain/entity/user.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  // final String image;
  // final int gender;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.isAdmin = false,
    // required this.image,
    // required this.gender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isAdmin': isAdmin,
      // 'image': image,
      // 'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      // image: map['image'] ?? '',
      // gender: map['gender'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      isAdmin: isAdmin,
      // image: image,
      // gender: gender,
    );
  }
}
