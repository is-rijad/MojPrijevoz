import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/wrappers/app_overlay.dart';

final textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppOverlay.primaryColor,
  ),
  displayMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppOverlay.primaryColor,
  ),
  displaySmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppOverlay.primaryColor,
  ),
  headlineMedium: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppOverlay.primaryColor,
  ),
  headlineSmall: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Constants.secondaryTextColor,
  ),
  titleLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppOverlay.secondaryColor,
  ),
  titleMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: Constants.secondaryTextColor,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Constants.primaryButtonTextColor,
  ),
  bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  bodyMedium: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight(600),
    color: Constants.secondaryTextColor,
  ),
  bodySmall: const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Constants.secondaryTextColor,
    shadows: [
      Shadow(offset: Offset(0, 2), blurRadius: 4.0, color: Color(0x40000000)),
    ],
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
);
