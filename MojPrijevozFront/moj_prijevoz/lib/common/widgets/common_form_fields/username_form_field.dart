import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';

class UsernameFormField extends TextFormField {
  UsernameFormField({
    super.key,
    super.onSaved,
    super.decoration,
    super.initialValue,
    super.controller,
  }) : super(
         validator: (value) {
           if (value == null ||
               value.isEmpty ||
               !Constants.usernameRegex.hasMatch(value)) {
             return "Korisničko ime nije validno!";
           }
           return null;
         },
         keyboardType: TextInputType.text,
       );
}
