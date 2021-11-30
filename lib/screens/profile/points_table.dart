import 'package:flutter/material.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/theming/common_size.dart';
import 'package:pets/utils/app_utils.dart';

class PointsTable extends StatelessWidget {
  final points = {
    "MEAL": 5,
    "WALK": 10,
    "MEDICINE": 20,
    "SUPPLEMENTS": 10,
    "WATER": 5,
    "PLAY": 20,
    "VETERINARY": 30,
    "GROOMING": 20,
    "CLEANING": 20,
    "SHOPPING": 30,
    "TRAINING": 30,
    "MEASUREMENTS": 20,
    "OTHERS": 20
  };
  final images = {
    "MEAL": "meal",
    "WALK": "walk",
    "MEDICINE": "medicine",
    "SUPPLEMENTS": "supplement",
    "WATER": "water",
    "PLAY": "playtime",
    "VETERINARY": "veterinary",
    "GROOMING": "grooming",
    "CLEANING": "cleaning",
    "SHOPPING": "shopping",
    "TRAINING": 'training',
    "MEASUREMENTS": "measurements",
    "OTHERS": "others",
  };
  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Point's Table"),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(padding),
          child: ListView(
              children: points.entries
                  .map((e) => Column(
                        children: [
                          Row(children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(
                                getAssetImage(
                                  images[e.key],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              e.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                            ),
                            Spacer(),
                            Text(
                              e.value.toString() + " Points",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                            )
                          ]),
                          Divider()
                        ],
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
