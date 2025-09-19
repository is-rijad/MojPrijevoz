import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<StatefulWidget> createState() => _MyProfilState();
}

class _MyProfilState extends State<MyProfile> {
  late final _userProvider = GetIt.I<UserProvider>(param1: LoadingType.global);
  late final UserResponse _userData;
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    var userId = await AccessTokenHandler.getUserId();
    _userData = await _userProvider.getById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: _buildPage(context),
      appBarTitle: const Text("Moj profil"),
    );
  }

  Widget _buildPage(BuildContext context) {
    return SizedBox.shrink();
  }
}
