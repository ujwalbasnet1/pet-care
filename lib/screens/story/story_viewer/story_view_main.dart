import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:provider/provider.dart';
import 'components/cube_transitions.dart';
import 'provider/story_main_provider.dart';
import 'screens/story_view.dart';

class StoryViewMain extends StatefulWidget {
  final data;
  final int initialPage;
  const StoryViewMain({Key key, this.data, this.initialPage}) : super(key: key);

  @override
  _StoryViewMainState createState() => _StoryViewMainState();
}

class _StoryViewMainState extends State<StoryViewMain> {
  PageController _pageController = new PageController();
  @override
  void initState() {
    initStoryMain();
    super.initState();
  }

  initStoryMain() {
    StoryMainProvider smPro = context.read<StoryMainProvider>();
    smPro.initStoryMain(widget.data.length, _pageController, context);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: CubePageView.builder(
        onPageChanged: (int) {
          // StoryMainProvider smPro = context.read<StoryMainProvider>();
          // smPro.resetTab();
        },
        controller: _pageController,
        itemCount: widget.data.length,
        initialIndex: widget.initialPage,
        itemBuilder: (BuildContext context, int index, pageNotifier) {
          StoryMainProvider smPro = context.read<StoryMainProvider>();
          final length = widget.data.length;
          var jsonItem = widget.data[index];
          return CubeWidget(
              index: index,
              pageNotifier: pageNotifier,
              child: StoryViewer(
                  // onNext: () => smPro.onNextUserStory(index),
                  //   onPrevious: () => smPro.onPreviousUserStory(index)

                  onNext: () {
                    print("object");
                    print(index);
                    print(length - 1);
                    // if (index < length - 1) {
                    //   print("Inside");
                    //   smPro.onNextUserStory(index);
                    //   // _pageController.nextPage(
                    //   //     duration: Duration(milliseconds: 100),
                    //   //     curve: Curves.easeIn);
                    // }
                  },
                  onPrevious: () {
                    print("here");
                    if (index > 0) {
                      // smPro.onPreviousUserStory(index);
                      // _pageController.previousPage(
                      //     duration: Duration(milliseconds: 100),
                      //     curve: Curves.easeIn);
                    }
                  },
                  data: jsonItem));
        },
      ),
    ));
  }
}

// class TestStory extends StatefulWidget {
//   const TestStory({Key key}) : super(key: key);

//   @override
//   _TestStoryState createState() => _TestStoryState();
// }

// class _TestStoryState extends State<TestStory> {
//   final StoryController controller = StoryController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Scaffold(
//       appBar: AppBar(
//         title: Text("Delicious Ghanaian Meals"),
//       ),
//       body: Container(
//         margin: EdgeInsets.all(
//           8,
//         ),
//         child: ListView(
//           children: <Widget>[
//             Container(
//               height: 300,
//               child: StoryView(
//                 controller: controller,
//                 storyItems: [
//                   StoryItem.text(
//                     title:
//                         "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
//                     backgroundColor: Colors.orange,
//                     roundedTop: true,
//                   ),
//                   // StoryItem.inlineImage(
//                   //   NetworkImage(
//                   //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
//                   //   caption: Text(
//                   //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
//                   //     style: TextStyle(
//                   //       color: Colors.white,
//                   //       backgroundColor: Colors.black54,
//                   //       fontSize: 17,
//                   //     ),
//                   //   ),
//                   // ),
//                   StoryItem.inlineImage(
//                     url:
//                         "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
//                     controller: controller,
//                     caption: Text(
//                       "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
//                       style: TextStyle(
//                         color: Colors.white,
//                         backgroundColor: Colors.black54,
//                         fontSize: 17,
//                       ),
//                     ),
//                   ),
//                   StoryItem.inlineImage(
//                     url:
//                         "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
//                     controller: controller,
//                     caption: Text(
//                       "Hektas, sektas and skatad",
//                       style: TextStyle(
//                         color: Colors.white,
//                         backgroundColor: Colors.black54,
//                         fontSize: 17,
//                       ),
//                     ),
//                   )
//                 ],
//                 onStoryShow: (s) {
//                   print("Showing a story");
//                 },
//                 onComplete: () {
//                   print("Completed a cycle");
//                 },
//                 progressPosition: ProgressPosition.bottom,
//                 repeat: false,
//                 inline: true,
//               ),
//             ),
//             Material(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => MoreStories()));
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.black54,
//                       borderRadius:
//                           BorderRadius.vertical(bottom: Radius.circular(8))),
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white,
//                       ),
//                       SizedBox(
//                         width: 16,
//                       ),
//                       Text(
//                         "View more stories",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// class MoreStories extends StatefulWidget {
//   @override
//   _MoreStoriesState createState() => _MoreStoriesState();
// }

// class _MoreStoriesState extends State<MoreStories> {
//   final storyController = StoryController();

//   @override
//   void dispose() {
//     storyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("More"),
//       ),
//       body: StoryView(
//         storyItems: [
//           StoryItem.text(
//             title: "I guess you'd love to see more of our food. That's great.",
//             backgroundColor: Colors.blue,
//           ),
//           StoryItem.text(
//             title: "Nice!\n\nTap to continue.",
//             backgroundColor: Colors.red,
//             textStyle: TextStyle(
//               fontFamily: 'Dancing',
//               fontSize: 40,
//             ),
//           ),
//           StoryItem.pageImage(
//             url:
//                 "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
//             caption: "Still sampling",
//             controller: storyController,
//           ),
//           StoryItem.pageImage(
//               url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
//               caption: "Working with gifs",
//               controller: storyController),
//           StoryItem.pageImage(
//             url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//             caption: "Hello, from the other side",
//             controller: storyController,
//           ),
//           StoryItem.pageImage(
//             url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//             caption: "Hello, from the other side2",
//             controller: storyController,
//           ),
//         ],
//         onStoryShow: (s) {
//           print("Showing a story");
//         },
//         onComplete: () {
//           print("Completed a cycle");
//         },
//         progressPosition: ProgressPosition.top,
//         repeat: false,
//         controller: storyController,
//       ),
//     );
//   }
// }
