import 'package:flutter/material.dart';
import 'package:moj_prijevoz/components/fare_offer/fare_offer_negotiate_dialog.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/fare_offer_side.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/tables/paginated_table.dart';
import 'package:provider/provider.dart';

class MyFaresDriverPage extends StatefulWidget {
  const MyFaresDriverPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyFaresDriverPageState();
}

class _MyFaresDriverPageState extends State<MyFaresDriverPage> {
  final _searchObject = FareSearchObject(
    page: 1,
    pageSize: 10,
    fareRole: ProfileType.driver,
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
        "Putnik",
        "Vrijeme",
        "Status",
        "",
      ],
      items: [
        (i) => Text(i.fareData!.originCity!.name),
        (i) => Text(i.fareData!.trimmedDestinationName),
        (i) => Text(i.fareData!.stopPoints?.length.toString() ?? "0"),
        (i) => Text("${i.lastFareOffer!.totalPrice.toString()}KM"),
        (i) => Text(i.driver!.user!.fullName),
        (i) => Text(i.fareData!.fareDateTime.toString()),
        (i) =>
            (i.lastFareOffer!.side == FareOfferSide.passenger &&
                i.status == FareStatus.inNegotiation)
            ? Badge(child: Text(fareStatusMap[i.status].toString()))
            : Text(fareStatusMap[i.status].toString()),
        (i) => (i.status == FareStatus.accepted && i.isStartAvailable)
            ? ElevatedButton(
                onPressed: () async => await _buildStartFareDialog(i),
                child: const Text("Pokrenite vožnju"),
              )
            : SizedBox.shrink(),
      ],
      onTap: (i) async =>
          (i!.lastFareOffer!.side == FareOfferSide.passenger &&
              i.status == FareStatus.inNegotiation)
          ? await _buildNegotiateDialog(i)
          : null,
    );
  }

  Future<void> _buildNegotiateDialog(FareResponse? fare) async {
    await showDialog(
      context: context,
      builder: (context) =>
          FareOfferNegotiateDialog(fare: fare!, person: fare.passenger!),
    );
  }

  Future<void> _buildStartFareDialog(FareResponse? fare) async {
    await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        content: const Text(
          "Ukoliko započnete vožnju, putnik će dobiti obavijest da ste krenuli sa svoje lokacije.\nDa li ste sigurni da želite započeti vožnju?",
          textAlign: TextAlign.center,
        ),
        onSubmit: () async {
          await context.read<FareProvider>().start(fare!.id);
        },
        successMessage:
            "Započeli ste vožnju. Sada možete krenuti prema putnikovoj lokaciji.",
      ),
    );
  }
}
