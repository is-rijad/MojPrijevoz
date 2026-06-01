import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

interface class HasPictureInterface {
  @JsonKey(includeFromJson: false, includeToJson: false)
  MultipartFile? picture;
}
