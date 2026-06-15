// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/pages/track_passenger_page.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/profile/show_profile_dialog.dart';
import 'package:moj_prijevoz/pages/my_fares/fare_offer_negotiate_page.dart';
import 'package:moj_prijevoz/pages/review_page.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/fare_offer_side.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_offer_status.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/cards/paginated_cards.dart';
import 'package:moj_prijevoz/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';

class MyFaresDriverPage extends StatefulWidget {
  final int? fareId;
  const MyFaresDriverPage({super.key, this.fareId});

  @override
  State<StatefulWidget> createState() => _MyFaresDriverPageState();
}

class _MyFaresDriverPageState extends State<MyFaresDriverPage> {
  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Future<bool> _init() async {
    if (widget.fareId == null) {
      context.read<FareProvider>().clearData(
        FareSearchObject(
          page: 1,
          pageSize: 5,
          fareRole: ProfileType.driver,
          fareId: widget.fareId,
        ),
      );
    }
    return true;
  }

  Widget _build(BuildContext context) {
    return PaginatedCards<FareSearchObject, FareResponse, FareProvider>(
      spacing: 8,
      searchObject: FareSearchObject(
        page: 1,
        pageSize: 5,
        fareRole: ProfileType.driver,
        fareId: widget.fareId,
      ),
      mainAxisAlignment: MainAxisAlignment.center,

      children: (i) => [
        (i.lastFareOffer!.side == FareOfferSide.passenger &&
                (i.lastFareOffer!.status ==
                        FareOfferStatus.waitingForResponse ||
                    i.lastFareOffer!.status == FareOfferStatus.payed))
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
          onTap: () async => await _showUserProfile(i.passenger!),
          child: Column(
            spacing: 8,
            children: [
              Avatar(user: i.passenger!.user!),
              TextBodyLarge(i.passenger!.user!.fullName),
            ],
          ),
        ),

        IconFieldWithText(
          iconData: Icons.attach_money,
          iconHint: "Cijena",
          text: "${i.lastFareOffer!.totalPrice.toString()}KM",
          textStyle: TextStyle(fontWeight: FontWeight(900), fontSize: 16),
        ),
        (i.status == FareStatus.payed && i.isStartAvailable)
            ? FractionallySizedBox(
                widthFactor: 0.7,
                child: PrimaryButton(
                  onPressed: () async => await _buildStartFareDialog(i),
                  text: "Pokrenite vožnju",
                ),
              )
            : SizedBox.shrink(),
        (canCancel(i))
            ? FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                  onPressed: () async => await _buildCancelFareDialog(i),
                  child: const Text("Otkažite vožnju"),
                ),
              )
            : SizedBox.shrink(),
      ],
      onTap: (i) async => await _onTapCard(i!),
      fallbackText: "Nemate vožnji kao vozač",
    );
  }

  Future<void> _onTapCard(FareResponse fare) async {
    if (fare.lastFareOffer!.side == FareOfferSide.passenger &&
        fare.lastFareOffer!.status == FareOfferStatus.waitingForResponse) {
      await _navigateToNegotiatePage(fare);
    } else if (fare.status == FareStatus.completed) {
      await _navigateToReviewPage(fare);
    }
  }

  Future<void> _navigateToReviewPage(FareResponse fare) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          fare: fare,
          profileType: ProfileType.driver,
          isReadOnly: false,
        ),
      ),
    );
  }

  Future<void> _navigateToNegotiatePage(FareResponse fare) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FareOfferNegotiatePage(fare: fare, person: fare.passenger!),
      ),
    );
  }

  Future<void> _buildStartFareDialog(FareResponse? fare) async {
    bool? isDone = await showDialog<bool?>(
      context: context,
      builder: (context) => ConfirmationDialog(
        content:
            "Ukoliko započnete vožnju, putnik će dobiti obavijest da ste krenuli sa svoje lokacije.\nDa li ste sigurni da želite započeti vožnju?",

        onSubmit: () async {
          await context.read<FareProvider>().start(fare!.id);
          Constants.messengerKey.currentState?.showSnackBar(
            SuccessSnackBar(
              message:
                  "Započeli ste vožnju. Sada možete krenuti prema putnikovoj lokaciji.",
            ),
          );
          if (!context.mounted) return null;
          Navigator.pop(context, true);
        },
      ),
    );
    if ((isDone ?? false) && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackPassengerPage(fare: fare!),
        ),
      );
    }
  }

  Future<void> _buildCancelFareDialog(FareResponse? fare) async {
    final isDone = await showDialog<bool?>(
      context: context,
      builder: (context) => ConfirmationDialog(
        content: "Da li ste sigurni da želite otkazati vožnju?",

        onSubmit: () async {
          await context.read<FareOfferProvider>().cancelWithEvent(
            fare!.lastFareOffer!.id,
          );
          Constants.messengerKey.currentState?.showSnackBar(
            SuccessSnackBar(message: "Otkazali ste vožnju."),
          );
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        },
      ),
    );
    if ((isDone ?? false) && mounted) {
      Navigator.pop(context);
    }
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
        i.status == FareStatus.accepted ||
        i.status == FareStatus.payed;
  }
}
