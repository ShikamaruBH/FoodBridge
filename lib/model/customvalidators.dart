import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomValidator {
  static get required => FormBuilderValidators.required(
      errorText: LocalizationController().getTranslate('required-error-text'));
  static get email => FormBuilderValidators.email(
      errorText: LocalizationController().getTranslate('email-error-text'));
  static minLength(value) => FormBuilderValidators.minLength(value,
      errorText:
          LocalizationController().getTranslate('min-length-error-text') +
              value.toString());
}
