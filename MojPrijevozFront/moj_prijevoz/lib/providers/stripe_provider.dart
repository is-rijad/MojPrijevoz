import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/requests/stripe/stripe_create_intent_request.dart';
import 'package:moj_prijevoz/resources/responses/stripe/stripe_create_intent_response.dart';

class StripeProvider {
  final _httpProvider = GetIt.I<HttpProvider>();
  final _url = "stripe/createintent";

  Future<StripeCreateIntentResponse> createIntent(
    StripeCreateIntentRequest request,
  ) async {
    return await _httpProvider
        .post<StripeCreateIntentRequest, StripeCreateIntentResponse>(
          _url,
          request,
        );
  }
}
