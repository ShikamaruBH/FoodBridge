import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomValidator {
  static Function translate = LocalizationController().getTranslate;
  static get required => FormBuilderValidators.required(
      errorText: translate('required-error-text'));
  static get email =>
      FormBuilderValidators.email(errorText: translate('email-error-text'));
  static get numberic => FormBuilderValidators.numeric(
      errorText: translate('numberic-error-text'));
  static String? datetime(DateTime? val) {
    print('${dateTimePickerController.start} ${dateTimePickerController.end}');
    if (dateTimePickerController.end.isAfter(dateTimePickerController.start)) {
      print('Datetime valid');
      return null;
    }
    print("Datetime invalid");
    return translate('invalid-datetime-error-text');
  }

  static minLength(value) => FormBuilderValidators.minLength(value,
      errorText: translate('min-length-error-text') + value.toString());
}
