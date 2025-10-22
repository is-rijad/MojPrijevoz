import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';

part 'nominatim_search_object.g.dart';

@JsonSerializable()
class NominatimSearchObject extends StringSearchObject {
  int? selectedPlaceId;
  String? selectedPlaceType;
  // Nominatim does not use limit offset pagination
  NominatimSearchObject({
    super.contains,
    this.selectedPlaceId,
    this.selectedPlaceType,
  }) : super(page: -1, pageSize: -1);

  @override
  Map<String, dynamic> toJson() => _$NominatimSearchObjectToJson(this);
}
