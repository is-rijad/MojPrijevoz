import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/search_objects/fare/fare_search_object.dart';
import 'package:moj_prijevoz/widgets/tables/paginated_table.dart';

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
      ],
      items: [
        (i) => Text(i.fareData!.originCity!.name),
        (i) => Text(i.fareData!.trimmedDestinationName),
        (i) => Text(i.fareData!.stopPoints?.length.toString() ?? "0"),
        (i) => Text("${i.fareData!.fareOffers!.last.totalPrice.toString()}KM"),
        (i) => Text(i.passenger!.user!.fullName),
        (i) => Text(i.fareData!.fareDateTime.toString()),
        (i) => Text(fareStatusMap[i.status].toString()),
      ],
    );
  }
}
