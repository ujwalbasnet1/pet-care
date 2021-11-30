import 'dart:async';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mime/mime.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/screens/story/components/camera_button.dart';
import 'package:pets/screens/story/components/animated_gradient_border.dart';
import 'package:pets/screens/story/story_viewer/story_home.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';
import '../image_editor/image_editor_main.dart';
import '../video_editor/video_editor_main.dart';

import 'camera_provider.dart';

class CameraView extends StatefulWidget {
  final bool needScaffold;

  CameraView({this.needScaffold = false});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController controller;
  int _cameraIndex = 0;
  bool _cameraNotAvailable = false;
  bool isRecording = false;
  bool isFlashOn = true;
  List<String> postMode = ['POST', 'REELS'];
  CameraProvider _myProvider;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  setFlashMode() {
    if (!isFlashOn) {
      controller.setFlashMode(FlashMode.off);
    } else {
      controller.setFlashMode(FlashMode.auto);
    }
    log(isFlashOn.toString());
  }

  void _initCamera(int index) async {
    // if (controller != null) {
    //   await controller.dispose();
    // }
    controller = CameraController(cameras[index], ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // controller.addListener(() {
    //   if (mounted) setState(() {});
    //   if (controller.value.hasError) {
    //     _showInSnackBar('Camera error ${controller.value.errorDescription}');
    //   }
    // });

    try {
      await controller.initialize();
      await controller.lockCaptureOrientation();
      setFlashMode();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {
        _cameraIndex = index;
      });
    }
  }

  CarouselController buttonCarouselController = CarouselController();
  void _onSwitchCamera() {
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }
    final newIndex = _cameraIndex + 1 == cameras.length ? 0 : _cameraIndex + 1;
    // controller.
    _initCamera(newIndex);
  }

  void _onTakePictureButtonPress() {
    _takePicture().then((filePath) {
      log(filePath.toString());
      if (filePath != null) {
        // _showInSnackBar('Picture saved to $filePath');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ImageEditorMain(filePath: filePath);
        }));
      }
    });
  }

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return null;
    }
    String filePath = await getPath('Pictures', '.jpg');
    try {
      XFile xFile = await controller.takePicture();
      xFile.saveTo(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget _buildGalleryBar() {
    final barHeight = 90.0;
    final vertPadding = 10.0;

    return Container(
      height: barHeight,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: vertPadding),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int _) {
          return Container(
            padding: EdgeInsets.only(right: 5.0),
            width: 70.0,
            height: barHeight - vertPadding * 2,
            // child: Image(
            //   image: randomImageUrl(),
            //   fit: BoxFit.cover,
            // ),
          );
        },
      ),
    );
  }

  Widget _cameraButtonDesign(CameraProvider cPro) {
    return CameraButton(
        isCameraMode: cPro.isCameraMode, isRecording: cPro.isRecording);
  }

  Widget _cameraButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Consumer(
            builder: (BuildContext context, CameraProvider cPro, Widget child) {
              return GestureDetector(
                  onTap: () {
                    if (!cPro.isCameraMode) {
                      if (cPro.isRecording) {
                        cPro.stopRecordering();
                      } else {
                        cPro.startTimer(controller, context);
                      }
                    } else {
                      _onTakePictureButtonPress();
                    }
                  },
                  onLongPress: () {
                    if (!cPro.isCameraMode) {
                      cPro.startTimer(controller, context);
                    }
                  },
                  onLongPressEnd: (val) {
                    if (!cPro.isCameraMode) {
                      cPro.stopRecordering();
                    } else {
                      _onTakePictureButtonPress();
                    }
                  },
                  child: _cameraButtonDesign(cPro));
            },
          ),
        ],
      ),
    );
  }

  Widget _settingWidget() {
    return Consumer(
      builder: (BuildContext context, CameraProvider cPro, Widget child) {
        double progress = (15 - cPro.getRemainTime) / 15;
        print("object $progress");
        return cPro.isRecording
            ? Container(
                margin: EdgeInsets.only(bottom: 7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: progress * MediaQuery.of(context).size.width,
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.redAccent]),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${cPro.getRemainTime}",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  ],
                ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width / 2.2)),
                    child: IconButton(
                      color: Colors.white,
                      icon:
                          Icon(isFlashOn ? Icons.flash_auto : Icons.flash_off),
                      onPressed: () {
                        isFlashOn = !isFlashOn;
                        setState(() {});
                        setFlashMode();
                        //
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 75,
                    child: FittedBox(
                      child: CloseButton(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              );
        ;
      },
    );
  }

  Widget _cameraSelector(CameraProvider cPro) {
    print("current mode : ${cPro.getCurrentMode}");
    return Center(
        child: CarouselSlider(
      carouselController: buttonCarouselController,
      options: CarouselOptions(
          onPageChanged: (int, reson) {
            cPro.setCurrentMode = int;
          },
          enableInfiniteScroll: false,
          viewportFraction: 0.3,
          enlargeCenterPage: true,
          height: 40.0,
          enlargeStrategy: CenterPageEnlargeStrategy.height),
      items: postMode.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () =>
                  {buttonCarouselController.animateToPage(postMode.indexOf(i))},
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(),
                  child: Text('$i',
                      style: cPro.getCurrentMode == postMode.indexOf(i)
                          ? TextStyle(fontSize: 16.0, color: Colors.white)
                          : TextStyle(fontSize: 14.0, color: Colors.white38))),
            );
          },
        );
      }).toList(),
    ));
  }

  Widget _buildControlBar(CameraProvider cPro) {
    return cPro.isRecording
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              cPro.isRecording
                  ? Spacer()
                  : Expanded(
                      child: Row(
                      children: [
                        IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.image),
                            onPressed: () async {
                              var selectedPath = "";

                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.media,
                              );

                              if (result != null) {
                                selectedPath = result.files.single.path;
                              } else {
                                return;
                              }

                              if (selectedPath != null) {
                                var type = lookupMimeType(selectedPath);
                                if (type.contains('video')) {
                                  pushReplacement(
                                      context, VideoEditorMain(selectedPath));
                                } else {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ImageEditorMain(
                                        filePath: selectedPath);
                                  }));
                                }
                              }
                            }),
                        Expanded(
                          child: _cameraSelector(cPro),
                        ),
                      ],
                    )),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.switch_camera),
                onPressed: _onSwitchCamera,
              ),
            ],
          );
  }

  @override
  void initState() {
    // context.read<CameraProvider>().reset();
    _myProvider = Provider.of<CameraProvider>(context, listen: false);
    super.initState();
    if (cameras == null || cameras.isEmpty) {
      setState(() {
        _cameraNotAvailable = true;
      });
    }
    _initCamera(_cameraIndex);
    loadImageList();
    // carousalPostion();
  }

  carousalPostion() {
    buttonCarouselController
        .animateToPage(context.read<CameraProvider>().getCurrentMode);
  }

  Future<void> loadImageList() async {
    // final MediaCollections  collections = await MediaGallery.listMediaCollections(
    //   mediaTypes: [MediaType.image, MediaType.video],
    // );
    // var list = collections
    // log("===========");
    // log(list.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraNotAvailable) {
      final center = Center(
        child: Text('Camera not available /_\\'),
      );

      if (widget.needScaffold) {
        return Scaffold(
          appBar: AppBar(),
          body: center,
        );
      }

      return center;
    }

    final stack = Stack(
      children: <Widget>[
        Container(
          color: Colors.black,
          child: Center(
            child: controller.value.isInitialized
                ? Column(
                    children: [
                      Flexible(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 75,
                          width: double.infinity,
                          // aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(controller),
                        ),
                      )
                    ],
                  )
                : Text('Loading camera...'),
          ),
        ),
        Align(alignment: Alignment.topRight, child: _settingWidget()),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildGalleryBar(),
            _cameraButton(),
            Consumer(
              builder:
                  (BuildContext context, CameraProvider cPro, Widget child) {
                return _buildControlBar(cPro);
                // return cPro.isRecording ? Container() : _buildControlBar();
              },
            )
          ],
        )
      ],
    );

    if (widget.needScaffold) {
      return SafeArea(
        child: Scaffold(
          body: stack,
        ),
      );
    }

    return SafeArea(child: Material(child: stack));
  }

  @override
  void dispose() {
    print("======> Dispose <===> object");
    _myProvider.reset();
    // if (controller != null) {
    //   controller.dispose();
    // }
    super.dispose();
  }
}
