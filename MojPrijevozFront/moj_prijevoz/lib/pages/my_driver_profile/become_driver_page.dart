import 'package:flutter/material.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class BecomeDriverPage extends StatefulWidget {
  final int? profileId;

  const BecomeDriverPage({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _BecomeDriverPageState();
}

class _BecomeDriverPageState extends State<BecomeDriverPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Postani vozač");
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 1.2,
            child: Image.asset("images/vehiclePlaceholder.png"),
          ),
          const TextTitleMedium("Još niste vozač?"),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: PrimaryButton(
              onPressed: () => _buildVehicleInsertDialog(context),
              text: "Postanite vozač",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildVehicleInsertDialog(BuildContext context) async {
    final addedItem = await showDialog<UserVehicleResponse>(
      context: context,
      builder: (BuildContext context) {
        return UserVehicleUpsertDialog(selectedItem: null);
      },
    );
    if (addedItem != null) {
      if (!context.mounted) return;

      await context.read<AuthProvider>().getNewToken();
    }
  }
}
