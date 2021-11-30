import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/theming/common_size.dart';

joinGroup(context, {String referalCode}) {
  TextEditingController textEditingController = new TextEditingController();
  textEditingController.text = referalCode ?? "";
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRect(
            child: Container(
              height: 280,
              child: GradientBg(
                child: Padding(
                  padding: const EdgeInsets.all(padding * 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Join Group",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      FormBuilderTextField(
                        controller: textEditingController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        decoration: CommonTextField.decoration
                            .copyWith(labelText: "Enter Referral Code"),
                        name: "referal_code",
                      ),
                      Spacer(),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            color: Colors.red,
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(
                                  context, textEditingController.text);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
