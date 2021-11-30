// import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';

// class GradientBg extends StatelessWidget {
//   final Widget child;

//   const GradientBg({Key key, this.child}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         OfflineBuilder(
//           connectivityBuilder: (
//             BuildContext context,
//             ConnectivityResult connectivity,
//             Widget child,
//           ) {
//             final bool connected = connectivity != ConnectivityResult.wifi;
//             return new Stack(
//               fit: StackFit.expand,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     image: DecorationImage(
//                       colorFilter: ColorFilter.mode(
//                         Colors.black.withOpacity(1),
//                         BlendMode.dstATop,
//                       ),
//                       image: AssetImage(
//                         "assets/images/background_image.jpg",
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: child,
//                 ),
//                 Positioned(
//                   height: 24,
//                   top: MediaQuery.of(context).size.height * 0.5 - 24,
//                   left: 0.0,
//                   right: 0.0,
//                   child: Material(
//                     child: Container(
//                       color: connected ? Colors.transparent : Color(0xFFEE4400),
//                       child: Center(
//                         child:
//                             Text("${connected ? '' : "Oh no you're OFFLINE"}"),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//           child: child,
//         ),
//       ],
//     );
//   }
// }
