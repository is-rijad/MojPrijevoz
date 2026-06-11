import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/rating_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/requests/rating/rating_insert_request.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final FareResponse fare;
  final ProfileType profileType;
  const ReviewPage({super.key, required this.fare, required this.profileType});

  @override
  State<StatefulWidget> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _request = RatingInsertRequest();
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final appBarTitle = widget.profileType == ProfileType.passenger
        ? "Ocjena vozača"
        : "Ocjena putnika";
    return PageWrapper(appBarTitle: appBarTitle, body: _build(context));
  }

  Widget _build(BuildContext context) {
    final profile = widget.profileType == ProfileType.passenger
        ? widget.fare.driver
        : widget.fare.passenger;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Avatar(user: profile!.user!, maxRadius: 50),
          TextHeadlineSmall(
            "${profile.user!.firstName} ${profile.user!.lastName}",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              EasyStarsDisplay(
                emptyColor: context.primaryColor,
                starSize: 36,
                initialRating: 0,
                readOnly: false,
                allowHalfRating: false,
                filledColor: context.primaryColor,
                onRatingChanged: (value) => _request.grade = value.toInt(),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Komentar...",
              fillColor: context.secondaryColor,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Constants.secondaryTextColor),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            controller: _commentController,
            maxLength: 256,
            maxLines: 7,
            minLines: 7,
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: PrimaryButton(text: "Ocijeni", onPressed: () => _submit()),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_request.grade == null) {
      Constants.messengerKey.currentState!.showSnackBar(
        ErrorSnackBar(message: "Ocjena je obavezna!"),
      );
      return;
    }
    _request.fareId = widget.fare.id;
    _request.profileType = widget.profileType;
    await context.read<RatingProvider>().insert(_request);
    if (!mounted) return;

    Constants.messengerKey.currentState!.showSnackBar(
      SuccessSnackBar(message: "Uspješno ste ostavili ocjenu!"),
    );
    Navigator.pop(context);
  }
}
