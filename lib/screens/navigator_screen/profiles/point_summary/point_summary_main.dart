import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pets/theming/common_size.dart';

class PointSummaryMain extends StatefulWidget {
  @override
  _PointSummaryMainState createState() => _PointSummaryMainState();
}

class _PointSummaryMainState extends State<PointSummaryMain> {
  @override
  Widget build(BuildContext context) {
    var _decoration = InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)));
    return Scaffold(
      appBar: appBarWidget(
          color: Colors.blue, context: context, name: "Point Summary"),
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: FormBuilder(
          child: Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: FormBuilderDropdown(
                        decoration: _decoration.copyWith(hintText: "Select"),
                        items: [],
                        name: "first",
                      ),
                    ),
                    Expanded(
                      child: FormBuilderDropdown(
                        decoration: _decoration,
                        items: [],
                        name: "second",
                      ),
                    ),
                    Expanded(
                        child: FormBuilderDateTimePicker(
                      decoration: _decoration,
                      name: "date",
                    ))
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
