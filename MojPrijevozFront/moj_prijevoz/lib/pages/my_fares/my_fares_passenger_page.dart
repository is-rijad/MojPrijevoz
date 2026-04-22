import 'package:flutter/material.dart';
import 'package:moj_prijevoz/components/fare_offer/fare_offer_negotiate_dialog.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/fare_offer_side.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_offer_status.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/widgets/tables/paginated_table.dart';

class MyFaresPassengerPage extends StatefulWidget {
  const MyFaresPassengerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyFaresPassengerPageState();
}

class _MyFaresPassengerPageState extends State<MyFaresPassengerPage> {
  final _searchObject = FareSearchObject(
    page: 1,
    pageSize: 10,
    fareRole: ProfileType.passenger,
  );
  @override
  Widget build(BuildContext context) {
    return PaginatedTable<FareResponse, FareProvider, FareSearchObject>(
      searchObject: _searchObject,
      header: [
        "Početna lokacija",
        "Krajnja lokacija",
        "Broj zaustavnih mijesta",
        "Cijena",
        "Vozač",
        "Vrijeme",
        "Status",
      ],
      items: [
        (i) => Text(i.fareData!.originCity!.name),
        (i) => Text(i.fareData!.trimmedDestinationName),
        (i) => Text(i.fareData!.stopPoints?.length.toString() ?? "0"),
        (i) => Text("${i.lastFareOffer!.totalPrice.toString()}KM"),
        (i) => Text(i.driver!.user!.fullName),
        (i) => Text(i.fareData!.fareDateTime.toString()),
        (i) =>
            (i.lastFareOffer!.side == FareOfferSide.driver &&
                i.lastFareOffer!.status == FareOfferStatus.waitingForResponse)
            ? Badge(child: Text(fareStatusMap[i.status].toString()))
            : Text(fareStatusMap[i.status].toString()),

      ],
      onTap: (i) async =>
          (i!.lastFareOffer!.side == FareOfferSide.driver &&
              i.lastFareOffer!.status == FareOfferStatus.waitingForResponse)
          ? await _buildNegotiateDialog(i)
          : null,
    );
  }

  Future<void> _buildNegotiateDialog(FareResponse? fare) async {
    await showDialog(
      context: context,
      builder: (context) =>
          FareOfferNegotiateDialog(fare: fare!, person: fare.driver!),
    );
  }
}
