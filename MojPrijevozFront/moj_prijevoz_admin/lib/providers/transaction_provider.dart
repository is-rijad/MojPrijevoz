import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/all_transactions_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/transaction_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/transaction/transaction_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

class TransactionProvider
    extends
        BaseProvider<
          AllTransactionsResponse,
          TransactionResponse,
          TransactionSearchObject,
          JsonRequest,
          JsonRequest
        > {
  TransactionProvider() : super(providerName: "transaction");
}
