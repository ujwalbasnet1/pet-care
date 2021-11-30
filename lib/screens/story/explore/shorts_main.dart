import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/screens/story/components/button_view.dart';
import 'package:pets/screens/story/story_profile/story_profile_main.dart';
import 'package:pets/screens/story/story_viewer/components/circular_button.dart';
import 'package:pets/screens/story/story_viewer/provider/story_main_provider.dart';
import 'package:pets/screens/story/story_viewer/screens/image_view_screen.dart';
import 'package:pets/screens/story/story_viewer/screens/video_view_screen.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ShortsMain extends StatefulWidget {
  final Map<String, Object> data;
  final int index;
  final Function() onNext;
  final Function() onPrevious;
  final bool isMaterial;
  final int petsOfTheWeekIndex;
  const ShortsMain({
    Key key,
    this.data,
    this.onNext,
    this.onPrevious,
    this.index = 0,
    this.isMaterial = false,
    this.petsOfTheWeekIndex,
  }) : super(key: key);

  @override
  _ShortsMainState createState() => _ShortsMainState();
}

class _ShortsMainState extends State<ShortsMain> {
  PageController _pageController;
  VideoPlayerController _videoPlayerController;
  StoryMainProvider smProInit;
  @override
  void initState() {
    _pageController = new PageController(initialPage: widget.index);
    smProInit = Provider.of<StoryMainProvider>(context, listen: false);
    initProvider();
    super.initState();
  }

  initProvider() {
    int length = (widget.data['stories'] as List).length;
    StoryMainProvider smPro = context.read<StoryMainProvider>();
    smPro.initStoryView(length, _pageController);
  }

  @override
  void dispose() {
    smProInit.resetTab();
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
    Widget awardView({child, int index}) {
      return Stack(
        children: [
          child,
          AnimatedContainer(
            margin: EdgeInsets.only(top: 50),
            duration: Duration(seconds: 2),
            width: index == widget.petsOfTheWeekIndex ? 150 : 0,
            height: index == widget.petsOfTheWeekIndex ? 150 : 0,
            child: Image.asset("assets/images/pet_of_the_week_award.png"),
          )
        ],
      );
    }

    Widget body() {
      return Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: (widget.data['stories'] as List).length,
            itemBuilder: (BuildContext context, int index) {
              final storiesList = (widget.data['stories'] as List);
              final url = storiesList[index]['url'];
              final type = lookupMimeType(url);
              final length = storiesList.length;
              StoryMainProvider smPro = context.read<StoryMainProvider>();

              if (type.contains('video')) {
                return awardView(
                    index: index,
                    child: Center(
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
                    )));
              }
              _videoPlayerController = null;
              return awardView(
                  index: index,
                  child: Center(
                      child: ImageView(
                    fit: BoxFit.cover,
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
                  )));
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topRight,
            child: widget.isMaterial
                ? CloseButton(
                    color: Colors.blue,
                    onPressed: () {
                      StoryMainProvider smPro =
                          context.read<StoryMainProvider>();
                      smPro.timerCancelAndMakeNull();
                      Navigator.pop(context);
                    },
                  )
                : Container(),
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
                      : ButttonView(
                          key: Key("ButtonView"),
                          views: "${d['views']}",
                          likes: "${d['likes']}",
                          shares: "${d['views']}",
                        ));
            },
          ),
        ],
      );
    }

    return widget.isMaterial
        ? Scaffold(
            body: GradientBg(child: body()),
          )
        : Container(
            child: body(),
          );
  }
}
