import 'package:flutter/material.dart';

abstract class Constants {
  static final usernameRegex = RegExp(r'^\S+$');
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
