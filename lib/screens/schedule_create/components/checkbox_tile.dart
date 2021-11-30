import 'package:flutter/material.dart';

class CheckBoxTile extends StatefulWidget {
  final String title;
  final Function(String title, bool value) onPressed;
  CheckBoxTile({
    this.title,
    this.onPressed,
  });
  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        value: _value,
        selected: _value,
        title: Text(
          widget.title ?? "Title",
          style: Theme.of(context).textTheme.headline6,
        ),
        onChanged: (val) {
          widget.onPressed(widget.title, val);
          setState(() {
            _value = val;
          });
        });
  }
}
