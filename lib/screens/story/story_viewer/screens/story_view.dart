import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:pets/screens/story/story_profile/story_profile_main.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../components/circular_button.dart';
import '../components/story_progress_bar.dart';
import '../provider/story_main_provider.dart';
import '../screens/image_view_screen.dart';
import '../screens/video_view_screen.dart';

class StoryViewer extends StatefulWidget {
  final Map<String, Object> data;
  final Function() onNext;
  final Function() onPrevious;
  const StoryViewer({Key key, this.data, this.onNext, this.onPrevious})
      : super(key: key);

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  PageController _pageController = new PageController();
  VideoPlayerController _videoPlayerController;
  StoryMainProvider _storyMainProvider;
  @override
  void initState() {
    initProvider();
    super.initState();
  }

  initProvider() {
    int length = (widget.data['stories'] as List).length;
    _storyMainProvider = Provider.of<StoryMainProvider>(context, listen: false);
    _storyMainProvider.initStoryView(length, _pageController);
  }

  @override
  void dispose() {
    _storyMainProvider.resetTab();
    super.dispose();
  }

  onLike() {
    print("called");
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 200), () {
            Navigator.of(context).pop();
          });
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.favorite,
                    size: 250, color: Colors.white.withAlpha(100)),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (widget.data['stories'] as List).length,
          itemBuilder: (BuildContext context, int index) {
            final storiesList = (widget.data['stories'] as List);
            final url = storiesList[index]['url'];
            final type = lookupMimeType(url);
            final length = storiesList.length;
            StoryMainProvider smPro = context.read<StoryMainProvider>();

            if (type.contains('video')) {
              return Center(
                  child: VideoViewer(
                onControllerCreated:
                    (VideoPlayerController videoPlayerController) {
                  _videoPlayerController = videoPlayerController;
                },
                currentProgress: (double value) {
                  smPro.setProgress(value);
                },
                onLongPressEnd: () {
                  smPro.setPause(false);
                },
                onLongPressStart: () {
                  smPro.setPause(true);
                },
                videoUrl: url,
                onDoubleTap: () {
                  onLike();
                },
                onNext: () {
                  if (smPro.onNext()) {
                    smPro.resetTab();
                    widget.onNext();
                  }
                },
                onPrevious: () {
                  if (smPro.onPrevious()) {
                    smPro.resetTab();
                    widget.onPrevious();
                  }
                },
              ));
            }
            _videoPlayerController = null;
            return Center(
                child: ImageView(
              imageUrl: url,
              onDoubleTap: () {
                onLike();
              },
              onNext: smPro.onNext,
              onPrevious: smPro.onPrevious,
              onLongPressEnd: () {
                smPro.setPause(false);
              },
              onLongPressStart: () {
                smPro.setPause(true);
              },
            ));
          },
        ),
        Consumer(
          builder:
              (BuildContext context, StoryMainProvider smPro, Widget child) {
            final int length = (widget.data['stories'] as List).length;
            final double progress =
                "${smPro.getProgress}" == 'NaN' ? 0 : smPro.getProgress;

            return AnimatedSwitcher(
                switchInCurve: Curves.easeInToLinear,
                duration: Duration(milliseconds: 500),
                child: smPro.isPaused
                    ? Container(
                        key: Key("EmptyTitle"),
                      )
                    : Container(
                        key: Key("EmptyTitle"),
                        margin:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: StoryProgressBar(
                                progress: progress, //,
                                currentTab: smPro.getCurrentTab,
                                length: length,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                smPro.setPause(true);
                                if (_videoPlayerController != null) {
                                  _videoPlayerController.pause();
                                  await openScreen(context,
                                      StoryProfileMain(data: widget.data));
                                  _videoPlayerController.play();
                                } else {
                                  await openScreen(context,
                                      StoryProfileMain(data: widget.data));
                                }
                                smPro.setPause(false);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.data['image']))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      widget.data['username'] ?? "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Follow",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  CloseButton(
                                    onPressed: () {
                                      StoryMainProvider smPro =
                                          context.read<StoryMainProvider>();
                                      smPro.timerCancelAndMakeNull();
                                      Navigator.pop(context);
                                    },
                                  )
                                  // IconButton(onPressed: () {

                                  // }, icon: Icon(Icons.more_vert))
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
          },
        ),
        Consumer(
          builder:
              (BuildContext context, StoryMainProvider smPro, Widget child) {
            var d = (widget.data['stories'] as List)[smPro.getCurrentTab];

            return AnimatedSwitcher(
                switchInCurve: Curves.easeInToLinear,
                duration: Duration(milliseconds: 500),
                child: smPro.isPaused
                    ? Container(
                        key: Key("EmptyButtonView"),
                      )
                    : Container(
                        key: Key("ButtonView"),
                        padding: EdgeInsets.only(right: 30, bottom: 30),
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularButton(
                              color: Colors.transparent,
                              textColor: Colors.black,
                              icon: Icons.visibility_outlined,
                              title: "${d['views']}",
                            ),
                            CircularButton(
                              textColor: Colors.black,
                              icon: Icons.favorite_border,
                              title: "${d['likes']}",
                            ),
                            CircularButton(
                              textColor: Colors.black,
                              icon: Icons.share,
                              title: "${d['views']}",
                            )
                          ],
                        ),
                      ));
          },
        ),
      ],
    ));
  }
}
