import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/rating_provider.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/search_objects/rating/rating_search_object.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class ShowProfileDialog extends StatefulWidget {
  final int profileId;
  const ShowProfileDialog({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _ShowProfileDialogState();
}

class _ShowProfileDialogState extends State<ShowProfileDialog> {
  late final UserProfileResponse userProfile;
  final _ratingSearchObject = RatingSearchObject(page: 1, pageSize: 5);

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 108, 182, 252),
              Constants.primaryButtonTextColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.02, 0.95],
          ),
        ),
        child: _buildDialog(),
      ),
    );
  }

  Future<bool> _init() async {
    userProfile = await context.read<UserProfileProvider>().getById(
      widget.profileId,
    );
    if (!mounted) return false;
    _ratingSearchObject.profileId = userProfile.id;
    return true;
  }

  Widget _buildDialog() {
    return SizedBox.fromSize(
      size: Size(context.screenWidth * 0.5, context.screenHeight),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.cancel),
                ),
              ],
            ),
            Avatar(user: userProfile.user!, maxRadius: 60),
            TextHeadlineSmall(
              "${userProfile.user!.firstName} ${userProfile.user!.lastName}",
            ),
            Expanded(
              child:
                  PaginatedTable<
                    RatingResponse,
                    RatingProvider,
                    RatingSearchObject
                  >(
                    headingRowHeight: 0,
                    dataRowMaxHeight: 200,
                    searchObject: _ratingSearchObject,
                    header: [""],
                    items: [(i) => _buildRating(i)],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(RatingResponse rating) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Avatar(user: rating.from.user!, maxRadius: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBodyLarge(rating.from.user!.fullName),
                      Row(
                        children: [
                          EasyStarsDisplay(
                            initialRating: rating.grade.toDouble(),
                            readOnly: true,
                            emptyColor: context.secondaryColor,
                            filledColor: context.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (rating.comment != null)
              SizedBox(
                height: 100,
                child: TextField(
                  maxLines: 2,
                  readOnly: true,
                  controller: TextEditingController(text: rating.comment),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
