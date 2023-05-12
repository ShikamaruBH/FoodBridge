import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DonationDatetimePicker extends StatelessWidget {
  final String name;
  final Function onChanged;
  final DateTime initialValue;
  final DateTime? firstDate;
  final TextStyle? style;
  final InputDecoration? decoration;
  final String? format;
  final IconData? prefix;
  const DonationDatetimePicker(
    this.name,
    this.onChanged,
    this.initialValue, {
    this.firstDate,
    this.style,
    this.decoration,
    this.format,
    this.prefix,
    super.key,
  });

  getDecoration() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _decoration = decoration ??
        DecoratorManagement.defaultTextFieldDecoratorDark("", null);
    if (prefix == null) {
      return _decoration;
    }
    return _decoration.copyWith(
        prefixIcon: Icon(
      prefix,
      color: Colors.white,
      size: 30,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: name,
      onChanged: (value) => onChanged(value!),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialValue: initialValue,
      format: DateFormat(format ?? 'dd/MM/yyyy hh:mm a'),
      style: style ?? StyleManagement.textFieldTextStyleDark,
      firstDate: firstDate ?? DateTime(1900),
      currentDate: DateTime.now(),
      initialTime: TimeOfDay.now(),
      locale: Locale(localeController.locale!),
      decoration: getDecoration(),
      validator: FormBuilderValidators.compose(
        [
          CustomValidator.required,
          CustomValidator.datetime,
        ],
      ),
    );
  }
}
