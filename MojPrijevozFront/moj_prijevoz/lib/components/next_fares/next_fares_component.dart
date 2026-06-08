import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/pages/stripe_payment_page.dart';
import 'package:moj_prijevoz/pages/track_driver_page.dart';
import 'package:moj_prijevoz/pages/track_passenger_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/widgets/cards/mp_card.dart';
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
        value ==
            _fareSearchObject.pageSize * (_fareSearchObject.page - 1) - 1 &&
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [..._buildFares(context, searchResult)],
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
      Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => _onPageChanged(index, searchResult),
          children: searchResult.items
              .map((i) => _buildFareCard(context, i))
              .toList(),
        ),
      ),
      SizedBox(height: 4),
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
    return Banner(
      color: context.primaryColor,
      message: _getBannerMessage(fare),
      location: BannerLocation.topEnd,
      child: MpCard(
        onTap: () async => fare.status == FareStatus.accepted
            ? await _buildPayementDialog(fare)
            : await _trackUser(fare),
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          IconFieldWithText(
            iconData: Icons.home,
            text: fare.fareData!.originCity!.name,
            iconHint: "Početna lokacija",
          ),
          IconFieldWithText(
            iconData: Icons.location_city,
            text: fare.fareData!.trimmedDestinationName,
            iconHint: "Destinacija",
          ),
          SizedBox(height: 12),
          IconFieldWithText(
            iconData: Icons.calendar_month,
            text: context.getLocalizedDate(fare.fareData!.fareDateTime),
            iconHint: "Zakazani datum vožnje",
          ),
          IconFieldWithText(
            iconData: Icons.watch_later,
            text: context.getLocalizedTime(fare.fareData!.fareDateTime),
            iconHint: "Zakazano vrijeme vožnje",
          ),
          SizedBox(height: 12),

          IconFieldWithText(
            iconData: Icons.time_to_leave,
            text: fare.userVehicle!.vehicle.toString(),
            iconHint: "Vozilo",
          ),
          IconFieldWithText(
            iconData: Icons.numbers,
            text: fare.userVehicle!.licensePlate,
            iconHint: "Registarske tablice",
          ),
          SizedBox(height: 12),
          IconFieldWithText(
            iconHint: "Ukupna cijena",
            iconData: Icons.attach_money,
            text: "${fare.lastFareOffer!.totalPrice}KM",
            textStyle: TextStyle(fontWeight: FontWeight(900), fontSize: 16),
          ),
        ],
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

  Future _buildPayementDialog(FareResponse i) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StripePaymentPage(fareOfferId: i.lastFareOffer!.id),
      ),
    );
  }

  String _getBannerMessage(FareResponse fare) {
    if (fare.passengerId == _userPassengerProfileId) {
      if (fare.status == FareStatus.accepted) {
        return "Potrebno platiti";
      } else if (fare.status == FareStatus.inProgress) {
        return "U toku";
      }
      return "Vi ste putnik";
    } else {
      return "Vi ste vozač";
    }
  }
}
