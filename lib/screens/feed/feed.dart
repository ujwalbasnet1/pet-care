import 'dart:ui';
import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/buttons/border_button.dart';

class Feed extends StatelessWidget {
  const Feed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feed",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            offset: Offset(0, 45),
            itemBuilder: (_) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Post'),
                      Image.asset(
                        "assets/images/schedule.png",
                        height: 20,
                        width: 20,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  value: 'Post'),
              PopupMenuItem<String>(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reel'),
                      Image.asset(
                        "assets/images/video.png",
                        height: 20,
                        width: 20,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  value: 'Reel'),
            ],
            child: Icon(
              Icons.add_box_outlined,
              color: Colors.white,
              size: 32,
            ),
            onSelected: (_) {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          FeedWidget(
            name: "Piyush Aggrawal",
            image: Image.asset("assets/images/dog3.png"),
          ),
          SizedBox(
            height: 16,
          ),
          FeedWidget(
            name: "Udit",
            image: Image.asset("assets/gif/rbt.gif"),
          ),
        ],
      ),
    );
  }
}

class FeedWidget extends StatelessWidget {
  final name;
  final Image image;

  const FeedWidget({Key key, @required this.name, @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black54),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://static.remove.bg/remove-bg-web/a76316286d09b12be1ebda3b400e3f44716c24d0/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg"),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "28 Nov 2021 .03.03 pm",
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Text(
                          "Follow",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    PopupMenuButton(
                      offset: Offset(0, 25),
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Share'),
                                Icon(Icons.share),
                              ],
                            ),
                            value: 'Share'),
                        PopupMenuItem<String>(
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Report'),
                                Icon(Icons.report_outlined),
                              ],
                            ),
                            value: 'Report'),
                      ],
                      child: Icon(Icons.more_vert),
                      onSelected: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Caption"),
          ),
          image,
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "23",
                  ),
                ],
              ),
              Container(
                height: 30.0,
                width: 1.0,
                color: Colors.black26,
              ),
              Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "80",
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
