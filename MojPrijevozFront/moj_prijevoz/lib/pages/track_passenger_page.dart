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

class TrackPassengerPage extends StatefulWidget {
  final FareResponse fare;
  const TrackPassengerPage({super.key, required this.fare});

  @override
  State<StatefulWidget> createState() => _TrackPassengerPageState();
}

class _TrackPassengerPageState extends State<TrackPassengerPage> {
  late Position driversLocation;
  late MapsRouteResponse routeData;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: "Lokacija putnika",
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
                  _buildPassengerData(),
                  _buildMap(provider.location!),
                  _buildFareData(provider.location!),
                ],
              ),
      ),
    );
  }

  Future<bool> _init() async {
    await context.read<FareLocationProvider>().getLastLocation(
      widget.fare.passenger!.userId,
    );
    final tempDriverLocation = await GetIt.I<LocationProvider>()
        .getLocationData();
    if (tempDriverLocation == null) {
      throw UserException("Morate dozvoliti lokaciju!");
    }
    driversLocation = tempDriverLocation;
    if (!mounted) return false;
    await _refreshRoute(context.read<FareLocationProvider>().location!);
    return true;
  }

  Widget _buildPassengerData() {
    return Column(
      spacing: 10,
      children: [
        Avatar(user: widget.fare.passenger!.user!),
        IconFieldWithText(
          iconData: Icons.person,
          text: widget.fare.passenger!.user!.fullName,
        ),
      ],
    );
  }

  Widget _buildMap(NominatimCityDto passengerLocation) {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          width: 300,
          height: 200,
          child: MapComponent(
            from: NominatimCityDto(
              long: driversLocation.longitude.toString(),
              lat: driversLocation.latitude.toString(),
            ),
            to: NominatimCityDto(
              long: passengerLocation.long,
              lat: passengerLocation.lat,
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

  Widget _buildFareData(NominatimCityDto passengerLocation) {
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
      widget.fare.passenger!.userId,
    );
  }

  Future<void> _refreshRoute(NominatimCityDto passengerLocation) async {
    routeData = await GetIt.I<MapProvider>().getRoute(
      NominatimCityDto(
        long: driversLocation.longitude.toString(),
        lat: driversLocation.latitude.toString(),
      ),
      NominatimCityDto(
        long: passengerLocation.long,
        lat: passengerLocation.lat,
      ),
      includeLocationNames: true,
    );
  }
}
