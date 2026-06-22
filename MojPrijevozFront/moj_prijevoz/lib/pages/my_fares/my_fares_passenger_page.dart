import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/profile/show_profile_dialog.dart';
import 'package:moj_prijevoz/pages/my_fares/fare_offer_negotiate_page.dart';
import 'package:moj_prijevoz/pages/review_page.dart';
import 'package:moj_prijevoz/pages/stripe_payment_page.dart';
import 'package:moj_prijevoz/pages/track_driver_page.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/fare_offer_side.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_offer_status.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/cards/paginated_cards.dart';
import 'package:moj_prijevoz/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/common/widgets/snackbars.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/common/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class MyFaresPassengerPage extends StatefulWidget {
  final int? fareId;
  const MyFaresPassengerPage({super.key, this.fareId});

  @override
  State<StatefulWidget> createState() => _MyFaresPassengerPageState();
}

class _MyFaresPassengerPageState extends State<MyFaresPassengerPage>
    with RouteAware {
  late final FareSearchObject _fareSearchObject;
  final _pageController = PageController(viewportFraction: 0.6);
  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  @override
  void initState() {
    _fareSearchObject = FareSearchObject(
      page: 1,
      pageSize: 5,
      fareRole: ProfileType.passenger,
    );
    if (widget.fareId == null) {
      _fareSearchObject.fareId = widget.fareId;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Constants.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  Future<bool> _init() async {
    context.read<FareProvider>().clearData(_fareSearchObject);
    return true;
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      context.read<FareProvider>().clearData(_fareSearchObject);
      await context.read<FareProvider>().fetchData(_fareSearchObject);
      if (!mounted || !_pageController.hasClients) return;
      _pageController.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget _build(BuildContext context) {
    return PaginatedCards<FareSearchObject, FareResponse, FareProvider>(
      spacing: 8,
      pageController: _pageController,
      searchObject: _fareSearchObject,
      mainAxisAlignment: MainAxisAlignment.center,
      fallbackText: "Nemate vožnji kao putnik!",
      children: (i) => [
        (i.lastFareOffer!.side == FareOfferSide.driver &&
                (i.status == FareStatus.inNegotiation ||
                    i.status == FareStatus.payed ||
                    i.status == FareStatus.inProgress ||
                    i.status == FareStatus.accepted))
            ? Badge(
                child: IconFieldWithText(
                  iconData: Icons.info,
                  iconHint: "Status vožnje",
                  text: fareStatusMap[i.status].toString(),
                  textStyle: TextStyle(
                    fontWeight: FontWeight(900),
                    fontSize: 16,
                  ),
                ),
              )
            : IconFieldWithText(
                iconData: Icons.info,
                iconHint: "Status vožnje",
                text: fareStatusMap[i.status].toString(),
                textStyle: TextStyle(fontWeight: FontWeight(900), fontSize: 16),
              ),
        IconFieldWithText(
          iconData: Icons.home,
          iconHint: "Početna lokacija",

          text: i.fareData!.originCity!.name,
        ),
        if ((i.fareData!.stopPoints?.length ?? 0) != 0)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  clampDouble(
                    double.parse(i.fareData!.stopPoints!.length.toString()),
                    1,
                    3,
                  ) *
                  25,
              maxWidth: context.screenWidth - 80,
            ),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 1,
                    height: i.fareData!.stopPoints!.length * 25,
                    color: context.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: i.fareData!.stopPoints!
                        .map(
                          (i) => IconFieldWithText(
                            iconHint: "Zaustavno mjesto",

                            iconData: Icons.add_location,
                            text: i.trimmedName,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

        IconFieldWithText(
          iconData: Icons.location_city,
          iconHint: "Destinacija",

          text: i.fareData!.trimmedDestinationName,
        ),

        IconFieldWithText(
          iconData: Icons.calendar_month,
          iconHint: "Zakazani datum vožnje",

          text: context.getLocalizedDate(i.fareData!.fareDateTime),
        ),
        IconFieldWithText(
          iconData: Icons.watch_later,
          iconHint: "Zakazano vrijeme vožnje",

          text: context.getLocalizedTime(i.fareData!.fareDateTime),
        ),
        GestureDetector(
          onTap: () async => await _showUserProfile(i.driver!),
          child: Column(
            spacing: 8,
            children: [
              Avatar(user: i.driver!.user!),
              TextBodyLarge(i.driver!.user!.fullName),
            ],
          ),
        ),
        IconFieldWithText(
          iconData: Icons.attach_money,
          iconHint: "Cijena",
          text: "${i.lastFareOffer!.totalPrice.roundToDouble().toString()}KM",
          textStyle: TextStyle(fontWeight: FontWeight(900), fontSize: 16),
        ),
        (_canPay(i))
            ? FractionallySizedBox(
                widthFactor: 0.6,
                child: PrimaryButton(
                  onPressed: () async => await _buildPayementDialog(i),
                  text: "Platite",
                ),
              )
            : SizedBox.shrink(),
        (canCancel(i))
            ? FractionallySizedBox(
                widthFactor: 0.6,
                child: ElevatedButton(
                  onPressed: () async => await _buildCancelFareDialog(i),
                  child: const Text("Otkažite"),
                ),
              )
            : SizedBox.shrink(),
        if (_canPay(i))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextLabelSmall(
                    "* vožnju možete platiti najkasnije do ${context.getLocalizedDate(i.fareStartAfter!.subtract(Duration(minutes: 60)))} ${context.getLocalizedTime(i.fareStartAfter!.subtract(Duration(minutes: 60)))}",
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
      ],
      onTap: (i) => _onTapCard(i!),
    );
  }

  bool _canPay(FareResponse fare) {
    return fare.status == FareStatus.accepted &&
        fare.fareStartAfter!
            .subtract(Duration(minutes: 60))
            .isAfter(DateTime.now().toUtc());
  }

  Future<void> _onTapCard(FareResponse fare) async {
    if (fare.lastFareOffer!.side == FareOfferSide.driver &&
        fare.lastFareOffer!.status == FareOfferStatus.waitingForResponse) {
      await _navigateToNegotiatePage(fare);
    } else if (fare.status == FareStatus.inProgress) {
      await _trackUser(fare);
    } else if (fare.status == FareStatus.completed) {
      await _navigateToReviewPage(fare);
    } else if (_canPay(fare)) {
      await _buildPayementDialog(fare);
    }
  }

  Future _trackUser(FareResponse fare) async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => TrackDriverPage(fare: fare)),
    );
  }

  Future<void> _navigateToNegotiatePage(FareResponse fare) async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            FareOfferNegotiatePage(fare: fare, person: fare.driver!),
      ),
    );
  }

  Future<void> _navigateToReviewPage(FareResponse fare) async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          fare: fare,
          profileType: ProfileType.passenger,
          isReadOnly: false,
        ),
      ),
    );
  }

  Future<void> _buildCancelFareDialog(FareResponse? fare) async {
    await showDialog<bool?>(
      context: context,
      builder: (context) => ConfirmationDialog(
        content: "Da li ste sigurni da želite otkazati vožnju?",

        onSubmit: () async {
          await context.read<FareOfferProvider>().cancel(
            fare!.lastFareOffer!.id,
          );
          if (context.mounted) {
            Constants.navigatorKey.currentState?.pop(true);
          }
          Constants.messengerKey.currentState?.showSnackBar(
            SuccessSnackBar(message: "Otkazali ste vožnju."),
          );
        },
      ),
    );
  }

  Future<void> _showUserProfile(UserProfileResponse userProfile) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ShowProfileDialog(profileId: userProfile.id);
      },
    );
  }

  bool canCancel(FareResponse i) {
    return i.status == FareStatus.inNegotiation ||
        i.status == FareStatus.accepted;
  }

  Future _buildPayementDialog(FareResponse i) async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            StripePaymentPage(fareOfferId: i.lastFareOffer!.id),
      ),
    );
  }
}
