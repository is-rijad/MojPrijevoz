import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/become_driver_page.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/driver_page.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';

class MyDriverProfile extends StatefulWidget {
  const MyDriverProfile({super.key});

  @override
  State<StatefulWidget> createState() => _MyDriverProfileState();
}

class _MyDriverProfileState extends State<MyDriverProfile> {
  final _profileId = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Future<bool> _init() async {
    _profileId.value = await AccessTokenHandler.getProfileId(
      ProfileType.driver,
    );
    return true;
  }

  Widget _build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: _profileId,
      builder: (context, value, _) {
        if (value == null) {
          return BecomeDriverPage(profileIdNotifier: _profileId);
        }
        return DriverPage(profileId: value);
      },
    );
  }
}
