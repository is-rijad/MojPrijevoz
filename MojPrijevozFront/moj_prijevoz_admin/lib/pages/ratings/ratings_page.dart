import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/pages/ratings/one_rating_page.dart';
import 'package:moj_prijevoz_admin/providers/rating_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/all_ratings_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/rating/rating_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RatingsPageState();
}

class _RatingsPageState extends RouteAwareState<RatingsPage> {
  _RatingsPageState() : super(action: DrawerMenuAction.ratings);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _buildBody(context), appBarTitle: "Recenzije");
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.85,
      width: context.screenWidth,
      child:
          PaginatedTable<
            AllRatingsResponse,
            RatingResponse,
            RatingProvider,
            RatingSearchObject
          >(
            searchObject: RatingSearchObject(page: 1, pageSize: 10),
            header: <String, String?>{
              "Od": "From.User.FirstName",
              "Za": "To.User.FirstName",
              "Ocjena": "Grade",
              "Vidljiv": "isVisible",
              "Kreiran u": "CreatedAt",
            },

            items: [
              (i) => Text(i.from!.user!.toString()),
              (i) => Text(i.to!.user!.toString()),
              (i) => Text(i.grade.toString()),
              (i) => Text(i.isVisible ? "Da" : "Ne"),
              (i) => Text(
                "${context.getLocalizedDate(i.createdAt)} ${context.getLocalizedTime(i.createdAt)}",
              ),
            ],
            onTap: (i) async => await Constants.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => OneRatingPage(ratingId: i!.id),
              ),
            ),
          ),
    );
  }
}
