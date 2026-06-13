import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/fare_location_provider.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/resources/dtos/fare_location/fare_location_dto.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/maps/maps_route_response.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
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
      builder: (context, provider, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
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
      throw UserException("Nije moguće pronaći lokaciju!");
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
        TextTitleMedium(widget.fare.driver!.user!.fullName),

        IconFieldWithText(
          iconData: Icons.time_to_leave,
          text: widget.fare.userVehicle!.vehicle.toString(),
        ),
        IconFieldWithText(
          iconData: Icons.numbers,
          text: widget.fare.userVehicle!.licensePlate,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMap(FareLocationDto driversLocation) {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          width: context.screenWidth * 0.7,
          height: context.screenHeight * 0.3,
          child: MapComponent(
            from: NominatimCityDto(
              long: driversLocation.lon,
              lat: driversLocation.lat,
            ),
            to: NominatimCityDto(
              long: passengersLocation.longitude.toString(),
              lat: passengersLocation.latitude.toString(),
            ),
          ),
        ),
        TextBodyMedium(
          "Posljednje osvježavanje lokacije: ${context.getLocalizedTime(driversLocation.dateTime)}",
        ),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: PrimaryButton(
            onPressed: _refreshLocation,
            text: "Osvježi lokaciju",
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFareData(FareLocationDto driversLocation) {
    return Row(
      spacing: 30,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          spacing: 10,

          children: [
            IconFieldWithText(
              iconHint: "Lokacija vozača",

              iconData: Icons.location_pin,
              text: routeData.startLocationName ?? "Nepoznata lokacija",
            ),
            IconFieldWithText(
              iconHint: "Vaša lokacija",

              iconData: Icons.time_to_leave,
              text: routeData.finalLocationName ?? "Nepoznata lokacija",
            ),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            IconFieldWithText(
              iconHint: "Trajanje",

              iconData: Icons.timer,
              text: "${routeData.duration!.round().toString()} minuta",
            ),

            IconFieldWithText(
              iconHint: "Vrijeme dolaska",

              iconData: Icons.watch_later,
              text: context.getLocalizedTime(
                DateTime.now().add(
                  Duration(minutes: routeData.duration!.toInt()),
                ),
              ),
            ),
            IconFieldWithText(
              iconHint: "Udaljenost",

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

  Future<void> _refreshRoute(FareLocationDto driversLocation) async {
    routeData = await GetIt.I<MapProvider>().getRoute(
      NominatimCityDto(long: driversLocation.lon, lat: driversLocation.lat),
      NominatimCityDto(
        long: passengersLocation.longitude.toString(),
        lat: passengersLocation.latitude.toString(),
      ),
      includeLocationNames: true,
    );
  }
}
