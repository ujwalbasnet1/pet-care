import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pets/screens/story/story_creator/image_editor/components/color_picker.dart';

import 'font_picker.dart';
import 'font_size_picker.dart';

addTextDialog(context, AddTextEditingController addTextEditingController,
    {Color color = Colors.white, text = ""}) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.transparent,
              child: CustomAddTextEditor(
                addTextEditingController: addTextEditingController,
              )),
        );
      });
}

class CustomAddTextEditor extends StatefulWidget {
  final AddTextEditingController addTextEditingController;
  const CustomAddTextEditor({Key key, this.addTextEditingController})
      : super(key: key);

  @override
  _CustomAddTextEditorState createState() => _CustomAddTextEditorState();
}

class _CustomAddTextEditorState extends State<CustomAddTextEditor> {
  Color _currentColor;
  AddTextEditingController _addTextEditingController;
  @override
  void initState() {
    super.initState();
    _addTextEditingController =
        widget.addTextEditingController ?? new AddTextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 380,
              child: Row(
                children: [
                  FontSizePicker(
                    fontSize: _addTextEditingController.fontSize,
                    onChange: (double size) {
                      print('$size, test');
                      setState(() {
                        _addTextEditingController.fontSize = size;
                      });
                    },
                  ),
                  Flexible(
                    child: SizedBox(
                      child: TextField(
                        // cursorHeight: 10,
                        controller:
                            _addTextEditingController.textEditingController,
                        autofocus: true,
                        maxLines: null,
                        style: _addTextEditingController.textStyle,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BarColorPicker(
                          width: 300,
                          thumbColor: Colors.blue,
                          cornerRadius: 10,
                          horizontal: false,
                          pickMode: PickMode.Color,
                          colorListener: (int value) {
                            widget.addTextEditingController.color =
                                Color(value);
                            setState(() {
                              _currentColor = Color(value);
                            });
                          }),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 50,
                child: FontPicker(
                  onSelected: (String font) {
                    setState(() {
                      _addTextEditingController.font = font;
                    });
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class AddTextEditingController extends ValueNotifier {
  TextEditingController textEditingController;
  Color _color;
  String _font;
  double _fontSize;
  AddTextEditingController(
      {String text,
      TextEditingController textEditingController,
      Color color,
      String font,
      double fontSize})
      : super(null) {
    this.textEditingController =
        textEditingController ?? new TextEditingController(text: text);
    this.color = color ?? Colors.blue;
    this.font = font ?? 'Lato';
    this.fontSize = fontSize ?? 95.0;
  }

  set color(value) => this._color = value;
  set font(value) => this._font = value;
  set fontSize(value) => this._fontSize = value;
  TextStyle get textStyle => GoogleFonts.getFont(font)
      .copyWith(fontSize: fontSize, color: color, fontWeight: FontWeight.w400);
  Color get color => this._color;
  String get font => this._font;
  double get fontSize => this._fontSize;

  String get text => this.textEditingController.text;
}
