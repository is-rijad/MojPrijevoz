import 'package:flutter/material.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
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
    return PageWrapper(
      body: _build(context),
      appBarTitle: const Text("Postani vozač"),
    );
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Još niste vozač?"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _buildVehicleInsertDialog(context),
            child: const Text("Postanite vozač"),
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
