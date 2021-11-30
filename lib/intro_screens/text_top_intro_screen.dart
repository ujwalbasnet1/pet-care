import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';

class TextTopIntroScreen extends StatelessWidget {
  const TextTopIntroScreen({
    Key key,
    this.width,
    this.height,
    @required this.title,
    @required this.paragraph,
    @required this.imageUrl,
  }) : super(key: key);
  final double width;
  final double height;
  final String title;
  final String paragraph;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            imageUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                width * 8,
                height * 15,
                width * 8,
                0,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "$title",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "$paragraph",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: greyColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
