import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import '../story_creator/camera_view/camera_view.dart';
import '../story_creator/image_editor/components/draw_widget.dart';
import 'components/story_item.dart';
import 'data.dart';
import 'story_view_main.dart';

List<CameraDescription> cameras;
void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class StoryHome extends StatefulWidget {
  final Widget body;
  const StoryHome({Key key, this.body}) : super(key: key);

  @override
  _StoryHomeState createState() => _StoryHomeState();
}

class _StoryHomeState extends State<StoryHome> {
  @override
  void initState() {
    initCamera();
    super.initState();
  }

  initCamera() async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      log("========== message");
      print(e);
      log("========== message");
    }
  }

  storyRow(name, image, context, {Function() onTap}) {
    final double size = 100;
    return Container(
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StoryItem(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/contact_add.png",
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, right: 5),
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => CameraView()));
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text('Add Story')),
                              )),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 15),
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  StoryViewMain(
                                                    initialPage: 0,
                                                    data: jsonData,
                                                  )));
                                    },
                                    icon: Icon(Icons.image),
                                    label: Text('View Story')),
                              )),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              size: size,
              image: image,
              title: name),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: jsonData.length,
              itemBuilder: (BuildContext context, int index) {
                var data = jsonData[index];
                return StoryItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => StoryViewMain(
                                    initialPage: index,
                                    data: jsonData,
                                  )));
                    },
                    size: size,
                    image: data['image'],
                    title: data['username']);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.body; // Expanded(child: CreateMessage())

    // floatingActionButton: FloatingActionButton(
    //   onPressed: () async {
    //     final ImagePicker _picker = ImagePicker();
    //     // Pick an image
    //     final XFile image =
    //         await _picker.pickImage(source: ImageSource.gallery);

    //     AwsS3 awsS3 = AwsS3(
    //         awsFolderPath: "",
    //         file: File(image.path),
    //         fileNameWithExt: "testing.jpg",
    //         region: Regions.US_EAST_2,
    //         bucketName: "ecom-bucket-chandrani",
    //         poolId: 'us-east-2:113bff97-6a20-438a-bab7-65c532f1d77d');
    //     var result = await awsS3.uploadFile;
    //     awsS3.getUploadStatus.listen((event) {
    //       print(event);
    //       log("message");
    //     });
    //     print(result);
    //   },
    // ),
  }
}
