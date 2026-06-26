import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
part 'request_changes_request.g.dart';

@JsonSerializable()
class RequestChangesRequest extends JsonParsable {
  List<String>? selectedItems;
  Map<String, String>? notes;

  RequestChangesRequest({this.notes, this.selectedItems});
  factory RequestChangesRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestChangesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestChangesRequestToJson(this);
}
