import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_update_request.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/dialogs/general_dialog.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:provider/provider.dart';

class FareOfferNegotiateDialog extends StatefulWidget {
  final FareResponse fare;
  final UserProfileResponse person;

  const FareOfferNegotiateDialog({
    super.key,
    required this.fare,
    required this.person,
  });

  @override
  State<StatefulWidget> createState() => _FareOfferNegotiateDialogState();
}

class _FareOfferNegotiateDialogState extends State<FareOfferNegotiateDialog> {
  final _request = FareOfferUpdateRequest();
  late final UserProfileResponse _person;
  bool _isEditable = false;
  late final TextEditingController _priceTextEditingController;
  late final TextEditingController _additionalPriceTextEditingController;

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
    return GeneralDialog<FareResponse, FareOfferUpdateRequest>(
      entity: widget.fare,
      title: 'Ponuda za vožnju',
      onSubmit: _onAcceptOffer,
      successMessage: _isEditable
          ? 'Poslali ste ponudu!'
          : 'Prihvatili ste ponudu!',
      buildContent: _buildNegotiateDialogContent,
      buildButtons: _buildNegotiateDialogButtons,
      submitButtonTitle: _isEditable ? 'Pošalji ponudu' : 'Prihvati ponudu',
    );
  }

  List<Widget> _buildNegotiateDialogContent(
    BuildContext context,
    FareResponse entity,
  ) {
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
          Icon(Icons.price_change),
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
                    double.parse(value) < 0) {
                  return "Unos nije validan!";
                }
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
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => setState(() {
                _request.additionalPrice = double.tryParse(value);
              }),
              controller: _additionalPriceTextEditingController,
              enabled: _isEditable,
            ),
          ),
          Text("KM*"),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Icon(Icons.price_change),
          Text("${_request.price! + (_request.additionalPrice ?? 0)}KM"),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconFieldWithText(
                iconData: Icons.home,
                text: entity.fareData!.originCity!.name,
              ),
              if (entity.fareData!.stopPoints != null &&
                  entity.fareData!.stopPoints!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 1,
                      height: entity.fareData!.stopPoints!.length * 30,
                      color: Colors.black,
                    ),
                    Column(
                      children: entity.fareData!.stopPoints!
                          .map(
                            (it) => IconFieldWithText(
                              width: 100,
                              iconData: Icons.location_pin,
                              text: it.trimmedName,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              IconFieldWithText(
                iconData: Icons.location_city,
                text: entity.fareData!.trimmedDestinationName,
              ),
            ],
          ),
          Column(
            spacing: 10,
            children: [
              IconFieldWithText(
                iconData: Icons.access_time,
                text: entity.fareData!.fareDateTime
                    .add(Duration(minutes: entity.fareData!.duration))
                    .toString(),
              ),
              IconFieldWithText(
                iconData: Icons.timer,
                text: "${entity.fareData!.duration.toString()}min",
              ),
              IconFieldWithText(
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
            iconData: Icons.calendar_today,
            text: entity.fareData!.fareDateTime.toString(),
          ),
          IconFieldWithText(
            iconData: Icons.access_alarm,
            text: entity.fareData!.fareDateTime.toString(),
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
      Column(
        spacing: 10,
        children: [
          Avatar(user: person.user!),
          IconFieldWithText(
            iconData: Icons.person,
            text: person.user!.fullName,
          ),
          Text("0/0"),
        ],
      ),
    ];
  }

  List<Widget> _buildNegotiateDialogButtons() {
    return [
      ElevatedButton(
        onPressed: _onRejectOffer,
        child: const Text("Odbij ponudu"),
      ),
      ElevatedButton(
        onPressed: _onNewOfferRequest,
        child: const Text("Nova ponuda"),
      ),
    ];
  }

  Future _onRejectOffer() async {
    await showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: const Text("Da li ste sigurni da želite odbiti ponudu?"),
          onSubmit: () async {
            await context.read<FareOfferProvider>().rejectWithEvent(
              widget.fare.lastFareOffer!.id,
            );
          },
          successMessage: 'Odbili ste ponudu!',
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

  Future _onAcceptOffer() async {
    if (_isEditable) {
      await showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            content: const Text("Da li ste sigurni da želite poslati ponudu?"),
            onSubmit: () async {
              await context.read<FareOfferProvider>().updateWithEvent(
                widget.fare.lastFareOffer!.id,
                _request,
              );
            },
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            content: const Text(
              "Da li ste sigurni da želite prihvatiti ponudu?",
            ),
            onSubmit: () async {
              await context.read<FareOfferProvider>().acceptWithEvent(
                widget.fare.lastFareOffer!.id,
              );
            },
          );
        },
      );
    }
  }
}
