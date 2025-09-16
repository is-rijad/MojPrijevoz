import 'package:flutter/material.dart';

abstract class Constants {
  static final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~.,;:?^%]).{8,}$',
  );
  static final usernameRegex = RegExp(r'^\S+$');
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
