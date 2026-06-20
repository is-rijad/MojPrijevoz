import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/fare_location_provider.dart';
import 'package:moj_prijevoz/providers/location_provider.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackPassengerPage extends StatefulWidget {
  final FareResponse fare;
  const TrackPassengerPage({super.key, required this.fare});

  @override
  State<StatefulWidget> createState() => _TrackPassengerPageState();
}

class _TrackPassengerPageState extends State<TrackPassengerPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: "Lokacija putnika",
      body: LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init),
    );
  }

  Widget _build(BuildContext context) {
    return Consumer<FareLocationProvider>(
      builder: (context, provider, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child:
              !(provider.locationReceiver?.isCompleted ?? true) ||
                  provider.location == null ||
                  provider.routeData == null
              ? AppOverlay.buildLoadingContainer(context)
              : SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      _buildPassengerData(),
                      _buildMap(provider),
                      _buildFareData(provider),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<bool> _init() async {
    final driverLocation = await GetIt.I<LocationProvider>().getLocationData();
    if (!mounted) return false;

    context.read<FareLocationProvider>().setMyLocation(driverLocation!);
    if (!mounted) return false;
    await _getLastLocation();
    return true;
  }

  Widget _buildPassengerData() {
    return Column(
      spacing: 10,
      children: [
        Avatar(user: widget.fare.passenger!.user!, maxRadius: 40),
        TextTitleMedium(widget.fare.passenger!.user!.fullName),
      ],
    );
  }

  Widget _buildMap(FareLocationProvider provider) {
    return Column(
      spacing: 10,
      children: [
        SizedBox(
          width: context.screenWidth * 0.7,
          height: context.screenHeight * 0.3,
          child: MapComponent(
            from: NominatimCityDto(
              long: provider.myLocation!.longitude.toString(),
              lat: provider.myLocation!.latitude.toString(),
            ),
            to: NominatimCityDto(
              long: provider.location!.lon,
              lat: provider.location!.lat,
            ),
          ),
        ),
        TextBodyMedium(
          "Posljednje osvježavanje lokacije: ${context.getLocalizedTime(provider.location!.dateTime)}",
        ),
        if (!provider.location!.isAccurate)
          TextBodyMedium(
            "Lokacija nije precizna!",
            fontWeight: FontWeight.bold,
          ),
        if (provider.routeData!.distance! <= 5)
          FractionallySizedBox(
            widthFactor: 0.5,
            child: ElevatedButton(
              onPressed: () async => await launchUrlString(
                "tel://${widget.fare.passenger!.user!.phoneNumber}",
              ),
              child: const Text("Pozovite putnika"),
            ),
          ),
        if (!provider.location!.isAccurate || provider.routeData!.distance! > 5)
          FractionallySizedBox(
            widthFactor: 0.5,
            child: PrimaryButton(
              onPressed: () async => await _refreshLocation(),
              text: "Osvježi lokaciju",
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFareData(FareLocationProvider provider) {
    return Row(
      spacing: 30,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          spacing: 10,
          children: [
            IconFieldWithText(
              iconHint: "Vaša lokacija",
              iconData: Icons.location_pin,
              text:
                  provider.routeData!.startLocationName ?? "Nepoznata lokacija",
            ),
            IconFieldWithText(
              iconHint: "Lokacija putnika",
              iconData: Icons.time_to_leave,
              text:
                  provider.routeData!.finalLocationName ?? "Nepoznata lokacija",
            ),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            IconFieldWithText(
              iconHint: "Trajanje",
              iconData: Icons.timer,
              text:
                  "${provider.routeData!.duration!.round().toString()} minuta",
            ),

            IconFieldWithText(
              iconHint: "Vrijeme dolaska",

              iconData: Icons.watch_later,
              text: context.getLocalizedTime(
                DateTime.now().add(
                  Duration(minutes: provider.routeData!.duration!.toInt()),
                ),
              ),
            ),
            IconFieldWithText(
              iconHint: "Udaljenost",

              iconData: Icons.social_distance,
              text: "${provider.routeData!.distance!.round().toString()}km",
            ),
          ],
        ),
      ],
    );
  }

  Future _refreshLocation() async {
    await context.read<FareLocationProvider>().requestNewLocation(
      widget.fare.passenger!.userId,
    );
  }

  Future<void> _getLastLocation() async {
    await context.read<FareLocationProvider>().getLastLocation(
      widget.fare.passenger!.userId,
    );
  }
}
