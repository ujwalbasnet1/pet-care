import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:pets/common/colors.dart';

import '../../image_editor/components/crop_editor_helper.dart';
import 'common_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///
///  create by zmtzawqlp on 2019/8/22
///

class CropRotateView extends StatefulWidget {
  final String filePath;

  const CropRotateView({Key key, this.filePath}) : super(key: key);
  @override
  _CropRotateViewState createState() => _CropRotateViewState();
}

class _CropRotateViewState extends State<CropRotateView> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
      GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
    AspectRatioItem(text: 'original', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];
  AspectRatioItem _aspectRatio;
  bool _cropping = false;

  EditorCropLayerPainter _cropLayerPainter;

  @override
  void initState() {
    _aspectRatio = _aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bottomButton({icon, label, onPressed}) {
      return FlatButtonWithIcon(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
            ),
          ),
          textColor: Colors.white,
          onPressed: onPressed);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: const Text('image editor demo'),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.photo_library),
          //   onPressed: _getImage,
          // ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              _cropImage(true);
              // if (kIsWeb) {
              //   _cropImage(false);
              // } else {
              //   _showCropDialog(context);
              // }
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        // SizedBox(
        //   height: 30,
        // ),
        // Row(
        //   children: [
        //     BackButton(color: blueClassicColor),
        //     Spacer(),
        //     IconButton(
        //       icon: const Icon(Icons.done, color: blueClassicColor),
        //       onPressed: () {
        //         _cropImage(true);
        //         // if (kIsWeb) {
        //         //   _cropImage(false);
        //         // } else {
        //         //   _showCropDialog(context);
        //         // }
        //       },
        //     )
        //   ],
        // ),
        Expanded(
          child: _memoryImage != null
              ? Container(
                  color: Colors.black,
                  child: ExtendedImage.memory(
                    _memoryImage,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (ExtendedImageState state) {
                      return EditorConfig(
                        maxScale: 8.0,
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        cropLayerPainter: _cropLayerPainter,
                        initCropRectType: InitCropRectType.imageRect,
                        cropAspectRatio: _aspectRatio.value,
                      );
                    },
                    cacheRawData: true,
                  ),
                )
              : Container(
                  color: Colors.black,
                  child: ExtendedImage.file(
                    File(widget.filePath),
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (ExtendedImageState state) {
                      return EditorConfig(
                        maxScale: 8.0,
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        cropLayerPainter: _cropLayerPainter,
                        initCropRectType: InitCropRectType.imageRect,
                        cropAspectRatio: _aspectRatio.value,
                      );
                    },
                    cacheRawData: true,
                  ),
                ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        child: ButtonTheme(
          // colorScheme: ColorScheme.dark(),

          minWidth: 0.0,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisSize: MainAxisSize.mn,
            children: <Widget>[
              _bottomButton(
                icon: Icons.crop,
                label: 'Crop',
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: <Widget>[
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              color: Colors.black,
                              height: 80,
                              child: ListView.builder(
                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(2.0),
                                itemBuilder: (_, int index) {
                                  final AspectRatioItem item =
                                      _aspectRatios[index];
                                  return GestureDetector(
                                    child: AspectRatioWidget(
                                      aspectRatio: item.value,
                                      aspectRatioS: item.text,
                                      isSelected: item == _aspectRatio,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _aspectRatio = item;
                                      });
                                    },
                                  );
                                },
                                itemCount: _aspectRatios.length,
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
              _bottomButton(
                icon: Icons.flip,
                label: 'Flip',
                onPressed: () {
                  editorKey.currentState.flip();
                },
              ),
              _bottomButton(
                icon: Icons.rotate_left,
                label: 'Rotate Left',
                onPressed: () {
                  editorKey.currentState.rotate(right: false);
                },
              ),
              _bottomButton(
                icon: Icons.rotate_right,
                label: 'Rotate Right',
                onPressed: () {
                  editorKey.currentState.rotate(right: true);
                },
              ),
              // FlatButtonWithIcon(
              //   icon: const Icon(Icons.rounded_corner_sharp,color : Colors.white,),
              //   label: PopupMenuButton<EditorCropLayerPainter>(
              //     key: popupMenuKey,
              //     enabled: false,
              //     offset: const Offset(100, -300),
              //     child: const Text(
              //       'Painter',
              //       style: TextStyle(fontSize: 8.0),
              //     ),
              //     initialValue: _cropLayerPainter,
              //     itemBuilder: (BuildContext context) {
              //       return <PopupMenuEntry<EditorCropLayerPainter>>[
              //         PopupMenuItem<EditorCropLayerPainter>(
              //           child: Row(
              //             children: const <Widget>[
              //               Icon(
              //                 Icons.rounded_corner_sharp,
              //                 color: Colors.blue,
              //               ),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               Text('Default'),
              //             ],
              //           ),
              //           value: const EditorCropLayerPainter(),
              //         ),
              //         const PopupMenuDivider(),
              //         PopupMenuItem<EditorCropLayerPainter>(
              //           child: Row(
              //             children: const <Widget>[
              //               Icon(
              //                 Icons.circle,
              //                 color: Colors.blue,
              //               ),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               Text('Custom'),
              //             ],
              //           ),
              //           value: const CustomEditorCropLayerPainter(),
              //         ),
              //         const PopupMenuDivider(),
              //         PopupMenuItem<EditorCropLayerPainter>(
              //           child: Row(
              //             children: const <Widget>[
              //               Icon(
              //                 CupertinoIcons.circle,
              //                 color: Colors.blue,
              //               ),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               Text('Circle'),
              //             ],
              //           ),
              //           value: const CircleEditorCropLayerPainter(),
              //         ),
              //       ];
              //     },
              //     onSelected: (EditorCropLayerPainter value) {
              //       if (_cropLayerPainter == value) {
              //         setState(() {
              //           if (value is CircleEditorCropLayerPainter) {
              //             _aspectRatio = _aspectRatios[2];
              //           }
              //           _cropLayerPainter = value;
              //         });
              //       }
              //     },
              //   ),
              //   textColor: Colors.white,
              //   onPressed: () {
              //     popupMenuKey.currentState.showButtonMenu();
              //   },
              // ),

              _bottomButton(
                icon: Icons.restore,
                label: 'Reset',
                onPressed: () {
                  editorKey.currentState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCropDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (BuildContext content) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Material(
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'select library to crop',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text.rich(TextSpan(children: <TextSpan>[
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Image',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationColor: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // launch(
                                      //     'https://github.com/brendan-duncan/image');
                                    }),
                              const TextSpan(
                                  text:
                                      '(Dart library) for decoding/encoding image formats, and image processing. It\'s stable.')
                            ],
                          ),
                          const TextSpan(text: '\n\n'),
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'ImageEditor',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationColor: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // launch(
                                      //     'https://github.com/fluttercandies/flutter_image_editor');
                                    }),
                              const TextSpan(
                                  text:
                                      '(Native library) support android/ios, crop flip rotate. It\'s faster.')
                            ],
                          )
                        ])),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            OutlinedButton(
                              child: const Text(
                                'Dart',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _cropImage(false);
                              },
                            ),
                            OutlinedButton(
                              child: const Text(
                                'Native',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _cropImage(true);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ))),
              Expanded(
                child: Container(),
              )
            ],
          );
        });
  }

  Future<void> _cropImage(bool useNative) async {
    if (_cropping) {
      return;
    }
    String msg = '';

    try {
      _cropping = true;

      //await showBusyingDialog();

      Uint8List fileData;

      /// native library
      // if (useNative) {
      fileData =
          await cropImageDataWithNativeLibrary(state: editorKey.currentState);
      // } else {
      ///delay due to cropImageDataWithDartLibrary is time consuming on main thread
      ///it will block showBusyingDialog
      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      //await Future.delayed(Duration(milliseconds: 200));

      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      // fileData =
      //     await cropImageDataWithDartLibrary(state: editorKey.currentState);
      // }
      final String filePath = widget.filePath;

      // await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
      // var filePath = await ImagePickerSaver.saveFile(fileData: fileData);
      final File file = File(filePath);
      await file.writeAsBytes(fileData);
      msg = 'save image : $filePath';
      log(msg);
    } catch (e, stack) {
      msg = 'save failed: $e\n $stack';
      log(msg);
    }

    Navigator.of(context).pop();
    // showToast(msg);
    _cropping = false;
  }

  Uint8List _memoryImage;
  Future<void> _getImage() async {
    // _memoryImage = await pickImage(context);
    //when back to current page, may be editorKey.currentState is not ready.
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        editorKey.currentState.reset();
      });
    });
  }
}

class CustomEditorCropLayerPainter extends EditorCropLayerPainter {
  const CustomEditorCropLayerPainter();
  @override
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Paint paint = Paint()
      ..color = painter.cornerColor
      ..style = PaintingStyle.fill;
    final Rect cropRect = painter.cropRect;
    const double radius = 6;
    canvas.drawCircle(Offset(cropRect.left, cropRect.top), radius, paint);
    canvas.drawCircle(Offset(cropRect.right, cropRect.top), radius, paint);
    canvas.drawCircle(Offset(cropRect.left, cropRect.bottom), radius, paint);
    canvas.drawCircle(Offset(cropRect.right, cropRect.bottom), radius, paint);
  }
}

class CircleEditorCropLayerPainter extends EditorCropLayerPainter {
  const CircleEditorCropLayerPainter();

  @override
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    // do nothing
  }

  @override
  void paintMask(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect rect = Offset.zero & size;
    final Rect cropRect = painter.cropRect;
    final Color maskColor = painter.maskColor;
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = maskColor);
    canvas.drawCircle(cropRect.center, cropRect.width / 2.0,
        Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  void paintLines(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect cropRect = painter.cropRect;
    if (painter.pointerDown) {
      canvas.save();
      canvas.clipPath(Path()..addOval(cropRect));
      super.paintLines(canvas, size, painter);
      canvas.restore();
    }
  }
}
