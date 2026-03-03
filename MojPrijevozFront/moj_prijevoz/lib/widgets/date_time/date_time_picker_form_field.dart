import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/date_time/date_time_picker.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown.dart';

class DateTimePickerFormField extends FormField<DateTime> {
  DateTimePickerFormField({
    super.key,
    String? defaultLabel,
    ValueChanged<DateTime>? onDateTimeChanged,
    super.onSaved,
    super.validator,
    super.initialValue,
    InputDecoration? decoration,
    bool autovalidate = false,
  }) : super(
         autovalidateMode: autovalidate
             ? AutovalidateMode.always
             : AutovalidateMode.disabled,
         builder: (fieldState) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               DateTimePicker(
                 defaultLabel: defaultLabel,
                 decoration: decoration,
                 onDateTimeChanged: (dateTime) {
                   fieldState.didChange(dateTime);
                   onDateTimeChanged?.call(dateTime);
                 },
                 initialValue: initialValue,
               ),
               if (fieldState.errorText != null)
                 Padding(
                   padding: const EdgeInsets.only(top: 4.0),
                   child: Text(
                     fieldState.errorText!,
                     style: TextStyle(color: Colors.red[700], fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}
