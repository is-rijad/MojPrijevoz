import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/components/drivers_discount/drivers_discount_component.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicles_component.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/bank_account_number_dialog.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/common/wrappers/load_until_ready_wrapper.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: context.screenWidth * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextLabelLarge("Broj vožnji"),
                        TextLabelLarge(_userProfile.numberOfFares.toString()),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    onPressed: () async =>
                        await _buildBankAccountNumberDialog(),
                    text: "Bank. račun",
                  ),
                ],
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

  Future<void> _buildBankAccountNumberDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BankAccountNumberDialog(isEdit: true);
      },
    );
  }
}
