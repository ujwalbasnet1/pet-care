import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

import 'custom_image.dart';

class VideoImageThumbnail extends StatefulWidget {
  final String imageVideoPath;
  final Function() onTap;
  const VideoImageThumbnail({Key key, this.imageVideoPath, this.onTap})
      : super(key: key);

  @override
  _VideoImageThumbnailState createState() => _VideoImageThumbnailState();
}

class _VideoImageThumbnailState extends State<VideoImageThumbnail> {
  VideoPlayerController _controller;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();

    checkFileType();
  }

  void checkFileType() {
    var type = lookupMimeType(widget.imageVideoPath);
    if (type.contains('video')) {
      isVideo = true;
      setState(() {});
      _controller = VideoPlayerController.network(widget.imageVideoPath)
        ..initialize().then((_) {
          setState(() {}); //when your thumbnail will show.
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (isVideo) _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: isVideo
          ? _controller.value.isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: VideoPlayer(_controller),
                    ),
                    Icon(
                      Icons.play_circle_outline_outlined,
                      size: 35,
                      color: Colors.blue,
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator())
          : CustomImage(
              url: widget.imageVideoPath,
              // 'https://unsplash.com/photos/2UZ4kQRImVg/download?force=true&w=640',
              fit: BoxFit.cover,
            ),
      onTap: widget.onTap,
    );
  }
}
