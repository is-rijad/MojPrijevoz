import 'package:latlong2/latlong.dart';

class MapsRouteResponse {
  final List<LatLng> routePoints;
  final String? startLocationName;
  final String? finalLocationName;
  final double? distance;
  final double? duration;

  MapsRouteResponse({
    required this.routePoints,
    required this.distance,
    required this.duration,
    this.startLocationName,
    this.finalLocationName,
  });
}
