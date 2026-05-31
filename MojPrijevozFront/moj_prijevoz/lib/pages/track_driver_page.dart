import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/fare_location_provider.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/maps/maps_route_response.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class TrackDriverPage extends StatefulWidget {
  final FareResponse fare;
  const TrackDriverPage({super.key, required this.fare});

  @override
  State<StatefulWidget> createState() => _TrackDriverPageState();
}

class _TrackDriverPageState extends State<TrackDriverPage> {
  late Position passengersLocation;
  late MapsRouteResponse routeData;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: "Lokacija vozača",
      body: LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init),
    );
  }

  Widget _build(BuildContext context) {
    return Consumer<FareLocationProvider>(
      builder: (context, provider, _) => Center(
        child: provider.location == null
            ? AppOverlay.buildLoadingContainer(context)
            : Column(
                children: [
                  _buildDriverData(),
                  _buildMap(provider.location!),
                  _buildFareData(provider.location!),
                ],
              ),
      ),
    );
  }

  Future<bool> _init() async {
    await context.read<FareLocationProvider>().getLastLocation(
      widget.fare.driver!.userId,
    );
    final tempPassengerLocation = await GetIt.I<LocationProvider>()
        .getLocationData();
    if (tempPassengerLocation == null) {
      throw UserException("Morate dozvoliti lokaciju!");
    }
    passengersLocation = tempPassengerLocation;
    if (!mounted) return false;
    await _refreshRoute(context.read<FareLocationProvider>().location!);
    return true;
  }

  Widget _buildDriverData() {
    return Column(
      spacing: 10,
      children: [
        Avatar(user: widget.fare.driver!.user!),
        IconFieldWithText(
          iconData: Icons.person,
          text: widget.fare.driver!.user!.fullName,
        ),
        IconFieldWithText(
          iconData: Icons.time_to_leave,
          text: widget.fare.userVehicle!.vehicle.toString(),
        ),
        IconFieldWithText(
          iconData: Icons.numbers,
          text: widget.fare.userVehicle!.licensePlate,
        ),
      ],
    );
  }

  Widget _buildMap(NominatimCityDto driversLocation) {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          width: 300,
          height: 200,
          child: MapComponent(
            from: NominatimCityDto(
              long: driversLocation.long,
              lat: driversLocation.lat,
            ),
            to: NominatimCityDto(
              long: passengersLocation.longitude.toString(),
              lat: passengersLocation.latitude.toString(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _refreshLocation,
          child: const Text("Osvježi lokaciju"),
        ),
      ],
    );
  }

  Widget _buildFareData(NominatimCityDto driversLocation) {
    return Row(
      spacing: 30,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          spacing: 10,

          children: [
            IconFieldWithText(
              iconData: Icons.location_pin,
              text: routeData.startLocationName ?? "Nepoznata lokacija",
            ),
            IconFieldWithText(
              iconData: Icons.time_to_leave,
              text: routeData.finalLocationName ?? "Nepoznata lokacija",
            ),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            IconFieldWithText(
              iconData: Icons.timer,
              text: "${routeData.duration!.round().toString()} minuta",
            ),

            IconFieldWithText(
              iconData: Icons.watch_later,
              text: DateTime.now()
                  .add(Duration(minutes: routeData.duration!.toInt()))
                  .toString(),
            ),
            IconFieldWithText(
              iconData: Icons.social_distance,
              text: "${routeData.distance!.round().toString()}km",
            ),
          ],
        ),
      ],
    );
  }

  void _refreshLocation() {
    context.read<FareLocationProvider>().requestNewLocation(
      widget.fare.driver!.userId,
    );
  }

  Future<void> _refreshRoute(NominatimCityDto driversLocation) async {
    routeData = await GetIt.I<MapProvider>().getRoute(
      NominatimCityDto(long: driversLocation.long, lat: driversLocation.lat),
      NominatimCityDto(
        long: passengersLocation.longitude.toString(),
        lat: passengersLocation.latitude.toString(),
      ),
      includeLocationNames: true,
    );
  }
}
