import 'package:flutter/material.dart';

class PasswordFormField extends TextFormField {
  final bool required;

  PasswordFormField({
    super.key,
    super.onSaved,
    super.decoration,
    super.controller,
    this.required = true,
  }) : super(
         obscureText: true,
         validator: (value) {
           var errorMessage = "Lozinka nije validna!";
           if (required && (value == null || value.isEmpty)) {
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
