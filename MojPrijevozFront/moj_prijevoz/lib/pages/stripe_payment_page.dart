import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/stripe_provider.dart';
import 'package:moj_prijevoz/resources/requests/stripe/stripe_create_intent_request.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class StripePaymentPage extends StatefulWidget {
  final int fareOfferId;
  const StripePaymentPage({super.key, required this.fareOfferId});

  @override
  State<StatefulWidget> createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  @override
  void initState() {
    super.initState();

    try {
      payForFare(widget.fareOfferId);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
      } else {
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: SizedBox.shrink());
  }

  Future<void> payForFare(int fareOfferId) async {
    // 1. Dohvati client_secret s backenda

    final response = await GetIt.I<StripeProvider>().createIntent(
      StripeCreateIntentRequest(fareOfferId: fareOfferId),
    );
    final clientSecret = response.clientSecret;

    // 2. Init payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'MojPrijevoz',
      ),
    );

    // 3. Prikaži sheet
    await Stripe.instance.presentPaymentSheet();

    // Ovo se izvrši tek nakon uspješne uplate
    // Webhook će ažurirati Fare.Status na backendu
  }
}
