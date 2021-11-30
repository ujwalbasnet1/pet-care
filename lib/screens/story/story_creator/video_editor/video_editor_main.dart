import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pets/utils/app_utils.dart';
import '../components/message_view.dart';
import '../video_editor/video_player_view.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoEditorMain extends StatefulWidget {
  final String filePath;

  VideoEditorMain(this.filePath);

  @override
  _VideoEditorMainState createState() => _VideoEditorMainState();
}

class _VideoEditorMainState extends State<VideoEditorMain> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: File(widget.filePath));
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Post Video"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      bool playbackState = await _trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                              width: double.infinity,
                              child: VideoViewer(trimmer: _trimmer)),
                          _isPlaying
                              ? Container()
                              : Icon(
                                  Icons.play_arrow,
                                  size: 80.0,
                                  color: Colors.white,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TrimEditor(
                    thumbnailQuality: 10,
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: Duration(seconds: 15),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                MessageView(
                  message: (String message) {},
                  onTap: _progressVisibility
                      ? null
                      : () async {
                          _saveVideo().then((outputPath) {
                            print('OUTPUT PATH: $outputPath');
                            showToast('Your Post is under Review', context);
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => VideoPlayerView(
                            //               filePath: outputPath,
                            //             )));
                            // final snackBar = SnackBar(
                            //     content: Text('Video Saved successfully'));
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   snackBar,
                            // );
                          });
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
