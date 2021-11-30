// import 'package:flutter/material.dart';
// import 'package:flutter_app/theme/theme.dart';

// class ExploreTile extends StatefulWidget {
//   final String exploreVideo;
//   final String exploreVideoInfo;
//   final double height;
//   final double width;

//   ExploreTile(
//       {this.exploreVideo, this.exploreVideoInfo, this.height, this.width});

//   @override
//   _ExploreTileState createState() => _ExploreTileState();
// }

// class _ExploreTileState extends State<ExploreTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomLeft,
//       children: [
//         VideoPlayerItem()
//         Container(
//           color: Colors.black.withAlpha(150),
//           padding: const EdgeInsets.fromLTRB(23, 23, 25, 60),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Text(
//                         widget.exploreVideoInfo,
//                         style: neutraHeader(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.white),
//                       ),
//                     ),
//                     RaisedButton(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 5.0, horizontal: 9.0),
//                       onPressed: () {},
//                       child: Text(
//                         "MORE INFO",
//                         style: TextStyle(
//                           color: Colors.black,
//                           letterSpacing: 1.7,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   Icon(
//                     Icons.favorite,
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: Icon(
//                       Icons.ios_share,
//                       color: Colors.white,
//                       size: 35,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),

//         // Padding(
//         //   padding: const EdgeInsets.only(bottom:600.0),
//         //   child: AppBar(
//         //     title: Text("Hello"),
//         //     backgroundColor: config.transparentColor,
//         //     elevation: 0,
//         //   ),
//         // )
//       ],
//     );
//   }
// }

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;
//   final String thumbnail;

//   VideoPlayerItem({Key key, @required this.size, this.videoUrl, this.thumbnail})
//       : super(key: key);

//   final Size size;

//   @override
//   _VideoPlayerItemState createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   VideoPlayerController _videoController;
//   bool isShowPlaying = false;

//   @override
//   void initState() {
//     super.initState();

//     _videoController = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((value) {
//         _videoController.play();
//         setState(() {
//           isShowPlaying = false;
//         });
//       });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _videoController.dispose();
//   }

//   Widget isPlaying() {
//     return _videoController.value.isPlaying && !isShowPlaying
//         ? Container()
//         : Icon(Icons.play_arrow, size: 80, color: config.primaryTextColor);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final width = getWidth(constraints, context);
//         final height = getHeight(constraints, context);
//         return Stack(
//           children: [
//             _videoController.value.isPlaying
//                 ? InkWell(
//                     onTap: () {
//                       setState(() {
//                         _videoController.value.isPlaying
//                             ? _videoController.pause()
//                             : _videoController.play();
//                       });
//                     },
//                     child: RotatedBox(
//                       quarterTurns: -1,
//                       child: Container(
//                           height: widget.size.height,
//                           width: widget.size.width,
//                           child: Stack(
//                             children: <Widget>[
//                               VideoPlayer(_videoController),
//                               Center(
//                                 child: Container(
//                                   decoration: BoxDecoration(),
//                                   child: isPlaying(),
//                                 ),
//                               ),
//                               Container(
//                                 height: widget.size.height,
//                                 width: widget.size.width,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 15, top: 20, bottom: 10),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ),
//                   )
//                 : RotatedBox(
//                     quarterTurns: -1,
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           _videoController.value.isPlaying
//                               ? _videoController.pause()
//                               : _videoController.play();
//                         });
//                       },
//                       child: Stack(children: [
//                         Image(
//                           image: AssetImage(widget.thumbnail),
//                         ),
//                         ListView.builder(
//                             itemCount: exploreList.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return Container(
//                                 color: Colors.red,
//                                 child: ExploreTile(
//                                   width: width * 100,
//                                   exploreVideo: exploreList[index].exploreVideo,
//                                   exploreVideoInfo:
//                                       exploreList[index].exploreVideoInfo,
//                                 ),
//                               );
//                             }),
//                       ]),
//                     ),
//                   ),
//           ],
//         );
//       },
//     );
//   }
// }
