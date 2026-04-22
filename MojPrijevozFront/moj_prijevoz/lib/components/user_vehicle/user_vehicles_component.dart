import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_delete_dialog.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class UserVehiclesComponent extends StatefulWidget {
  final int profileId;
  const UserVehiclesComponent({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _UserVehiclesComponentState();
}

class _UserVehiclesComponentState extends State<UserVehiclesComponent> {
  late UserVehicleSearchObject _userVehicleSearchObject;
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  final _pageSize = 4;

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
    _userVehicleSearchObject = UserVehicleSearchObject(
      profileId: widget.profileId,
      pageSize: _pageSize,
      page: 1,
    );

    await context.read<UserVehicleProvider>().fetchData(
      _userVehicleSearchObject,
    );
    return true;
  }

  Future<void> _onPageChanged(
    int value,
    SearchResult<UserVehicleResponse> searchResult,
  ) async {
    if (searchResult.items.isNotEmpty &&
        value ==
            (_userVehicleSearchObject.pageSize *
                    _userVehicleSearchObject.page) -
                1 &&
        searchResult.hasMore) {
      await context.read<UserVehicleProvider>().fetchData(
        _userVehicleSearchObject,
      );
    }
    if (!mounted) return;
    setState(() {
      _currentPage = value;
    });
  }

  Widget _build(BuildContext context) {
    final searchResult = context.watch<UserVehicleProvider>().searchResult;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(double.infinity, context.screenHeight * 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Moja vozila"),
              ElevatedButton(
                onPressed: () => _buildVehicleUpsertDialog(context, null),
                child: const Text("Dodaj vozilo"),
              ),
            ],
          ),
          ..._buildVehicles(context, searchResult),
        ],
      ),
    );
  }

  Future<void> _buildVehicleUpsertDialog(
    BuildContext context,
    UserVehicleResponse? selectedVehicle,
  ) async {
    await showDialog<UserVehicleResponse>(
      context: context,
      builder: (BuildContext context) {
        return UserVehicleUpsertDialog(selectedItem: selectedVehicle);
      },
    );
  }

  List<Widget> _buildVehicles(
    BuildContext context,
    SearchResult<UserVehicleResponse> searchResult,
  ) {
    if (searchResult.items.isEmpty) {
      return [Expanded(child: const Center(child: Text("Nemate vozila!")))];
    }
    return [
      Flexible(
        fit: FlexFit.loose,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => _onPageChanged(index, searchResult),
          children: searchResult.items
              .map((i) => _buildUserVehicleCard(context, i))
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

  Widget _buildUserVehicleCard(
    BuildContext context,
    UserVehicleResponse userVehicle,
  ) {
    return GestureDetector(
      onTap: () => _buildVehicleUpsertDialog(context, userVehicle),
      onLongPress: () => _buildVehicleDeleteDialog(context, userVehicle),
      onSecondaryTap: () => _buildVehicleDeleteDialog(context, userVehicle),
      child: Card(
        borderOnForeground: true,
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${userVehicle.vehicle.manufacturer} ${userVehicle.vehicle.model}",
            ),
            SizedBox(height: 10),
            _buildVehiclePicture(context, userVehicle),
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.calendar_month,
                        text: userVehicle.modelYear.toString(),
                        iconHint: "Godina proizvodnje",
                      ),
                      SizedBox(height: 10),
                      IconFieldWithText(
                        width: 100,

                        iconData: Icons.numbers,
                        text: userVehicle.licensePlate,
                        iconHint: "Registarske tablice",
                      ),
                      SizedBox(height: 10),
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.money,
                        text: "${userVehicle.pricePerKm.toString()} KM/km",
                        iconHint: "Cijena po kilometru",
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.person,
                        text: userVehicle.vehicle.numberOfSeats.toString(),
                        iconHint: "Broj sjedećih mjesta",
                      ),
                      SizedBox(height: 10),
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.info,
                        text: userVehicleStatusMap[userVehicle.status]!,
                        iconHint: "Status vozila",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclePicture(
    BuildContext context,
    UserVehicleResponse userVehicle,
  ) {
    double imageHeight = 100;
    if (userVehicle.picture != null) {
      return Image.network(userVehicle.picture!, height: imageHeight);
    }
    return Container(
      color: Colors.amber,
      child: Image.asset(
        "images/vehicleFallback.png",
        height: imageHeight,
        color: context.primaryColor,
      ),
    );
  }

  Future<void> _buildVehicleDeleteDialog(
    BuildContext context,
    UserVehicleResponse selectedVehicle,
  ) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return UserVehicleDeleteDialog(selectedItem: selectedVehicle);
      },
    );
  }
}
