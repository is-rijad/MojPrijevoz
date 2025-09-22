import 'package:flutter/material.dart';

class NameFormField extends TextFormField {
  final String errorMessage;
  NameFormField({
    super.key,
    super.onSaved,
    super.decoration,
    super.initialValue,
    super.controller,
    required this.errorMessage,
  }) : super(
         validator: (value) {
           if (value == null || value.isEmpty) {
             return errorMessage;
           }
           return null;
         },
         keyboardType: TextInputType.name,
       );
}
