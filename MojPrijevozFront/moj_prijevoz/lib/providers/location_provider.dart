import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position?> getLocationData() async {
    if (await hasPermissions()) {
      final pos = await Geolocator.getCurrentPosition();
      return pos;
    }
    return null;
  }

  Future<bool> hasPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }
}
