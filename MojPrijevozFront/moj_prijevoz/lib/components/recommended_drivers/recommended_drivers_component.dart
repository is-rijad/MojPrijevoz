import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/profile/show_profile_dialog.dart';
import 'package:moj_prijevoz/pages/search_fare_page.dart';
import 'package:moj_prijevoz/providers/recommender_provider.dart';
import 'package:moj_prijevoz/resources/responses/recommender/recommended_driver_response.dart';
import 'package:moj_prijevoz/resources/search_objects/recommended_drivers/recommended_drivers_search_object.dart';
import 'package:moj_prijevoz/widgets/cards/paginated_cards.dart';
import 'package:moj_prijevoz/common/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';

class RecommendedDriversComponent extends StatefulWidget {
  const RecommendedDriversComponent({super.key});

  @override
  State<StatefulWidget> createState() => _RecommendedDriversComponentState();
}

class _RecommendedDriversComponentState
    extends State<RecommendedDriversComponent> {
  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return PaginatedCards<
      RecommendedDriversSearchObject,
      RecommendedDriverResponse,
      RecommenderProvider
    >(
      padding: EdgeInsets.symmetric(vertical: 12),
      spacing: 8,
      searchObject: RecommendedDriversSearchObject(page: 1, pageSize: 5),
      onTap: (i) async => await _onTap(i!.id),
      fallbackText: "Nema preporučenih vozača",
      children: (i) => _buildRecommendedDriverCard(context, i),
    );
  }

  List<Widget> _buildRecommendedDriverCard(
    BuildContext context,
    RecommendedDriverResponse driver,
  ) {
    return [
      GestureDetector(
        onTap: () => _showUserProfile(driver.id),
        child: Column(
          children: [
            Avatar(user: driver, maxRadius: 50),
            TextHeadlineSmall("${driver.firstName} ${driver.lastName}"),
          ],
        ),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          EasyStarsDisplay(
            emptyColor: context.primaryColor,

            initialRating: driver.averageRating,
            readOnly: true,
            allowHalfRating: true,
            filledColor: context.primaryColor,
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: TextBodyLarge(
                "Često putuje iz ${driver.originCityName} do ${driver.destinationName}",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _showUserProfile(int profileId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ShowProfileDialog(profileId: profileId);
      },
    );
  }

  Future<void> _onTap(int profileId) async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SearchFarePage(driverId: profileId),
      ),
    );
  }
}
