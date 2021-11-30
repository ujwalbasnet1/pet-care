import 'package:flutter/material.dart';

class FamilyCard extends StatelessWidget {
  final double size;
  final points;
  final name;
  final graph;
  final bool isMale;

  const FamilyCard(
      {Key key,
      this.size = 150,
      this.points,
      this.name,
      this.graph,
      this.isMale = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(
                0.8, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              const Color(0x5fFFF1DB),
              const Color(0x9fFFC59B)
            ], // red to yellow
            // tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
          borderRadius: BorderRadius.circular(size * 0.2),
          border: Border.all(
            color: Color(0xffFFC59B),
            width: 2,
          )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text("$name"),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment,
                      children: [
                        Spacer(),
                        Container(
                            height: size * 0.7,
                            child: Image.asset(isMale
                                ? "assets/images/lego_male.png"
                                : "assets/images/lego_female.png"))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Points"),
                        Text("$points"),
                        Spacer(),
                        graph
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
