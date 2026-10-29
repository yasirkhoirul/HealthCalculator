import 'package:json_annotation/json_annotation.dart';

part 'auth_username_model.g.dart';

@JsonSerializable()
class AuthUsernameModel {
  final String username;
  final String password;

  AuthUsernameModel({required this.username, required this.password});

  factory AuthUsernameModel.fromJson(Map<String, dynamic> json) => _$AuthUsernameModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuthUsernameModelToJson(this);
}