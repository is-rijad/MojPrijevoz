import 'package:geolocator/geolocator.dart';
import 'package:moj_prijevoz/common/user_exception.dart';

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
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always) {
        await Geolocator.openAppSettings();
      }
    }

    return true;
  }
}
