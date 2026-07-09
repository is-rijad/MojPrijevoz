import 'package:latlong2/latlong.dart';

class MapProvider {
  LatLng? _selectedLocation;
  LatLng? get selectedLocation => _selectedLocation;
  void setSelectedLocation(LatLng location) {
    _selectedLocation = location;
  }

  void reset() {
    _selectedLocation = null;
  }
}
