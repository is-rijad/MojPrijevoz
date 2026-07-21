import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/transaction_side.dart';
import 'package:moj_prijevoz_admin/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/providers/transaction_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/all_transactions_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/transaction_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/transaction/transaction_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends RouteAwareState<TransactionsPage> {
  _TransactionsPageState() : super(action: DrawerMenuAction.transactions);
  final _searchObject = TransactionSearchObject(page: 1, pageSize: 10);
  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Transakcije");
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.screenHeight * 0.8,
          width: context.screenWidth,
          child:
              PaginatedTable<
                AllTransactionsResponse,
                TransactionResponse,
                TransactionProvider,
                TransactionSearchObject
              >(
                searchObject: _searchObject,
                header: <String, String?>{
                  "Vožnja": null,
                  "Vrijednost": "Amount",
                  "Provizija": "FeeAmount",
                  "Tip": "Side",
                  "Proknjižen u": "PostedAt",
                  "Kreiran u": "CreatedAt",
                  "Proknjiži": null,
                },

                items: [
                  (i) => Text(
                    "${i.fare!.fareData!.originCity!.name}-${i.fare!.fareData!.trimmedDestinationName}",
                  ),
                  (i) => Text("${i.amount.toStringAsFixed(2)}KM"),
                  (i) => i.feeAmount != null
                      ? Text("${i.feeAmount!.toStringAsFixed(2)}KM")
                      : const Text("-"),
                  (i) => Text(transactionSideMap[i.side]!),
                  (i) => i.postedAt != null
                      ? Text(
                          "${context.getLocalizedDate(i.postedAt!)} ${context.getLocalizedTime(i.postedAt!)}",
                        )
                      : Text("-"),
                  (i) => Text(
                    "${context.getLocalizedDate(i.createdAt)} ${context.getLocalizedTime(i.createdAt)}",
                  ),
                  (i) => IconButton(
                    onPressed: () async => await _buildPostTransactionDialog(i),
                    icon: Icon(Icons.check),
                  ),
                ],
              ),
        ),
      ],
    );
  }

  Future _buildPostTransactionDialog(AllTransactionsResponse i) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite spremiti promjene?",
          onSubmit: () async {
            await context.read<TransactionProvider>().updateWithEvent(
              i.id,
              null,
            );
            if (!context.mounted) return;
            context.read<TransactionProvider>().clearData(_searchObject);
            Constants.messengerKey.currentState?.showSnackBar(
              SuccessSnackBar(message: "Uspješno ste proknjižili transakciju!"),
            );
            if (context.mounted) {
              Constants.navigatorKey.currentState?.pop(true);
            }
            await context.read<TransactionProvider>().fetchData(_searchObject);
          },
        );
      },
    );
  }
}
