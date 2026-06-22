import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/icons/input_decoration_with_icon.dart';

class PasswordFormField extends StatefulWidget {
  final bool required;

  final InputDecorationWithIcon? decoration;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();

  const PasswordFormField({
    super.key,
    this.onSaved,
    this.decoration,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.required = true,
  });
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscured,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      decoration:
          InputDecorationWithIcon(
            iconData: widget.decoration?.iconData,
            border: widget.decoration?.border,
            iconHint: widget.decoration?.iconHint,
            hintText: widget.decoration?.hintText,
          ).copyWith(
            errorMaxLines: 3,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility : Icons.visibility_off,
                color: context.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
      onSaved: widget.onSaved,
      controller: widget.controller,
      validator: (value) {
        var errorMessage =
            "Lozinka mora imati minimalno 8 znakova, velika i mala slova, barem jedan broj i specijalni znak!";
        if (widget.required && (value == null || value.isEmpty)) {
          return errorMessage;
        }
        if (value != null &&
            value.isNotEmpty &&
            !RegExp(
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~.,;:?^%]).{8,}$',
            ).hasMatch(value)) {
          return errorMessage;
        }
        return null;
      },
      keyboardType: TextInputType.text,
    );
  }
}
