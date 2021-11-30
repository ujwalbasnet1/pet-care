import 'package:flutter/material.dart';
import 'package:pets/utils/app_utils.dart';

class AvatarProgressBar extends StatelessWidget {
  final dynamic points;
  final String name;
  final String avatar;
  final int length;
  final int index;

  const AvatarProgressBar(
      {Key key, this.points, this.name, this.avatar, this.length, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.deepOrange,
      Colors.indigo,
      Colors.yellow,
      Colors.amber,
      Colors.cyan,
      Colors.lime,
      Colors.teal
    ];
    progressBar() {
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Container(
            // padding: EdgeInsets.only(right: ()),
            child: Row(
              children: [
                Container(
                  width: (width * 0.75) - width * 0.1 * (index),
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colors[length][300],
                              colors[length][900],
                            ]),
                        color: Colors.green,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(50))),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              '$points',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0, left: 5),
                    child: Text(
                      capitalize(name),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ClipRRect(
        //     borderRadius: BorderRadius.circular(150),
        //     child: Container(
        //         width: 40,
        //         height: 40,
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //           // border: Border.all(width: 5),
        //           image: DecorationImage(
        //             image: avatar.startsWith("http")
        //                 ? NetworkImage(avatar)
        //                 : AssetImage(avatar),
        //           ),
        //         ))),
        Expanded(child: progressBar()),
        // Container(
        //   width: 60,
        //   alignment: Alignment.centerRight,
        //   padding: EdgeInsets.only(left: 8.0),
        //   child: Text(
        //     capitalize(name),
        //     overflow: TextOverflow.ellipsis,
        //     maxLines: 1,
        //     style: Theme.of(context).textTheme.bodyText1.copyWith(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 16,
        //         ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: index == 0
              ? Image.asset(
                  "assets/images/cup2.png",
                  width: 25,
                )
              : Container(
                  width: 25,
                ),
        )
      ],
    );
  }
}
