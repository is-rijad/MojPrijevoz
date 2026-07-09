import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz_admin/providers/map_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/city_response.dart';

class MapComponent extends StatefulWidget {
  final CityResponse? location;
  const MapComponent({super.key, this.location});

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final _mapController = MapController();
  CityResponse? location;

  @override
  void initState() {
    super.initState();
    location = widget.location;
    GetIt.I<MapProvider>().setSelectedLocation(
      LatLng(double.parse(location!.lat), double.parse(location!.long)),
    );
  }

  @override
  void didUpdateWidget(covariant MapComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.location == null && widget.location != null) {
      setState(() {
        location = widget.location;
        GetIt.I<MapProvider>().setSelectedLocation(
          LatLng(double.parse(location!.lat), double.parse(location!.long)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter:
            GetIt.I<MapProvider>().selectedLocation ??
            LatLng(double.parse(location!.lat), double.parse(location!.long)),
        initialZoom: 10,
        onTap: (_, LatLng pos) =>
            setState(() => GetIt.I<MapProvider>().setSelectedLocation(pos)),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.fit.mojprijevoz',
        ),
        if (GetIt.I<MapProvider>().selectedLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: GetIt.I<MapProvider>().selectedLocation!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
