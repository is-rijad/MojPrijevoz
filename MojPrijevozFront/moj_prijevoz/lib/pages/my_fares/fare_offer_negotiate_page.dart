import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/profile/show_profile_dialog.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_update_request.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class FareOfferNegotiatePage extends StatefulWidget {
  final FareResponse fare;
  final UserProfileResponse person;

  const FareOfferNegotiatePage({
    super.key,
    required this.fare,
    required this.person,
  });

  @override
  State<StatefulWidget> createState() => _FareOfferNegotiatePageState();
}

class _FareOfferNegotiatePageState extends State<FareOfferNegotiatePage> {
  final _request = FareOfferUpdateRequest();
  late final UserProfileResponse _person;
  bool _isEditable = false;
  late final TextEditingController _priceTextEditingController;
  late final TextEditingController _additionalPriceTextEditingController;
  final _errorMessage = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _request.price = widget.fare.lastFareOffer!.price;
    _request.additionalPrice = widget.fare.lastFareOffer!.additionalPrice;
    _person = widget.person;
    _priceTextEditingController = TextEditingController(
      text: _request.price!.toString(),
    );
    _additionalPriceTextEditingController = TextEditingController(
      text: _request.additionalPrice?.toString() ?? "0.0",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: "Ponuda za vožnju",
      body: FormWrapper(
        screenWidthFactor: 1,
        formKey: _formKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._buildContent(context, widget.fare),
          SizedBox(height: 20),
          ..._buildButtons(context),
          SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextLabelSmall(
                "* doplata za dolazak na adresu.",
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, FareResponse entity) {
    return [
      ..._buildPriceSection(context, entity),
      SizedBox(height: 30),
      ..._buildFareDataSection(context, entity),
      SizedBox(height: 30),
      ..._buildPersonProfile(context, entity, _person),
      SizedBox(height: 10),
    ];
  }

  List<Widget> _buildPriceSection(BuildContext context, FareResponse entity) {
    return [
      Row(
        spacing: 20,
        children: [
          Tooltip(message: "Cijena", child: Icon(Icons.attach_money)),
          Expanded(
            child: TextFormField(
              controller: _priceTextEditingController,
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null ||
                    double.parse(value) < 1) {
                  return "Unos nije validan!";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => setState(() {
                _request.price = double.tryParse(value) ?? 0;
              }),
              enabled: _isEditable,
            ),
          ),
          Icon(Icons.add),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null ||
                    double.parse(value) < 0) {
                  return "Unos nije validan!";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => setState(() {
                _request.additionalPrice = double.tryParse(value);
              }),
              controller: _additionalPriceTextEditingController,
              enabled: _isEditable,
            ),
          ),
          const TextLabelLarge("KM*"),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Tooltip(
            message: "Ukupna cijena",
            child: Icon(Icons.attach_money_rounded),
          ),
          Text(
            "${round(_request.price! + (_request.additionalPrice ?? 0))}KM",
            style: TextStyle(fontWeight: FontWeight(900), fontSize: 16),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildFareDataSection(
    BuildContext context,
    FareResponse entity,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconFieldWithText(
                iconHint: "Početna lokacija",
                iconData: Icons.home,
                text: entity.fareData!.originCity!.name,
              ),
              if (entity.fareData!.stopPoints != null &&
                  entity.fareData!.stopPoints!.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        clampDouble(
                          double.parse(
                            entity.fareData!.stopPoints!.length.toString(),
                          ),
                          1,
                          3,
                        ) *
                        25,
                  ),
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 1,
                          height: entity.fareData!.stopPoints!.length * 25,
                          color: context.primaryColor,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: entity.fareData!.stopPoints!
                              .map(
                                (i) => IconFieldWithText(
                                  iconHint: "Zaustavno mjesto",
                                  iconData: Icons.add_location,
                                  text: i.trimmedName,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              IconFieldWithText(
                iconHint: "Destinacija",
                iconData: Icons.location_city,
                text: entity.fareData!.trimmedDestinationName,
              ),
            ],
          ),
          Column(
            spacing: 10,
            children: [
              IconFieldWithText(
                iconHint: "Planirano vrijeme dolaska",
                iconData: Icons.access_time,
                text: context.getLocalizedTime(
                  entity.fareData!.fareDateTime.add(
                    Duration(minutes: entity.fareData!.duration),
                  ),
                ),
              ),
              IconFieldWithText(
                iconHint: "Vrijeme vožnje",
                iconData: Icons.timer,
                text: "${entity.fareData!.duration.toString()}min",
              ),
              IconFieldWithText(
                iconHint: "Udaljenost",
                iconData: Icons.social_distance,
                text: "${entity.fareData!.length.toString()}km",
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconFieldWithText(
            iconHint: "Zakazani datum vožnje",
            iconData: Icons.calendar_month,
            text: context.getLocalizedDate(entity.fareData!.fareDateTime),
          ),
          IconFieldWithText(
            iconHint: "Zakazano vrijeme vožnje",

            iconData: Icons.access_alarm,
            text: context.getLocalizedTime(entity.fareData!.fareDateTime),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildPersonProfile(
    BuildContext context,
    FareResponse entity,
    UserProfileResponse person,
  ) {
    return [
      GestureDetector(
        onTap: () async => await _showUserProfile(person),
        child: Column(
          spacing: 10,
          children: [
            Avatar(user: person.user!),
            IconFieldWithText(
              iconData: Icons.person,
              text: person.user!.fullName,
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _showUserProfile(UserProfileResponse userProfile) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ShowProfileDialog(profileId: userProfile.id);
      },
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _isEditable ? null : _onNewOfferRequest,
            child: const Text("Nova ponuda"),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          ElevatedButton(onPressed: _onRejectOffer, child: const Text("Odbij")),
          PrimaryButton(
            text: _isEditable ? "Pošalji" : "Prihvati",
            onPressed: _submitForm,
          ),
        ],
      ),
    ];
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        bool? isDone = await _onAcceptOffer();
        if (!mounted) return;
        if (isDone ?? false) {
          Navigator.pop(context);
        }
      } on Exception catch (ex, stack) {
        _errorMessage.value = ErrorHandler.handle(ex, stack);
      }
    }
  }

  Future _onRejectOffer() async {
    await showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite odbiti ponudu?",
          onSubmit: () async {
            await context.read<FareOfferProvider>().rejectWithEvent(
              widget.fare.lastFareOffer!.id,
            );
            if (context.mounted) {
              Navigator.pop(context, true);
            }

            Constants.messengerKey.currentState?.showSnackBar(
              SuccessSnackBar(message: "Odbili ste ponudu!"),
            );
          },
        );
      },
    );
  }

  Future _onNewOfferRequest() async {
    setState(() {
      _isEditable = true;
      _request.price = widget.fare.lastFareOffer!.price;
      _request.additionalPrice = widget.fare.lastFareOffer!.additionalPrice;
      _priceTextEditingController.text = _request.price!.toString();
      _additionalPriceTextEditingController.text =
          _request.additionalPrice?.toString() ?? "0.0";
    });
  }

  Future<bool?> _onAcceptOffer() async {
    bool? isDone;
    if (_isEditable) {
      isDone = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            content: "Da li ste sigurni da želite poslati ponudu?",
            onSubmit: () async {
              await context.read<FareOfferProvider>().updateWithEvent(
                widget.fare.lastFareOffer!.id,
                _request,
              );
              if (context.mounted) {
                Navigator.pop(context, true);
              }
              Constants.messengerKey.currentState?.showSnackBar(
                SuccessSnackBar(message: "Poslali ste novu ponudu!"),
              );
            },
          );
        },
      );
    } else {
      isDone = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            content: "Da li ste sigurni da želite prihvatiti ponudu?",

            onSubmit: () async {
              await context.read<FareOfferProvider>().acceptWithEvent(
                widget.fare.lastFareOffer!.id,
              );
              if (context.mounted) {
                Navigator.pop(context, true);
              }
              Constants.messengerKey.currentState?.showSnackBar(
                SuccessSnackBar(message: "Prihvatili ste ponudu!"),
              );
            },
          );
        },
      );
    }
    if (mounted && (isDone ?? false)) {
      Navigator.pop(context);
    }
  }
}
