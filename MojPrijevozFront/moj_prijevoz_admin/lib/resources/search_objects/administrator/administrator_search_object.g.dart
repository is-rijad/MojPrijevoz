// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'administrator_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdministratorSearchObject _$AdministratorSearchObjectFromJson(
  Map<String, dynamic> json,
) => AdministratorSearchObject(
  contains: json['contains'] as String?,
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  orderBy: json['orderBy'] as String?,
  orderDirection: json['orderDirection'] as String?,
);

Map<String, dynamic> _$AdministratorSearchObjectToJson(
  AdministratorSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'orderBy': instance.orderBy,
  'orderDirection': instance.orderDirection,
  'contains': instance.contains,
};
