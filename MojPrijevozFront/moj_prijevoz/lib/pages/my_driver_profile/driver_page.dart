import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_component.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicles_component.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class DriverPage extends StatefulWidget {
  final int profileId;

  const DriverPage({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  late final UserProfileResponse _userProfile;

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      appBarTitle: "Moj profil (vozač)",
      body: Padding(
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
                  children: [
                    const TextLabelLarge("Broj vožnji"),
                    TextLabelLarge(_userProfile.numberOfFares.toString()),
                  ],
                ),
              ),

              SizedBox(height: 20),
              UserVehiclesComponent(profileId: widget.profileId),
              DriversDiscountComponent(profileId: widget.profileId),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _init() async {
    _userProfile = await context.read<UserProfileProvider>().getById(
      widget.profileId,
    );
    return true;
  }
}
