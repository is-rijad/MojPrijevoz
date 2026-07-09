import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare_data/fare_data_response.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'fare_response.g.dart';

@JsonSerializable()
class FareResponse extends JsonResponse {
  @override
  final int id;
  final int fareDataId;
  final FareDataResponse? fareData;
  FareResponse({required this.id, required this.fareDataId, this.fareData});

  factory FareResponse.fromJson(Map<String, dynamic> json) =>
      _$FareResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FareResponseToJson(this);
}
