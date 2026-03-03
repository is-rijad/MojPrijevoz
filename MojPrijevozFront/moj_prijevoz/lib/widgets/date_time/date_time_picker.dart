// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  InputDecoration? decoration;
  Function(DateTime)? onDateTimeChanged;
  DateTime? initialValue;
  String? defaultLabel;
  DateTimePicker({
    Key? key,
    this.decoration,
    this.onDateTimeChanged,
    this.initialValue,
    this.defaultLabel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _value = widget.initialValue;
    if (_value != null) {
      _textController.text =
          "${_value!.day}.${_value!.month}.${_value!.year} ${TimeOfDay.fromDateTime(_value!).format(context)}";
    } else {
      _textController.text = widget.defaultLabel ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: _textController,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (context.mounted && date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _onChanged(dateTime);
          }
        }
      },
      decoration:
          widget.decoration?.copyWith(border: OutlineInputBorder()) ??
          InputDecoration(border: OutlineInputBorder()),
    );
  }

  _onChanged(DateTime dateTime) {
    _value = dateTime;
    _textController.text =
        "${dateTime.day}.${dateTime.month}.${dateTime.year} ${TimeOfDay.fromDateTime(dateTime).format(context)}";
    widget.onDateTimeChanged?.call(dateTime);
  }
}
