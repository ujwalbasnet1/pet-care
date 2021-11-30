import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/custom_image.dart';
import 'package:pets/screens/story/explore/shorts_main.dart';
import 'package:pets/screens/story/gif_stories.dart';
import 'package:pets/utils/app_utils.dart';

class RectStory extends StatelessWidget {
  const RectStory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _section({title = "Trending Shorts"}) {
      return Container(
        padding: EdgeInsets.only(top: 18, bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: greyColor,
                fontSize: 18,
              ),
        ),
      );
    }

    _horizonalList() {
      gifStories.shuffle();
      return List.generate(gifStories.length, (index) {
        var item = gifStories[index];
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    openScreen(
                      context,
                      ShortsMain(
                          isMaterial: true,
                          data: {'stories': gifStories},
                          index: index),
                    );
                  },
                  child: Container(
                      color: Colors.grey[100],
                      width: 120,
                      height: 150,
                      child: CustomImage(url: item['url'])),
                )
              ],
            ));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(),
        Container(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _horizonalList(),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
