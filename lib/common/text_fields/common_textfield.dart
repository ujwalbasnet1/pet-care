import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/theming/theme.dart';

class CommonTextField extends StatelessWidget {
  final String labelText;
  final String name;
  final String initialValue;
  final bool readOnly;
  final validator;
  final TextInputAction textInputAction;
  final FocusNode focusNode;

  CommonTextField({
    Key key,
    this.labelText,
    this.name,
    this.initialValue,
    this.readOnly = false,
    this.textInputAction,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  static InputDecoration decoration = InputDecoration(
    isCollapsed: false,
    // contentPadding: EdgeInsets.only(top: 5),
    labelStyle: robotoTextStyle(
            fontSize: 18,
            //  fontWeight: FontWeight.bold,
            color: Colors.grey)
        .copyWith(height: 1),

    disabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderTextField(
        focusNode: focusNode,
        validator: validator,
        // inputType: InputType.time,
        style: robotoTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: decoration.copyWith(
          labelText: labelText,
        ),
        name: name,
        readOnly: readOnly,
        initialValue: initialValue,
        textInputAction: textInputAction ?? TextInputAction.next,
      ),
    );
  }
}
