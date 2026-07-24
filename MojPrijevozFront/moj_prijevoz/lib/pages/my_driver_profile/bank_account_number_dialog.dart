import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/common/providers/auth_provider.dart';
import 'package:moj_prijevoz/common/providers/user_provider.dart';
import 'package:moj_prijevoz/common/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/common/widgets/alert_dialog/mp_alert_dialog.dart';
import 'package:moj_prijevoz/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/common/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/common/widgets/snackbars.dart';
import 'package:moj_prijevoz/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/common/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/update_user_request.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:provider/provider.dart';

class BankAccountNumberDialog extends StatefulWidget {
  final bool isEdit;
  const BankAccountNumberDialog({super.key, required this.isEdit});

  @override
  State<StatefulWidget> createState() => _BankAccountNumberDialogState();
}

class _BankAccountNumberDialogState extends State<BankAccountNumberDialog> {
  final _errorMessage = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  UserResponse? _user;
  String? _bankAccountNumber;

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(
      buildFunction: _buildBankAccountNumberDialog,
      futureFunction: _init,
    );
  }

  Widget _buildBankAccountNumberDialog(BuildContext context) {
    return SizedBox.shrink(
      child: MPAlertDialog(
        title: "Bankovni račun",
        content: AlertDialogContent(
          errorMessageValueNotifier: _errorMessage,
          child: FormWrapper(
            paddingFactor: 0.02,
            screenWidthFactor: 0.9,
            formKey: _formKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextBodyLarge(
                "Molimo unesite broj bankovnog računa kako bismo Vam mogli isplaćivati zarađeni novac.",
                textAlign: TextAlign.justify,
              ),
              TextFormField(
                initialValue: _bankAccountNumber,
                onSaved: (newValue) => _bankAccountNumber = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 13) {
                    return "Broj računa nije validan!";
                  }
                  return null;
                },
                decoration: InputDecorationWithIcon(
                  iconData: Icons.account_balance,
                  iconHint: "Broj bankovnog računa",
                  hintText: "1234567891234",
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Constants.navigatorKey.currentState?.pop(null),
                    child: const Text("Otkaži"),
                  ),
                  PrimaryButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState!.save();
                        if (widget.isEdit) {
                          try {
                            await context.read<UserProvider>().update(
                              _user!.id,
                              null,
                              formData: FormData.fromMap({
                                ..._user!.toJson(),
                                "bankAccountNumber": _bankAccountNumber,
                              }),
                            );
                            Constants.messengerKey.currentState?.showSnackBar(
                              SuccessSnackBar(
                                message:
                                    "Bankovni račun je uspješno izmjenjen!",
                              ),
                            );
                          } on DioException catch (e, st) {
                            _errorMessage.value = ErrorHandler.handle(e, st);
                            await Future.delayed(
                              Duration(seconds: 5),
                              () => _errorMessage.value = null,
                            );
                          }
                        }
                        Constants.navigatorKey.currentState?.pop(
                          _bankAccountNumber,
                        );
                      }
                    },
                    text: "Dalje",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _init() async {
    if (widget.isEdit) {
      final userId = (await AuthProvider.getPayload()).id;
      if (!mounted) return false;
      _user = await context.read<UserProvider>().getById(userId);
      if (!mounted) return false;
      setState(() {
        _bankAccountNumber = _user!.bankAccountNumber;
      });
    }
    return true;
  }
}
