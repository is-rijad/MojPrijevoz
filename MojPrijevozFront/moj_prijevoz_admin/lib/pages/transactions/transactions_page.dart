import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/transaction_side.dart';
import 'package:moj_prijevoz_admin/common/resources/transaction_months_map.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz_admin/common/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/pages/users/one_user_page.dart';
import 'package:moj_prijevoz_admin/providers/transaction_provider.dart';
import 'package:moj_prijevoz_admin/providers/users_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/all_transactions_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/transaction_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/all_users_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/transaction/transaction_search_object.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/users/users_search_object.dart';
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
  final _searchObject = TransactionSearchObject(
    page: 1,
    pageSize: 10,
    userId: null,
    month: DateTime.now().month - 1,
    isPosted: false,
  );
  final _userSearchObject = UsersSearchObject(
    page: 1,
    pageSize: 10,
    onlyWithBankAccountNumber: true,
  );
  bool _canEditUser = false;
  final _formKey = GlobalKey<FormState>();
  AllUsersResponse? _selectedUser;
  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Transakcije");
  }

  Widget _build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: context.screenWidth * 0.2,
                          child:
                              PagedDropdownFormField<
                                AllUsersResponse,
                                UserResponse,
                                int,
                                UsersProvider,
                                UsersSearchObject
                              >(
                                searchObject: _userSearchObject,
                                getLabel: (i) => i.fullName,
                                getValue: (i) => i.id,
                                firstItem: AllUsersResponse(
                                  firstName: "Svi",
                                  id: -1,
                                  lastName: "vozači",
                                  email: "",
                                  username: "",
                                  status: AccountStatus.active,
                                  phoneNumber: "",
                                  bankAccountNumber: null,
                                  registeredAt: DateTime.now().toUtc(),
                                ),
                                defaultLabel: "Vozač",
                                onSelectionChanged: (value) async {
                                  _searchObject.userId = value.id;
                                  context.read<TransactionProvider>().clearData(
                                    _searchObject,
                                  );
                                  await context
                                      .read<TransactionProvider>()
                                      .fetchData(_searchObject);

                                  if (value.id != -1) {
                                    setState(() {
                                      _canEditUser = true;
                                      _selectedUser = value;
                                    });
                                  } else {
                                    setState(() {
                                      _canEditUser = false;
                                      _selectedUser = null;
                                    });
                                  }
                                },
                                onSaved: (value) =>
                                    _searchObject.userId = value?.id,
                              ),
                        ),
                        IconButton(
                          onPressed: _canEditUser
                              ? () async => await Constants
                                    .navigatorKey
                                    .currentState
                                    ?.push(
                                      MaterialPageRoute(
                                        builder: (context) => OneUserPage(
                                          userId: _searchObject.userId!,
                                        ),
                                      ),
                                    )
                              : null,
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    DropdownMenuFormField(
                      width: context.screenWidth * 0.2,
                      dropdownMenuEntries: transactionMonthsMap.entries
                          .map(
                            (it) => DropdownMenuEntry(
                              label: it.value,
                              value: it.key,
                            ),
                          )
                          .toList(),
                      initialSelection: DateTime.now().month - 1,
                      label: const TextHeadlineSmall("Mjesec"),
                      onSelected: (value) async {
                        _searchObject.month = value;
                        context.read<TransactionProvider>().clearData(
                          _searchObject,
                        );
                        await context.read<TransactionProvider>().fetchData(
                          _searchObject,
                        );
                      },
                      onSaved: (value) => _searchObject.month = value,
                    ),
                    CheckboxMenuButton(
                      value: _searchObject.isPosted,
                      onChanged: (value) async {
                        setState(() {
                          _searchObject.isPosted = value ?? false;
                        });
                        context.read<TransactionProvider>().clearData(
                          _searchObject,
                        );
                        await context.read<TransactionProvider>().fetchData(
                          _searchObject,
                        );
                      },
                      child: const Text("Pretraži proknjižene"),
                    ),
                  ],
                ),
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Broj računa: ${_selectedUser?.bankAccountNumber ?? "Nepoznato"}",
                    ),
                    Consumer<TransactionProvider>(
                      builder:
                          (
                            BuildContext context,
                            TransactionProvider value,
                            Widget? _,
                          ) {
                            double userRevenue = 0;
                            double feeRevenue = 0;
                            for (var element in value.searchResult.items) {
                              userRevenue += element.amount;
                              feeRevenue += element.feeAmount ?? 0;
                            }
                            return Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ukupan iznos za isplatu: ${userRevenue.toStringAsFixed(2)}KM",
                                ),
                                Text(
                                  "Ukupan iznos zarade: ${feeRevenue.toStringAsFixed(2)}KM",
                                ),
                              ],
                            );
                          },
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: context.screenHeight * 0.5,
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
                    "Putnik": "Fare.Passenger.User.FirstName",
                    "Vožnja": null,
                    "Vrijednost": "Amount",
                    "Provizija": "FeeAmount",
                    "Tip": "Side",
                    "Proknjižen u": "PostedAt",
                    "Kreiran u": "CreatedAt",
                  },

                  items: [
                    (i) => Text(i.fare!.passenger!.user!.fullName),
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
                  ],
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<TransactionProvider>(
                  builder:
                      (
                        BuildContext context,
                        TransactionProvider value,
                        Widget? _,
                      ) {
                        return PrimaryButton(
                          text: "Proknjiži",
                          onPressed:
                              value.searchResult.items.isNotEmpty &&
                                  _canEditUser &&
                                  !_searchObject.isPosted
                              ? () async => await _buildPostTransactionDialog()
                              : null,
                        );
                      },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _buildPostTransactionDialog() async {
    _formKey.currentState?.save();
    await showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content:
              "Da li ste sigurni da želite proknjižiti prikazane transakcije?",
          onSubmit: () async {
            await context.read<TransactionProvider>().update(
              null,
              _searchObject,
            );
            if (!context.mounted) return;
            Constants.messengerKey.currentState?.showSnackBar(
              SuccessSnackBar(message: "Uspješno ste proknjižili transakcije!"),
            );
            if (context.mounted) {
              Constants.navigatorKey.currentState?.pop(true);
            }
          },
        );
      },
    );
  }
}
