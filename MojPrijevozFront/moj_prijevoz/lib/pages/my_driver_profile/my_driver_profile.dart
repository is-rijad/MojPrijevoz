import 'package:flutter/material.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/become_driver_page.dart';
import 'package:moj_prijevoz/pages/my_driver_profile/driver_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyDriverProfile extends StatefulWidget {
  const MyDriverProfile({super.key});

  @override
  State<StatefulWidget> createState() => _MyDriverProfileState();
}

class _MyDriverProfileState extends State<MyDriverProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, _) {
        if (value.accessTokenPayload.driverProfileId == null) {
          return BecomeDriverPage(
            profileId: value.accessTokenPayload.driverProfileId,
          );
        }
        return DriverPage(profileId: value.accessTokenPayload.driverProfileId!);
      },
    );
  }
}
