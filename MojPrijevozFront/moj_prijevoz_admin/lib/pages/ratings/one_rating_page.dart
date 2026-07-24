import 'package:easy_stars/easy_stars.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/providers/rating_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/rating/rating_update_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class OneRatingPage extends StatefulWidget {
  final int ratingId;
  const OneRatingPage({super.key, required this.ratingId});

  @override
  State<StatefulWidget> createState() => _OneRatingPageState();
}

class _OneRatingPageState extends RouteAwareState<OneRatingPage> {
  late RatingResponse _ratingResponse;
  final _commentTextController = TextEditingController();

  _OneRatingPageState() : super(action: DrawerMenuAction.ratings);
  @override
  Widget build(BuildContext context_) {
    return LoadUntilReadyWrapper(
      buildFunction: (context) => _build(context),
      futureFunction: _init,
    );
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      body: _buildBody(context),
      appBarTitle: "Upravljanje recenzijom",
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<RatingProvider>(
      builder: (c, provider, _) {
        return Column(
          spacing: 10,
          children: [_buildTopButtons(c), _buildRatingData(), _buildButtons(c)],
        );
      },
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async => await _refreshForm(context),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Future _refreshForm(BuildContext context) async {
    _ratingResponse = await context.read<RatingProvider>().getById(
      widget.ratingId,
    );
    if (!context.mounted) return;
    context.read<RatingProvider>().notifyListeners();
    _commentTextController.text = _ratingResponse.comment ?? "";
  }

  Widget _buildRatingData() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.4,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 30,
              children: [
                TextBodyLarge(
                  "${_ratingResponse.from!.user!.toString()} -> ${_ratingResponse.to!.user!.toString()}",
                  textAlign: TextAlign.center,
                ),
                TextBodyLarge(
                  "${_ratingResponse.fare!.fareData!.originCity!.name} -> ${_ratingResponse.fare!.fareData!.trimmedDestinationName}",
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EasyStarsDisplay(
                      readOnly: true,
                      initialRating: _ratingResponse.grade.toDouble(),
                      emptyColor: context.secondaryColor,
                      filledColor: context.primaryColor,
                      allowHalfRating: true,
                    ),
                  ],
                ),
                TextField(
                  readOnly: true,
                  controller: _commentTextController,
                  maxLines: 3,
                  maxLength: 256,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Checkbox(
                      value: _ratingResponse.isVisible,
                      onChanged: (value) => setState(() {
                        _ratingResponse.isVisible = value!;
                      }),
                    ),
                    const TextLabelLarge("Vidljivo"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _init() async {
    _ratingResponse = await context.read<RatingProvider>().getById(
      widget.ratingId,
    );
    _commentTextController.text = _ratingResponse.comment ?? "";
    return true;
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: context.screenWidth * 0.4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          ElevatedButton(
            onPressed: () => Constants.navigatorKey.currentState?.pop(),
            child: const Text("Otkaži"),
          ),
          PrimaryButton(
            onPressed: () async => await _onSubmit(context),
            text: "Spremi",
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future _onSubmit(BuildContext context) async {
    final isDone = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite spremiti promjene?",
          onSubmit: () async {
            await context.read<RatingProvider>().updateWithEvent(
              widget.ratingId,
              RatingUpdateRequest(isVisible: _ratingResponse.isVisible),
            );

            Constants.messengerKey.currentState?.showSnackBar(
              SuccessSnackBar(message: "Promjene su uspješno spremljene!"),
            );

            if (context.mounted) {
              Constants.navigatorKey.currentState?.pop(true);
            }
          },
        );
      },
    );
    if (isDone ?? false) {
      Constants.navigatorKey.currentState?.pop();
    }
  }
}
