// import 'package:flutter/material.dart';
// import 'package:pets/common/api_progress_indicator.dart';
// import 'package:pets/common/custom_image.dart';
// import 'package:pets/utils/app_utils.dart';
// import 'package:video_player/video_player.dart';
// import 'package:share/share.dart';

// class ExploreVideoTile extends StatefulWidget {
//   final String exploreVideo;
//   final String exploreVideoInfo;
//   final double height;
//   final double width;

//   final Function() next;

//   const ExploreVideoTile(
//       {Key key,
//       this.exploreVideo,
//       this.exploreVideoInfo,
//       this.height,
//       this.width,
//       this.next})
//       : super(key: key);
//   @override
//   _ExploreVideoTileState createState() => _ExploreVideoTileState();
// }

// class _ExploreVideoTileState extends State<ExploreVideoTile> {
//   VideoPlayerController _videoController;
//   bool isLoaded = false;
//   bool hide = false;
//   bool hasVideo = false;
//   @override
//   void initState() {
//     if (widget.data.videoUrl != null) {
//       _videoController = VideoPlayerController.network(widget.data.videoUrl)
//         ..initialize().then((value) {
//           _videoController.play();
//           setState(() {
//             isLoaded = true;
//           });
//         });
//       _videoController.addListener(() {
//         if (_videoController.value.duration != null) {
//           if (!_videoController.value.isPlaying &&

//               (_videoController.value.duration ==
//                   _videoController.value.position)) {
//             setState(() {
//               widget.next();
//             });
//           }
//         }
//       });
//     } else {
//       setState(() {});
//       hide = true;
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (_videoController != null) {
//       _videoController.removeListener(() {});
//       _videoController.dispose();
//       _videoController = null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final double height = getHeight(constraints, context);
//         var isPortrait =
//             MediaQuery.of(context).orientation == Orientation.portrait;
//         var children = [
//           Icon(
//             Icons.favorite,
//             color: Colors.white,
//             size: 35,
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: isPortrait ? 20.0 : 0),
//             child: InkWell(
//               onTap: () async {
//                 await Share.share(widget.data.posterurl);
//               },
//               child: Icon(
//                 Icons.ios_share,
//                 color: Colors.white,
//                 size: 35,
//               ),
//             ),
//           )
//         ];

//         var descriptions = [
//           Flexible(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 8.0),
//               child: Text(
//                 widget.data.title,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 4,
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white),
//               ),
//             ),
//           ),
//           Flexible(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 8.0),
//               child: Text(
//                 widget.data.storyline,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 4,
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white),
//               ),
//             ),
//           ),
//           RaisedButton(
//             padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
//             onPressed: () {
//               showToast("More Info", context);
//             },
//             child: Text(
//               "MORE INFO",
//               style: TextStyle(
//                 color: Colors.black,
//                 letterSpacing: 1.7,
//               ),
//             ),
//           ),
//         ];

//         _detailsAndButton() {
//           return Container(
//             height: height * 30,
//             color: Colors.black.withAlpha(150),
//             padding: EdgeInsets.fromLTRB(23, 23, 25, isPortrait ? 60 : 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: isPortrait
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: descriptions,
//                         )
//                       : Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: descriptions,
//                         ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: isPortrait
//                       ? Column(
//                           children: children,
//                         )
//                       : Container(
//                           width: 120,
//                           alignment: Alignment.topCenter,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: children,
//                           ),
//                         ),
//                 )
//               ],
//             ),
//           );
//         }

//         _getVideoPlayer() {
//           return InkWell(
//               onTap: () {
//                 if (_videoController.value.isPlaying) {
//                   _videoController.pause();
//                 } else {
//                   _videoController.play();
//                 }
//               },
//               child: VideoPlayer(_videoController));
//         }

//         _getLoading() {
//           return Stack(
//             children: [
//               Center(
//                 child: Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     child: CustomImage(url: widget.data.posterurl ?? "")

//                     /*Image.network(
//                     widget.data.posterurl ?? ,
//                     fit: BoxFit.fill,
//                   ),*/
//                     ),
//               ),
//               hide ? Container() : ApiProgressIndicator(),
//             ],
//           );
//         }

//         return Stack(
//           alignment: Alignment.bottomLeft,
//           children: [
//             widget.data.videoUrl != null
//                 ? isLoaded || _videoController.value.isPlaying
//                     ? _getVideoPlayer()
//                     : _getLoading()
//                 : _getLoading(),
//             // _detailsAndButton()
//           ],
//         );
//       },
//     );
//   }
// }
