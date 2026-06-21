import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/providers/rating_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/requests/rating/rating_insert_request.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final FareResponse? fare;
  final ProfileType? profileType;
  final String? fareIdFromNotification;
  final String? sideFromNotification;
  final String? ratingFromNotification;
  final bool isReadOnly;
  const ReviewPage({
    super.key,
    this.fare,
    this.profileType,
    required this.isReadOnly,
    this.fareIdFromNotification,
    this.sideFromNotification,
    this.ratingFromNotification,
  });

  @override
  State<StatefulWidget> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late FareResponse _fare;
  late ProfileType _profileType;
  RatingResponse? _rating;
  final _request = RatingInsertRequest();
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    assert(widget.fare != null || widget.fareIdFromNotification != null);
    assert(widget.profileType != null || widget.sideFromNotification != null);
    final appBarTitle = widget.profileType == ProfileType.passenger
        ? "Ocjena vozača"
        : "Ocjena putnika";
    return PageWrapper(
      appBarTitle: appBarTitle,
      body: LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init),
    );
  }

  Widget _build(BuildContext context) {
    final profile = _profileType == ProfileType.passenger
        ? _fare.driver
        : _fare.passenger;
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
                initialRating: _rating?.grade.toDouble() ?? 0,
                readOnly: widget.isReadOnly,
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
            readOnly: widget.isReadOnly,
          ),
          if (!widget.isReadOnly)
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
    _request.fareId = _fare.id;
    _request.profileType = _profileType;
    _request.comment = _commentController.text;
    await context.read<RatingProvider>().insert(_request);
    if (!mounted) return;

    Constants.messengerKey.currentState!.showSnackBar(
      SuccessSnackBar(message: "Uspješno ste ostavili ocjenu!"),
    );
    Constants.navigatorKey.currentState?.pop();
  }

  Future<bool> _init() async {
    _fare =
        widget.fare ??
        await context.read<FareProvider>().getById(
          int.parse(widget.fareIdFromNotification!),
        );
    _profileType =
        widget.profileType ??
        (widget.sideFromNotification == "0"
            ? ProfileType.driver
            : ProfileType.passenger);
    if (!mounted) return false;
    if (widget.ratingFromNotification != null) {
      _rating = await context.read<RatingProvider>().getById(
        int.parse(widget.ratingFromNotification!),
      );
      _commentController.text = _rating?.comment ?? "";
    }

    return true;
  }
}
