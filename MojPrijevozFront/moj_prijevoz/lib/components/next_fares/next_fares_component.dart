import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/pages/track_driver_page.dart';
import 'package:moj_prijevoz/pages/track_passenger_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class NextFaresComponent extends StatefulWidget {
  const NextFaresComponent({super.key});

  @override
  State<StatefulWidget> createState() => _NextFaresComponentState();
}

class _NextFaresComponentState extends State<NextFaresComponent> {
  late FareSearchObject _fareSearchObject;
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  final _pageSize = 4;
  late final int _userPassengerProfileId;

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _init() async {
    _fareSearchObject = FareSearchObject(
      pageSize: _pageSize,
      page: 1,
      fareRole: ProfileType.passenger,
    );
    _userPassengerProfileId = (await context.read<AuthProvider>().getProfileId(
      ProfileType.passenger,
    ))!;
    if (!mounted) return false;
    await context.read<FareProvider>().fetchNextFares(_fareSearchObject);
    return true;
  }

  Future<void> _onPageChanged(
    int value,
    SearchResult<FareResponse> searchResult,
  ) async {
    if (searchResult.items.isNotEmpty &&
        value == (_fareSearchObject.pageSize * _fareSearchObject.page) - 1 &&
        searchResult.hasMore) {
      await context.read<FareProvider>().fetchNextFares(_fareSearchObject);
    }
    if (!mounted) return;
    setState(() {
      _currentPage = value;
    });
  }

  Widget _build(BuildContext context) {
    final searchResult = context.watch<FareProvider>().nextFares;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(double.infinity, context.screenHeight * 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [..._buildFares(context, searchResult)],
      ),
    );
  }

  List<Widget> _buildFares(
    BuildContext context,
    SearchResult<FareResponse> searchResult,
  ) {
    if (searchResult.items.isEmpty) {
      return [
        Expanded(child: const Center(child: Text("Nemate zakazanih vožnji!"))),
      ];
    }
    return [
      Flexible(
        fit: FlexFit.loose,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => _onPageChanged(index, searchResult),
          children: searchResult.items
              .map((i) => _buildFareCard(context, i))
              .toList(),
        ),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(searchResult.items.length, (i) {
          final isActive = i == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 12 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? context.primaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    ];
  }

  Widget _buildFareCard(BuildContext context, FareResponse fare) {
    return GestureDetector(
      onTap: () => _trackUser(fare),
      child: Card(
        borderOnForeground: true,
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconFieldWithText(
              iconData: Icons.location_pin,
              text: fare.fareData!.originCity!.name,
            ),
            IconFieldWithText(
              iconData: Icons.location_city,
              text: fare.fareData!.trimmedDestinationName,
            ),
            IconFieldWithText(
              iconData: Icons.calendar_month,
              text: fare.fareData!.fareDateTime.toString(),
            ),
            IconFieldWithText(
              iconData: Icons.watch_later,
              text: fare.fareData!.fareDateTime.toString(),
            ),
            IconFieldWithText(
              iconData: Icons.attach_money,
              text: "${fare.lastFareOffer!.totalPrice}KM",
            ),
            IconFieldWithText(
              iconData: Icons.time_to_leave,
              text: fare.userVehicle!.vehicle.toString(),
            ),
            IconFieldWithText(
              iconData: Icons.numbers,
              text: fare.userVehicle!.licensePlate,
            ),
          ],
        ),
      ),
    );
  }

  Future _trackUser(FareResponse fare) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => fare.passengerId == _userPassengerProfileId
            ? TrackDriverPage(fare: fare)
            : TrackPassengerPage(fare: fare),
      ),
    );
  }
}
