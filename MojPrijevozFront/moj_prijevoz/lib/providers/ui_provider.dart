import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_page.dart';
import 'package:moj_prijevoz/pages/review_page.dart';

class UIProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool _loadingDisabled = false;
  ProfileDropdownAction? profileDropdownAction;

  void disableLoading() {
    _loadingDisabled = true;
  }

  void startLoading() {
    if (!_loadingDisabled) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => isLoading.value = true,
      );
    }
    _loadingDisabled = false;
  }

  void stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => isLoading.value = false,
    );
  }

  Future handleNavigationFromNotification(Map<String, dynamic> data) async {
    switch (data["Type"]) {
      case Constants.newFareOfferType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyFaresPage(
              fareId: data["FareId"]?.toString(),
              side: data["Side"]?.toString(),
            ),
          ),
        );
        break;
      case Constants.payedFareOfferType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyFaresPage(
              fareId: data["FareId"]?.toString(),
              side: data["Side"]?.toString(),
            ),
          ),
        );
        break;
      case Constants.expiredFareOfferType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyFaresPage(
              fareId: data["FareId"]?.toString(),
              side: data["Side"]?.toString(),
            ),
          ),
        );
        break;
      case Constants.acceptedFareOfferType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyFaresPage(
              fareId: data["FareId"]?.toString(),
              side: data["Side"]?.toString(),
            ),
          ),
        );
        break;
      case Constants.rejectedFareOfferType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyFaresPage(
              fareId: data["FareId"]?.toString(),
              side: data["Side"]?.toString(),
            ),
          ),
        );
        break;
      case Constants.cancelledFareOfferType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => MyFaresPage(
              fareId: data["FareId"]?.toString(),
              side: data["Side"]?.toString(),
            ),
          ),
        );
        break;
      case Constants.newRatingType:
        await Constants.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => ReviewPage(
              fareIdFromNotification: data["FareId"]?.toString(),
              sideFromNotification: data["Side"]?.toString(),
              ratingFromNotification: data["RatingId"]?.toString(),
              isReadOnly: true,
            ),
          ),
        );
        break;
      default:
    }
  }
}
