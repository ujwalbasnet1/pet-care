import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pets/utils/app_utils.dart';
import '../camera_view/camera_provider.dart';
import '../components/drag_and_resize.dart';
import '../components/message_view.dart';
import '../components/sticker_view.dart';
import '../image_editor/components/crop_rotate_view.dart';
import 'dart:ui' as ui;
import 'text_editor/add_text_dialog.dart';
import 'text_editor/editable_text_view.dart';

class ImageEditorMain extends StatefulWidget {
  final String filePath;
  const ImageEditorMain({Key key, this.filePath}) : super(key: key);

  @override
  _ImageEditorMainState createState() => _ImageEditorMainState();
}

class _ImageEditorMainState extends State<ImageEditorMain> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  bool isEditing = true;
  List<Widget> stackItemList = [];
  final key = new GlobalKey();
  final _imageViewKey = new GlobalKey();
  int currentIndex = 0;
  double width = 0, height = 0;
  Size imageViewSize = Size(0, 0);
  Rect widgetRect;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("Disposed");
    log(widget.filePath);
    File xFile = File(widget.filePath);
    xFile.delete().then((value) => print(value));
    imageCache.clear();
  }

  init() {
    // stackItemList.add(Center(
    //     child: Image.file(
    //   File(widget.filePath),
    //   key: key,
    // )));
    Future.delayed(Duration(seconds: 1)).then((value) {
      getHeight();
      setState(() {});
      onAddStickerHandler();
    });
  }

  void onAddStickerHandler() async {
    var path = await showStickerSheet(context);
    if (path != null) {
      addStickers(path);
    }
  }

// ValueChanged<Color> callback

  void getHeight() {
    final size = key.currentContext.size;
    final RenderBox renderBox =
        key.currentContext.findRenderObject() as RenderBox;
    width = size.width;
    height = size.height;
    imageViewSize = Size(width, height);
    widgetRect = renderBox.localToGlobal(Offset.zero) & size;
    log(height.toString());
    log(width.toString());
  }

  addWidgets(Widget widget) {
    getHeight();
    stackItemList.add(Center(
        key: Key(stackItemList.length.toString()),
        child: DRSView(
          child: widget,
        )
        // ResizebleWidget(
        //     key: Key(stackItemList.length.toString()),
        //     child: widget,
        //     size: imageViewSize,
        //     parentRect: widgetRect,
        //     onSelect: (val) {
        //       var widget =
        //           stackItemList.firstWhere((element) => element.key == val);
        //       int index = stackItemList.indexOf(widget);
        //       if (currentIndex != index) {
        //         currentIndex = index;
        //         setState(() {});
        //       }
        //     }),
        ));
    setState(() {});
  }

  addStickers(String stickerPath) {
    addWidgets(Image.asset(stickerPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: <Widget>[
            stackItemList.length > 0
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      stackItemList.removeAt(currentIndex);
                      setState(() {});
                    },
                  )
                : Container(),
            IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: () async {
                AddTextEditingController aTec = new AddTextEditingController();
                await addTextDialog(context, aTec);

                // TextEditingController textEditingController =
                //     new TextEditingController(text: 'text');
                addWidgets(EditableTextView(addTextEditingController: aTec));
              },
            ),
            IconButton(
              icon: Icon(Icons.crop_rotate),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            CropRotateView(filePath: widget.filePath)));

                imageCache.clear();
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.insert_emoticon),
              onPressed: onAddStickerHandler,
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  height = height == 0 ? constraints.maxHeight - 20 : height;
                  width = width == 0 ? constraints.maxWidth : width;
                  return Container(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          height: height,
                          child: Center(
                            child: RepaintBoundary(
                              key: _imageViewKey,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.file(
                                      File(widget.filePath),
                                      key: key,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  // DrawPage(),
                                  Stack(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    alignment: AlignmentDirectional.center,
                                    children: stackItemList,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
              MessageView(
                  message: (String message) {},
                  onTap: () async {
                    final devicePixelRatio =
                        MediaQuery.of(context).devicePixelRatio;
                    log(devicePixelRatio.toString());
                    final RenderRepaintBoundary boundary =
                        _imageViewKey.currentContext.findRenderObject()
                            as RenderRepaintBoundary;
                    final ui.Image image =
                        await boundary.toImage(pixelRatio: devicePixelRatio);
                    final ByteData byteData =
                        await image.toByteData(format: ui.ImageByteFormat.png);
                    final Uint8List pngBytes = byteData.buffer.asUint8List();

                    String imagePath = await getPath('Pictures', '.png');
                    File imgFile = new File(imagePath);
                    imgFile.writeAsBytes(pngBytes);
                    showToast('Your Post is under Review', context);
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => Scaffold(
                    //               body: Center(
                    //                 child: Container(
                    //                   width: double.infinity,
                    //                   height: double.infinity,
                    //                   child: Image.file(
                    //                     imgFile,
                    //                     fit: BoxFit.contain,
                    //                   ),
                    //                 ),
                    //               ),
                    //             )));
                  }),
            ],
          ),
        ));
  }
}
