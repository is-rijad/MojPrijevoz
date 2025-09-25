import 'package:flutter/material.dart';
import 'package:moj_prijevoz/widgets/wrappers/app_overlay.dart';

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
    color: AppOverlay.primaryColor,
  ),
  titleLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppOverlay.secondaryColor,
  ),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppOverlay.secondaryColor,
  ),
  titleSmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppOverlay.secondaryColor,
  ),
  bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppOverlay.secondaryColor,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppOverlay.secondaryColor,
  ),
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppOverlay.secondaryColor,
  ),
);
