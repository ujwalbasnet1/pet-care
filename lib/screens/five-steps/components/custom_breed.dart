import 'package:flutter/material.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/theming/common_size.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomBreed extends StatelessWidget {
  final BuildContext myContext;
  final String type;
  CustomBreed({Key key, this.myContext, this.type = "Breed"}) : super(key: key);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(padding * 2),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Custom $type",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CommonTextField(
              name: "breed_name",
              labelText: type ?? "Breed Type",
            ),
            Spacer(),
            RoundRectangleButton(
              margin: EdgeInsets.all(0),
              title: "Add Custom $type",
              onPressed: () {
                _formKey.currentState.save();
                var val = _formKey.currentState.value;
                Navigator.pop(context, val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
