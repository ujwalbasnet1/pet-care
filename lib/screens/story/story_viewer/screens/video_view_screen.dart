import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'gesture_controller.dart';
// import 'package:share/share.dart';

class VideoViewer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final Function() onNext;
  final Function() onPrevious;
  final Function() onDoubleTap;
  final Function() onLongPressStart;
  final Function() onLongPressEnd;
  final Function(VideoPlayerController) onControllerCreated;
  final Function(double) currentProgress;

  const VideoViewer(
      {Key key,
      this.videoUrl,
      this.caption,
      this.onNext,
      this.onPrevious,
      this.onDoubleTap,
      this.currentProgress,
      this.onLongPressStart,
      this.onLongPressEnd,
      this.onControllerCreated})
      : super(key: key);
  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController _videoController;
  bool isLoaded = false;
  bool hide = false;
  bool hasVideo = false;
  bool isUpdate = true;
  @override
  void initState() {
    print(widget.videoUrl == null);
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((value) {
          widget.onControllerCreated(_videoController);
          _videoController.play();
          setState(() {
            isLoaded = true;
          });
        });
      _videoController.addListener(() {
        if (_videoController.value.duration != null) {
          if (!_videoController.value.isPlaying &&
              _videoController.value.isInitialized &&
              (_videoController.value.duration ==
                  _videoController.value.position)) {
            if (isUpdate) {
              widget.onNext();
            }
            isUpdate = false;
          }
        }
        if (isUpdate) {
          widget.currentProgress(_videoController.value.position.inSeconds /
              _videoController.value.duration.inSeconds);
        }
      });
    } else {
      setState(() {});
      hide = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_videoController != null) {
      _videoController.removeListener(() {});
      _videoController.dispose();
      _videoController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = double.infinity;
        var isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        var children = [
          Icon(
            Icons.favorite,
            color: Colors.white,
            size: 35,
          ),
          Padding(
            padding: EdgeInsets.only(top: isPortrait ? 20.0 : 0),
            child: InkWell(
              onTap: () async {
                // await Share.share(widget.data.posterurl);
              },
              child: Icon(
                Icons.ios_share,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ];

        _detailsAndButton() {
          return Container(
            height: height * 30,
            color: Colors.black.withAlpha(150),
            padding: EdgeInsets.fromLTRB(23, 23, 25, isPortrait ? 60 : 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: isPortrait
                      ? Column(
                          children: children,
                        )
                      : Container(
                          width: 120,
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          ),
                        ),
                )
              ],
            ),
          );
        }

        _getVideoPlayer() {
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              height: _videoController.value.size?.height ?? 0,
              width: _videoController.value.size?.width ?? 0,
              child: VideoPlayer(_videoController),
            ),
          );

          // VideoPlayer(_videoController);
        }

        _getLoading() {
          return Stack(
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  // child: CustomImage(url: widget.data.posterurl ?? "")

                  /*Image.network(
                    widget.data.posterurl ?? ,
                    fit: BoxFit.fill,
                  ),*/
                ),
              ),
              hide
                  ? Container()
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    )
            ],
          );
        }

        return GestureController(
            onLongPressStart: () {
              _videoController.pause();
              widget.onLongPressStart();
            },
            onLongPressEnd: () {
              _videoController.play();
              widget.onLongPressEnd();
            },
            onNext: () {
              widget.onNext();
            },
            onPrevious: widget.onPrevious,
            onDoubleTap: widget.onDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.videoUrl != null
                    ? isLoaded || _videoController.value.isPlaying
                        ? _getVideoPlayer()
                        : _getLoading()
                    : _getLoading(),
                // _detailsAndButton()
              ],
            ));
        ;
      },
    );
  }
}
