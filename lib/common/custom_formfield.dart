import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormField extends StatelessWidget {
  final Widget child;
  final String labelText;
  final String name;
  final String initialValue;
  final bool readOnly;
  final validator;
  CustomFormField(
      {Key key,
      this.labelText,
      this.name,
      this.initialValue,
      this.readOnly = false,
      this.validator,
      this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilderField(
        validator: validator,
        initialValue: initialValue,
        name: name,
        builder: (FormFieldState<dynamic> field) {
          return InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 20,
                    ),
                contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
                border: InputBorder.none,
                errorText: field.errorText,
              ),
              child: child);
        },
      ),
    );
  }
}
