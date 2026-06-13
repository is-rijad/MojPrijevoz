import 'package:flutter/material.dart';

abstract class Constants {
  static final usernameRegex = RegExp(r'^\S+$');
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const userAgent = "MojPrijevoz (rijad.isirlija@edu.fit.ba)";
  static const double autoCompleteTextInputElementHeight = 50;
  static const Color secondaryTextColor = Color(0xFF284F73);
  static const Color primaryButtonTextColor = Color(0xFFD1E9FE);
  static const Color placeholderTextColor = Color(0xFF747474);
  static const String accessTokenKey = "access_token";

  static const String newFareOfferType = 'NEW_FARE_OFFER';
  static const String acceptedFareOfferType = 'ACCEPTED_FARE_OFFER';
  static const String rejectedFareOfferType = 'REJECTED_FARE_OFFER';
  static const String expiredFareOfferType = 'EXPIRED_FARE_OFFER';
  static const String payedFareOfferType = 'PAYED_FARE_OFFER';
  static const String newRatingType = 'NEW_RATING';
  static const String locationRequestedSilentType = 'LOCATION_REQUESTED';
}
