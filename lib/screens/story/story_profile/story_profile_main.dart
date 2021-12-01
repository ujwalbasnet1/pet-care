import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
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

class _StoryProfileMainState extends State<StoryProfileMain>
    with SingleTickerProviderStateMixin {
  var data;
  List videoList = [];
  List pictureList = [];
  @override
  void initState() {
    data = widget.data;
    data['stories'].forEach((element) {
      print("added");
      print(element);
      if (lookupMimeType(element['url']).contains("video")) {
        videoList.add(element);
      } else {
        pictureList.add(element);
      }
    });
    print("======= StoryProfileMain =======");
    print(data);
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_tabChanged);
    super.initState();
  }

  TabController _tabController;
  void _tabChanged() {
    if (_tabController.indexIsChanging) {
      print('tabChanged: ${_tabController.index}');
      //   isPaid = _tabController.index.toString();
    }
  }

  TabBar get _tabbar => TabBar(
        onTap: (val) {},
        unselectedLabelColor: Colors.grey.shade700,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2.0,
        labelColor: Theme.of(context).primaryColor,
        controller: _tabController,
        tabs: <Widget>[
          new Tab(
            icon: Center(
              child: Image.asset(
                "assets/images/grid.png",
                height: 18,
                width: 18,
              ),
            ),
          ),
          new Tab(
            icon: Center(
              child: Image.asset(
                "assets/images/video (1).png",
                height: 18,
                width: 18,
              ),
            ),
          ),
          new Tab(
            icon: Center(
              child: Image.asset(
                "assets/images/trophy.png",
                height: 18,
                width: 18,
              ),
            ),
          ),
        ],
        indicatorSize: TabBarIndicatorSize.tab,
      );
  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body:
              /*           slivers: [
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
           */ /*   SliverGrid(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Card(
                         //padding: EdgeInsets.all(5),
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
              ),*/ /*
            ], */

              NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                  backgroundColor: Colors.transparent,
                  // Provide a standard title.
                  // title: Text(title),
                  // Allows the user to reveal the app bar if they begin scrolling
                  // back up the list of items.
                  floating: false,
                  automaticallyImplyLeading: true,
                  pinned: true,

                  flexibleSpace: Container(
                    child: UserStats(
                      userName: data['username'],
                      image: data['image'],
                      petImage: data['pet_image'],
                      petName: data['pet_name'],
                      posts: (data['stories'].length).toString(),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: _tabbar.preferredSize,
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      color: Colors.white,
                      child: _tabbar,
                    ),
                  ),

                  expandedHeight: 472,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverGrid(
                      // Use a delegate to build items as they're scrolled on screen.
                      delegate: SliverChildBuilderDelegate(
                        // The builder function returns a ListTile with a title that
                        // displays the index of the current item.
                        (context, index) => LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            if (!lookupMimeType(pictureList[index]['url'])
                                .contains("video")) {
                              return Card(
                                //padding: EdgeInsets.all(5),
                                child: VideoImageThumbnail(
                                  imageVideoPath: pictureList[index]['url'],
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
                            } else
                              return Container();

                            // ListTile(title: Text('Item #$index'));
                          },
                        ),
                        // Builds 1000 ListTiles
                        childCount: pictureList.length,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 3,
                        // mainAxisSpacing: 10.0,
                        // crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                    ),
                  ],
                ),
                CustomScrollView(
                  slivers: [
                    SliverGrid(
                      // Use a delegate to build items as they're scrolled on screen.
                      delegate: SliverChildBuilderDelegate(
                        // The builder function returns a ListTile with a title that
                        // displays the index of the current item.
                        (context, index) => LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            if (lookupMimeType(videoList[index]['url'])
                                .contains("video")) {
                              return Card(
                                //padding: EdgeInsets.all(5),
                                child: VideoImageThumbnail(
                                  imageVideoPath: videoList[index]['url'],
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
                            } else
                              return Container();

                            // ListTile(title: Text('Item #$index'));
                          },
                        ),
                        // Builds 1000 ListTiles
                        childCount: videoList.length,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width / 3,
                        // mainAxisSpacing: 10.0,
                        // crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text("ViDEOS"),
                ),
              ],
            ),
            /*    slivers: [
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
              makeTabBarHeader(),
              SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: true,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return GradientBg(
                          child: Container(
                            padding: EdgeInsets.only(top: 50),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [UserStats()],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(child: Text("ViDEOS"),),
                    Container(child: Text("contacts"),),
                  ],
                ),
              )
            ],*/
          ),
        ),

        // );
      ),
    );
  }

  SliverPersistentHeader makeTabBarHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              TabBar(
                onTap: (val) {},
                unselectedLabelColor: Colors.grey.shade700,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 2.0,
                labelColor: Theme.of(context).primaryColor,
                controller: _tabController,
                tabs: <Widget>[
                  new Tab(
                      child: Center(
                    child: Icon(Icons.grid_view),
                  )),
                  new Tab(
                      child: Center(
                    child: Icon(Icons.video_library_sharp),
                  )),
                  new Tab(
                      child: Center(
                    child: Icon(Icons.contact_page),
                  )),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
