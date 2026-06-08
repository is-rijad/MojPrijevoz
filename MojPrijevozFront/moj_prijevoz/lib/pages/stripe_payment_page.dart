import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/providers/stripe_provider.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/requests/stripe/stripe_create_intent_request.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class StripePaymentPage extends StatefulWidget {
  final int fareOfferId;
  const StripePaymentPage({super.key, required this.fareOfferId});

  @override
  State<StatefulWidget> createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  bool _isSucceded = false;
  @override
  void initState() {
    super.initState();

    try {
      payForFare(widget.fareOfferId);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: _isSucceded ? _buildSuccess(context) : SizedBox.shrink(),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check, size: context.screenWidth * 0.5),
          const TextDisplayLarge("Uspješno plaćanje."),
          const TextLabelMedium("Hvala Vam što koristite Moj Prijevoz."),
        ],
      ),
    );
  }

  Future<void> payForFare(int fareOfferId) async {
    final response = await GetIt.I<StripeProvider>().createIntent(
      StripeCreateIntentRequest(fareOfferId: fareOfferId),
    );
    final clientSecret = response.clientSecret;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'MojPrijevoz',
        billingDetails: BillingDetails(
          address: Address(
            country: 'BA',
            city: null,
            line1: null,
            line2: null,
            postalCode: null,
            state: null,
          ),
        ),
        billingDetailsCollectionConfiguration:
            BillingDetailsCollectionConfiguration(
              address: AddressCollectionMode.automatic,
            ),
      ),
    );

    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (mounted && e.error.code == FailureCode.Canceled) {
        Navigator.pop(context);
        return;
      }
      rethrow;
    }

    if (mounted) {
      setState(() {
        _isSucceded = true;
      });
      context.read<FareProvider>().updateNextFareLocally(
        fareOfferId,
        FareStatus.payed,
      );
    }
  }
}
