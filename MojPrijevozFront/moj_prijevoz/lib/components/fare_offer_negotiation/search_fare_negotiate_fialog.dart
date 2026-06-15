import 'package:flutter/material.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_driver_response.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';

class SearchFareNegotiateFialog extends StatefulWidget {
  final SearchFareDriverResponse fareDriver;
  final void Function(String? value) onSavedPrice;
  final void Function(String? value) onSavedAdditionalPrice;

  const SearchFareNegotiateFialog({
    super.key,
    required this.fareDriver,
    required this.onSavedPrice,
    required this.onSavedAdditionalPrice,
  });

  @override
  State<StatefulWidget> createState() => _SearchFareNegotiateFialogState();
}

class _SearchFareNegotiateFialogState extends State<SearchFareNegotiateFialog> {
  // ignore: unused_field
  late final TextEditingController _priceTextEditingController;
  // ignore: unused_field
  late final TextEditingController _additionalPriceTextEditingController;
  final _errorMessage = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _priceTextEditingController = TextEditingController(
      text: widget.fareDriver.price.toString(),
    );
    _additionalPriceTextEditingController = TextEditingController(
      text: widget.fareDriver.additionalPrice?.toString() ?? "0.0",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MPAlertDialog(
      title: 'Uređivanje ponude',
      content: AlertDialogContent(
        errorMessageValueNotifier: _errorMessage,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._buildContent(context),
              SizedBox(height: 20),
              ..._buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    var price = widget.fareDriver.price;
    var additionalPrice = widget.fareDriver.additionalPrice;
    return [
      Row(
        spacing: 20,
        children: [
          Icon(Icons.attach_money),
          Expanded(
            child: TextFormField(
              initialValue: price.toString(),
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
                price = double.tryParse(value) ?? 0;
              }),
              onSaved: widget.onSavedPrice,
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
                additionalPrice = double.tryParse(value);
              }),
              initialValue: additionalPrice?.toString() ?? "0.0",
              onSaved: widget.onSavedAdditionalPrice,
            ),
          ),
          const TextLabelLarge("KM*"),
        ],
      ),
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
    ];
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          PrimaryButton(
            text: "Nastavi",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    ];
  }
}
