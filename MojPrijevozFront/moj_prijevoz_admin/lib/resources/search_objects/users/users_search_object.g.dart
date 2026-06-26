// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersSearchObject _$UsersSearchObjectFromJson(Map<String, dynamic> json) =>
    UsersSearchObject(
      contains: json['contains'] as String?,
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      orderBy: json['orderBy'] as String?,
      orderDirection: json['orderDirection'] as String?,
    );

Map<String, dynamic> _$UsersSearchObjectToJson(UsersSearchObject instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'orderBy': instance.orderBy,
      'orderDirection': instance.orderDirection,
      'contains': instance.contains,
    };
