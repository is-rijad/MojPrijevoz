import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position?> getLocationData() async {
    final pos = await Geolocator.getCurrentPosition();
    return pos;
  }
}
