import 'package:flutter/material.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_component.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicles_component.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class DriverPage extends StatefulWidget {
  final int profileId;

  const DriverPage({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: _build(context),
      appBarTitle: const Text("Moj profil (vozač)"),
    );
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Broj vožnji"), const Text("0")],
          ),
          SizedBox(height: 20),
          UserVehiclesComponent(profileId: widget.profileId),
          DriversDiscountComponent(profileId: widget.profileId)
        ],
      ),
    );
  }
}
