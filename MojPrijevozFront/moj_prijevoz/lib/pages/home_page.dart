import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/components/next_fares/next_fares_component.dart';
import 'package:moj_prijevoz/components/recommended_drivers/recommended_drivers_component.dart';
import 'package:moj_prijevoz/pages/search_fare_page.dart';
import 'package:moj_prijevoz/providers/fare_location_provider.dart';
import 'package:moj_prijevoz/providers/hub_connection.dart';
import 'package:moj_prijevoz/providers/nominatim_provider.dart';
import 'package:moj_prijevoz/providers/notification_provider.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/responses/notification/notification_response.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/notification/notification_search_object.dart';
import 'package:moj_prijevoz/utils/nominatim_place_selector.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/dialogs/modal_bottom_sheet.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _searchObject = NominatimSearchObject();
  late final NominatimPlaceSelector _nominatimPlaceSelector;
  final HubConnectionProvider hubConnectionProvider =
      GetIt.I<HubConnectionProvider>();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nominatimPlaceSelector = NominatimPlaceSelector(
      searchObject: _searchObject,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    hubConnectionProvider.unsubscribe("NewNotification");
    hubConnectionProvider.unsubscribe("ReceiveLocation");
    hubConnectionProvider.unsubscribe("LocationRequested");
    super.dispose();
  }

  void onNewNotification(List<Object?>? args) async {
    final data = args![0] as Map<String, dynamic>;

    try {
      Constants.messengerKey.currentState!.showSnackBar(
        InfoSnackBar(message: data["message"]),
      );

      Constants.messengerKey.currentContext!
          .read<NotificationProvider>()
          .insertLocally(NotificationResponse.fromJson(data), index: 0);
    } on Exception {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Constants.messengerKey.currentState!.showSnackBar(
          InfoSnackBar(message: data["message"]),
        );
        Constants.messengerKey.currentContext!
            .read<NotificationProvider>()
            .insertLocally(NotificationResponse.fromJson(data), index: 0);
      });
    }
  }

  Future onReceiveLocation(List<Object?>? args) async {
    final data = args![0] as Map<String, dynamic>;
    await context.read<FareLocationProvider>().receiveLocation(data);
  }

  Future sendLocation(List<Object?>? args) async {
    final data = args![0] as String;
    await context.read<FareLocationProvider>().sendLocation(data);
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(
      buildFunction: (context) => _buildHomePage(context),
      futureFunction: _init,
    );
  }

  Future<bool> _init() async {
    await hubConnectionProvider.init();
    hubConnectionProvider.subscribe("NewNotification", onNewNotification);
    hubConnectionProvider.subscribe("ReceiveLocation", onReceiveLocation);
    hubConnectionProvider.subscribe("LocationRequested", sendLocation);

    await GetIt.I<NotificationProvider>().initialize();
    if (!mounted) return false;
    context.read<NotificationProvider>().clearData(
      NotificationSearchObject(page: 1, pageSize: 15),
    );
    await context.read<NotificationProvider>().fetchData(
      NotificationSearchObject(page: 1, pageSize: 15),
    );
    final granted = await hasLocationPermissions();
    if (mounted) setState(() => _hasPermission = granted);
    return true;
  }

  Future<bool> hasLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return false;
      await showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          content: 'GPS je isključen. Otvoriti postavke lokacije?',
          onSubmit: () async {
            await Geolocator.openLocationSettings();
            Constants.navigatorKey.currentState?.pop();
          },
        ),
      );
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.always) {
      if (!mounted) return false;
      await showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          content:
              'Potreban stalni pristup lokaciji.\n'
              'Idite na Dopuštenja > Lokacija > Dopusti cijelo vrijeme.',
          onSubmit: () async {
            await Geolocator.openAppSettings();
            Constants.navigatorKey.currentState?.pop();
          },
        ),
      );
      permission = await Geolocator.checkPermission();
    }
    return permission == LocationPermission.always;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await hubConnectionProvider.init();
      final granted = await hasLocationPermissions();
      if (mounted) setState(() => _hasPermission = granted);
    } else if (state == AppLifecycleState.paused) {
      await hubConnectionProvider.stop();
    }
  }

  Widget _buildHomePage(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        body: Center(
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextHeadlineSmall(
                'Lokacija je potrebna za korištenje aplikacije.',
                textAlign: TextAlign.center,
              ),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: PrimaryButton(
                  onPressed: () async => await hasLocationPermissions(),
                  text: 'Pokušaj ponovo',
                ),
              ),
            ],
          ),
        ),
      );
    }
    return PageWrapper(
      appBarTitle: "Moj prijevoz",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                spacing: 20,
                children: [
                  ..._buildHeadingAndSearch(context),
                  _buildNextFares(context),
                  _buildSuggestedDrivers(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeadingAndSearch(BuildContext context) {
    return [
      const TextTitleMedium("Vožnja koja stiže kada Vama odgovara."),
      Form(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child:
                  AutocompleteTextInput<
                    NominatimResponse,
                    int,
                    NominatimProvider,
                    NominatimSearchObject
                  >(
                    decoration: InputDecorationWithIcon(
                      iconData: Icons.location_on,
                      hintText: "Gdje želite putovati?",
                      iconHint: "Željena destinacija",
                    ),
                    searchObject: _searchObject,
                    getLabel: (i) => i.displayName,
                    getValue: (i) => i.placeId,
                    onTextChanged: (value) {
                      _nominatimPlaceSelector.resetSelection();
                      setState(() {
                        _searchObject.contains = value.isNotEmpty
                            ? value
                            : null;
                      });
                    },
                    onSelectionChanged: (value) {
                      _nominatimPlaceSelector.selectPlace(value);
                      searchLocation();
                    },
                  ),
            ),
            IconButton(
              onPressed: _searchObject.contains != null ? searchLocation : null,
              icon: Icon(Icons.start),
              tooltip: "Započnite",
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildNextFares(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTitleMedium("Vaše zakazane vožnje"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),
          child: NextFaresComponent(),
        ),
      ],
    );
  }

  Widget _buildSuggestedDrivers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTitleMedium("Preporučeni vozači"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 280),
          child: RecommendedDriversComponent(),
        ),
      ],
    );
  }

  Future<void> searchLocation() async {
    if (_searchObject.contains == null) {
      throw UserException("Lokacija je obavezna!");
    }
    if (_nominatimPlaceSelector.locationBound == null) {
      final location =
          await ModalBottomSheet.showModalSheet<
            NominatimResponse,
            NominatimSearchObject,
            NominatimProvider
          >(context, _searchObject, (i) => i.displayName);
      _nominatimPlaceSelector.selectPlace(location);
    }
    if (!mounted) return;
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            SearchFarePage(to: _nominatimPlaceSelector.locationBound!),
      ),
    );
  }
}
