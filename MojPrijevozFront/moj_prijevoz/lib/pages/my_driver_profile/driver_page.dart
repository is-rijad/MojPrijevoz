import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_component.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicles_component.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
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
      appBarTitle: "Moj profil (vozač)",
    );
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: context.screenWidth * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // TODO: Change to actual number of fares
                children: [
                  const TextLabelLarge("Broj vožnji"),
                  const TextLabelLarge("0"),
                ],
              ),
            ),

            SizedBox(height: 20),
            UserVehiclesComponent(profileId: widget.profileId),
            DriversDiscountComponent(profileId: widget.profileId),
          ],
        ),
      ),
    );
  }
}
