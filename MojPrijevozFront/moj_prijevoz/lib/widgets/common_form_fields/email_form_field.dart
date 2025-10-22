import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailFormField extends TextFormField {
  EmailFormField({
    super.key,
    super.onSaved,
    super.controller,
    super.decoration,
    super.initialValue,
  }) : super(
         validator: (value) {
           if (value == null ||
               value.isEmpty ||
               !EmailValidator.validate(value)) {
             return "Email nije validan!";
           }
           return null;
         },
         keyboardType: TextInputType.emailAddress,
       );
}
