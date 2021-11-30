import "package:flutter/material.dart";
import 'package:flutter_offline/flutter_offline.dart';
import 'package:pets/common/errorMessageDialog.dart';

class GradientBg extends StatelessWidget {
  final Widget child;
  const GradientBg({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Material(
            child: new Stack(
              fit: StackFit.expand,
              children: [
                !connected
                    ? AlertWithBackdrop(
                        message:
                            "Please Enable mobile data or Wifi and try again",
                      )
                    : child,
              ],
            ),
          );
        },
        child: ImageBackground(child: child),
      ),
    );
  }
}

class ImageBackground extends StatelessWidget {
  const ImageBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(1),
            BlendMode.dstATop,
          ),
          image: AssetImage(
            "assets/images/background_image.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

// import 'package:connectivity_wall/connectivity_wall.dart';
// import 'package:flutter/material.dart';
// TODO commenting this gradient file for good use later.. else will remove before production
// class GradientBg extends StatelessWidget {
//   final Widget child;

//   const GradientBg({Key key, this.child}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ConnectivityWall(
//       pingInterval: 120,
//       responseCode: 200,
//       onPingUrl: Uri.parse(
//         "https://pub.dev/",
//       ), //TODO; ADD ngrok.io tunnel ya server website here
//       /// Connectedwall
//       onConnectedWall: ImageBackground(child: child),

//       /// User changed from wifi to data or else
//       onConnectivityChanged: (result) {
//         // ConnectivityResult.mobile
//         // ConnectivityResult.wifi
//         // ConnectivityResult.none
//        
//       },

//       /// Disconnected callback
//       onDisconnected: () {
//         
//       },

//       /// Disconnected Widget wall
//       onDisconnectedWall: Material(
//           child: Center(
//         child: Text(
//           "Not connected to internet", //TODO; future builder which changes from "Loading.." to "not connected to internet" in 120seconds
//         ),
//       )),
//     );
//   }
// }
