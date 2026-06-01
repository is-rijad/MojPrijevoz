// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      oldPassword: json['oldPassword'] as String?,
      password: json['password'] as String?,
      passwordAgain: json['passwordAgain'] as String?,
      cityId: (json['cityId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'username': instance.username,
      'oldPassword': instance.oldPassword,
      'password': instance.password,
      'passwordAgain': instance.passwordAgain,
      'cityId': instance.cityId,
    };
