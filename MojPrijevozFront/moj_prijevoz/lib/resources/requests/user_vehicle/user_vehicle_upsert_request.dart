import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/requests/has_picture_interface.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'user_vehicle_upsert_request.g.dart';

@JsonSerializable()
class UserVehicleUpsertRequest extends JsonRequest
    implements HasPictureInterface {
  int? vehicleId;
  int? modelYear;
  String? licensePlate;
  double? pricePerKm;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  MultipartFile? picture;

  UserVehicleUpsertRequest({
    this.vehicleId,
    this.modelYear,
    this.licensePlate,
    this.pricePerKm,
    this.picture,
  });

  @override
  Map<String, dynamic> toJson() => _$UserVehicleUpsertRequestToJson(this);

  factory UserVehicleUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleUpsertRequestFromJson(json);
}
