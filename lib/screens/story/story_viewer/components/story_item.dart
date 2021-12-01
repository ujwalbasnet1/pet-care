import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final bool showAdd;
  final String image;
  final String title;
  final Function() onTap;
  final double size;
  final bool fullTitle;

  const StoryItem({
    Key key,
    this.image,
    this.title,
    this.onTap,
    this.size = 120,
    this.showAdd = false,
    this.fullTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kInnerDecoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.white, width: 5),
      borderRadius: BorderRadius.circular(size),
    );

    final kGradientBoxDecoration = BoxDecoration(
      gradient: LinearGradient(colors: [Colors.black, Colors.redAccent]),
      border: Border.all(
        color: Colors.blue,
      ),
      borderRadius: BorderRadius.circular(size),
    );
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: kInnerDecoration,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: (image != null)
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return SizedBox.shrink();
                                },
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                  ),
                  height: size - 30,
                  width: size - 30,
                  decoration: kGradientBoxDecoration,
                ),
                if (showAdd)
                  Positioned(
                    bottom: 0,
                    right: -4,
                    child: CircleAvatar(
                      radius: 12,
                      child: Icon(
                        Icons.add,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            // Container(
            //   height: size - 30,
            //   width: size - 30,
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Color(0xfff3628b), Color(0xffec3470)],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //     ),
            //     borderRadius: BorderRadius.circular(size),
            //     // color: Colors.amber,
            //     // image: DecorationImage(
            //     //     image: NetworkImage(image), fit: BoxFit.fill)
            //   ),
            // ),
            Text(
              fullTitle
                  ? title
                  : title.length > 10
                      ? title.substring(0, 10)
                      : title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
