import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';

class NominatimPlaceSelector {
  NominatimResponse? _locationBound;
  NominatimResponse? get locationBound => _locationBound;
  final NominatimSearchObject searchObject;

  NominatimPlaceSelector({required this.searchObject});
  void selectPlace(NominatimResponse place) {
    _locationBound = place;
    searchObject.contains = place.displayName;
    searchObject.selectedPlaceType = place.osmType;
    searchObject.selectedPlaceId = place.osmId;
  }

  void resetSelection() {
    _locationBound = null;
    searchObject.contains = null;
    searchObject.selectedPlaceType = null;
    searchObject.selectedPlaceId = null;
  }
}
