import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/profile/show_profile_dialog.dart';
import 'package:moj_prijevoz/pages/my_fares/fare_offer_negotiate_page.dart';
import 'package:moj_prijevoz/pages/stripe_payment_page.dart';
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
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';

class MyFaresPassengerPage extends StatefulWidget {
  const MyFaresPassengerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyFaresPassengerPageState();
}

class _MyFaresPassengerPageState extends State<MyFaresPassengerPage> {
  @override
  Widget build(BuildContext context) {
    return PaginatedCards<FareSearchObject, FareResponse, FareProvider>(
      spacing: 8,
      searchObject: FareSearchObject(
        page: 1,
        pageSize: 5,
        fareRole: ProfileType.passenger,
      ),
      mainAxisAlignment: MainAxisAlignment.center,
      fallbackText: "Nemate vožnji kao putnik!",
      children: (i) => [
        (i.lastFareOffer!.side == FareOfferSide.driver &&
                i.lastFareOffer!.status == FareOfferStatus.waitingForResponse)
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
          text: "${i.lastFareOffer!.totalPrice.toString()}KM",
          textStyle: TextStyle(fontWeight: FontWeight(900), fontSize: 16),
        ),
        (i.status == FareStatus.accepted)
            ? FractionallySizedBox(
                widthFactor: 0.7,
                child: PrimaryButton(
                  onPressed: () async => await _buildPayementDialog(i),
                  text: "Platite vožnju",
                ),
              )
            : SizedBox.shrink(),
      ],
      onTap: (i) async =>
          (i!.lastFareOffer!.side == FareOfferSide.driver &&
              i.lastFareOffer!.status == FareOfferStatus.waitingForResponse)
          ? await _navigateToNegotiatePage(i)
          : null,
    );
  }

  Future<void> _navigateToNegotiatePage(FareResponse fare) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FareOfferNegotiatePage(fare: fare, person: fare.driver!),
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

  Future _buildPayementDialog(FareResponse i) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StripePaymentPage(fareOfferId: i.lastFareOffer!.id),
      ),
    );
  }
}
