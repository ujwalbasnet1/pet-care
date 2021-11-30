import 'package:flutter/material.dart';

import 'add_text_dialog.dart';

class EditableTextView extends StatefulWidget {
  final AddTextEditingController addTextEditingController;
  const EditableTextView({Key key, this.addTextEditingController})
      : super(key: key);

  @override
  _EditableTextViewState createState() => _EditableTextViewState();
}

class _EditableTextViewState extends State<EditableTextView> {
  AddTextEditingController _aTec;
  @override
  void initState() {
    super.initState();
    _aTec = widget.addTextEditingController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onDoubleTap: () async {
          await addTextDialog(context, _aTec);
          setState(() {});
        },
        child: Text(
          _aTec.text,
          style: _aTec.textStyle,
        ),
      ),
    );
  }
}
