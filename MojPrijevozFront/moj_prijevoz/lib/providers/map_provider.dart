import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/requests/maps/maps_route_request.dart';
import 'package:moj_prijevoz/resources/responses/maps/maps_route_response.dart';

class MapProvider {
  final _dio = Dio(HttpProvider.dioBaseOptions);
  final _openRouteApiUrl = Environment.openRouteApiUrl;
  final _openReverseApiUrl = Environment.openReverseApiUrl;
  final _openRouteKey = Environment.openRouteKey;

  Future<MapsRouteResponse> getRoute(
    NominatimCityDto cityFrom,
    NominatimCityDto cityTo, {
    List<NominatimCityDto>? stopPlaces,
    required bool includeLocationNames,
  }) async {
    try {
      final stopPlaceCoordinates = List.empty(growable: true);
      for (var i = 0; i < (stopPlaces?.length ?? 0); i++) {
        stopPlaceCoordinates.add([stopPlaces![i].long, stopPlaces[i].lat]);
      }
      final body = MapsRouteRequest(
        coordinates: [
          [cityFrom.long, cityFrom.lat],
          ...stopPlaceCoordinates,
          [cityTo.long, cityTo.lat],
        ],
        radiuses: [-1],
        units: "km",
      );
      final response = await _dio.post(
        "${_openRouteApiUrl}directions/driving-car",
        data: body.toJson(),
        options: _setRequestOptions(),
      );
      final startLocationName = includeLocationNames
          ? await _getLocationName(cityFrom.lat, cityFrom.long)
          : null;
      final finalLocationName = includeLocationNames
          ? await _getLocationName(cityTo.lat, cityTo.long)
          : null;
      return MapsRouteResponse(
        routePoints: _decodePolyline(response.data["routes"][0]["geometry"]),
        distance: response.data["routes"][0]["summary"]["distance"],
        duration: response.data["routes"][0]["summary"]["duration"] / 60,
        startLocationName: startLocationName,
        finalLocationName: finalLocationName,
      );
    } on DioException {
      throw UserException("Greška prilikom preuzimanja rute!");
    }
  }

  Future<String> _getLocationName(String lat, String long) async {
    final response = await _dio.get(
      "$_openReverseApiUrl?api_key=$_openRouteKey&point.lat=$lat&point.lon=$long&layers=street",
    );
    return response.data["features"][0]["properties"]["name"];
  }

  List<LatLng> _decodePolyline(String encoded) {
    final result = PolylinePoints.decodePolyline(encoded);

    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  Options _setRequestOptions() {
    var options = Options(contentType: "application/json");
    var headersMap = <String, dynamic>{};
    try {
      headersMap.addEntries(
        <String, dynamic>{"Authorization": _openRouteKey}.entries,
      );
      // ignore: empty_catches
    } on Exception {}
    options.headers = headersMap;
    return options;
  }
}
