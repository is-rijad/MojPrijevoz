import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/maps/maps_route_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
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
  late final CityResponse driversCity;
  late final CityResponse passengersCity;
  late MapsRouteResponse routeData;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: const Text("Lokacija vozača"),
      body: LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init),
    );
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Column(
        children: [_buildDriverData(), _buildMap(), _buildFareData()],
      ),
    );
  }

  Future<bool> _init() async {
    driversCity = await context.read<CityProvider>().getById(
      widget.fare.driver!.user!.cityId,
    );
    if (!mounted) return false;
    passengersCity = await context.read<CityProvider>().getById(
      widget.fare.passenger!.user!.cityId,
    );
    await _refreshLocation();
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

  Widget _buildMap() {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          width: 300,
          height: 200,
          child: MapComponent(
            from: NominatimCityDto(
              destinationLong: driversCity.long,
              destinationLat: driversCity.lat,
            ),
            to: NominatimCityDto(
              destinationLong: passengersCity.long,
              destinationLat: passengersCity.lat,
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

  Widget _buildFareData() {
    return Row(
      spacing: 30,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          spacing: 10,

          children: [
            IconFieldWithText(
              iconData: Icons.location_pin,
              text: driversCity.name,
            ),
            IconFieldWithText(
              iconData: Icons.time_to_leave,
              text: passengersCity.name,
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

  Future<void> _refreshLocation() async {
    routeData = await GetIt.I<MapProvider>().getRoute(
      NominatimCityDto(
        destinationLong: driversCity.long,
        destinationLat: driversCity.lat,
      ),
      NominatimCityDto(
        destinationLong: passengersCity.long,
        destinationLat: passengersCity.lat,
      ),
    );
  }
}
