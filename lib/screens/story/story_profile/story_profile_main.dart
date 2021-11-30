import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/video_image_thumnails.dart';
import 'package:pets/screens/story/explore/shorts_main.dart';
import 'package:pets/utils/app_utils.dart';

import 'components/user_stats.dart';

class StoryProfileMain extends StatefulWidget {
  final data;

  const StoryProfileMain({Key key, this.data = ""}) : super(key: key);

  @override
  _StoryProfileMainState createState() => _StoryProfileMainState();
}

class _StoryProfileMainState extends State<StoryProfileMain> {
  var data;
  @override
  void initState() {
    data = widget.data;
    print("======= StoryProfileMain =======");
    print(data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: CustomScrollView(
              slivers: [
                // Add the app bar to the CustomScrollView.
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  // Provide a standard title.
                  // title: Text(title),
                  // Allows the user to reveal the app bar if they begin scrolling
                  // back up the list of items.
                  floating: false,
                  automaticallyImplyLeading: true,
                  pinned: true,

                  flexibleSpace: UserStats(
                      userName: data['username'],
                      image: data['image'],
                      petImage: data['pet_image'],
                      petName: data['pet_name'],
                      posts: (data['stories'].length).toString()),
                  expandedHeight: 300,
                ),
                // Next, create a SliverList
                SliverGrid(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Card(
                          // padding: EdgeInsets.all(5),
                          child: VideoImageThumbnail(
                            imageVideoPath: data['stories'][index]['url'],
                            onTap: () {
                              openScreen(
                                context,
                                ShortsMain(
                                    isMaterial: true,
                                    data: {'stories': data['stories']},
                                    index: index),
                              );
                            },
                          ),
                        );

                        // ListTile(title: Text('Item #$index'));
                      },
                    ),
                    // Builds 1000 ListTiles
                    childCount: data['stories'].length,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                    // mainAxisSpacing: 10.0,
                    // crossAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ],
            ),
          ),
          // );

          //   LayoutBuilder(
          //     builder: (BuildContext context, BoxConstraints constraints) {
          //       return GradientBg(
          //         child: Container(
          //           padding: EdgeInsets.only(top: 50),
          //           child: SingleChildScrollView(
          //             child: Column(
          //               children: [UserStats()],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
        ),
      ),
    );
  }
}
