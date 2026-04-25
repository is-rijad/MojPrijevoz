import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class ShowProfileDialog extends StatefulWidget {
  final int profileId;
  const ShowProfileDialog({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _ShowProfileDialogState();
}

class _ShowProfileDialogState extends State<ShowProfileDialog> {
  late final UserProfileResponse userProfile;
  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return Dialog(elevation: 4, child: _buildDialog());
  }

  Future<bool> _init() async {
    userProfile = await context.read<UserProfileProvider>().getById(
      widget.profileId,
    );
    return true;
  }

  Widget _buildDialog() {
    return SizedBox.fromSize(
      size: Size(context.screenWidth * 0.5, context.screenHeight * 0.7),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.cancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
