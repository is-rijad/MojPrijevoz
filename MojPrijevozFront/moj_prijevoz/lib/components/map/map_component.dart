import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/common/wrappers/app_overlay.dart';

class MapComponent extends StatefulWidget {
  final NominatimCityDto? from;
  final NominatimCityDto? to;
  final List<NominatimCityDto>? stopPoints;
  const MapComponent({super.key, this.from, this.to, this.stopPoints});

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  List<LatLng> _routePoints = [];
  NominatimCityDto? startLocation;
  NominatimCityDto? finalLocation;

  final _mapProvider = GetIt.I<MapProvider>();
  final _mapController = MapController();

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _findRoute();
  }

  Future<void> _findRoute() async {
    setState(() {
      _isLoading = true;
      _routePoints.clear();
    });

    final response = await _mapProvider.getRoute(
      widget.from!,
      widget.to!,
      stopPlaces: widget.stopPoints,
      includeLocationNames: false,
    );
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
      _routePoints = response.routePoints;
    });
  }

  void _fitBounds() {
    final bounds = LatLngBounds.fromPoints(_routePoints);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return AppOverlay.buildLoadingContainer(context);
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        onMapReady: _fitBounds,
        initialCenter: LatLng(
          _routePoints.last.latitude,
          _routePoints.last.longitude,
        ),
        initialZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.fit.mojprijevoz',
        ),
        if (widget.from != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  _routePoints.first.latitude,
                  _routePoints.first.longitude,
                ),
                width: 40,
                height: 40,
                child: const Icon(Icons.circle, color: Colors.green, size: 20),
              ),
            ],
          ),
        if (widget.to != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  _routePoints.last.latitude,
                  _routePoints.last.longitude,
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
        if (widget.stopPoints?.isNotEmpty ?? false)
          for (var i = 0; i < widget.stopPoints!.length; i++)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    double.parse(widget.stopPoints![i].lat),
                    double.parse(widget.stopPoints![i].long),
                  ),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ),
        if (_routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                color: Colors.blue,
                strokeWidth: 4,
              ),
            ],
          ),
      ],
    );
  }
}
