import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'subscribe_to_fcm_request.g.dart';

@JsonSerializable()
class SubscribeToFcmRequest implements JsonRequest {
  String? token;
  String? platform;

  SubscribeToFcmRequest({this.token, this.platform});

  @override
  Map<String, dynamic> toJson() => _$SubscribeToFcmRequestToJson(this);

  factory SubscribeToFcmRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscribeToFcmRequestFromJson(json);
}
