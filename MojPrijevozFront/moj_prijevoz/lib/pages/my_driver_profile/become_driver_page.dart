import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/components/user_vehicle/user_vehicle_upsert_dialog.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class BecomeDriverPage extends StatefulWidget {
  final ValueNotifier<int?> profileIdNotifier;

  const BecomeDriverPage({super.key, required this.profileIdNotifier});

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
      var response = await GetIt.I<AuthProvider>().getNewToken();
      await AccessTokenHandler.setAccessToken(response.token);
      widget.profileIdNotifier.value = await AccessTokenHandler.getProfileId(
        ProfileType.driver,
      );
    }
  }
}
