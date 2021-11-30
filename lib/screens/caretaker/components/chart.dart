import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample5 extends StatefulWidget {
  final data;
  final maxY;

  const BarChartSample5({Key key, this.data, this.maxY}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 30;
  List<Map<String, dynamic>> data = [
    {
      "name": "Piyush",
      "points": 20.0,
      "totalEvents": 50.0,
      "eventsList": {"MEAL": 30.0, "WALK": 15.0, "OTHERS": 5.0},
      "topTask": "MEAL"
    },
    {
      "name": "Gaurav",
      "points": 40.0,
      "totalEvents": 60.0,
      "eventsList": {"MEAL": 20.0, "WALK": 20.0, "OTHERS": 20.0},
      "topTask": "WALK"
    },
    {
      "name": "Raghu",
      "points": 30.0,
      "totalEvents": 30.0,
      "eventsList": {"MEAL": 10.0, "WALK": 15.0, "OTHERS": 5.0},
      "topTask": "OTHERS"
    }
  ];

  @override
  void initState() {
    update();
    super.initState();
  }

  update() {
    data = widget.data ?? data;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: const Color(0xff020227),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: double.parse("${widget.maxY + 10}"),
              groupsSpace: 12,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: SideTitles(
                  showTitles: false,
                  // getTextStyles: (value) =>
                  //     const TextStyle(color: Colors.white, fontSize: 10),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thu';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                      default:
                        return '';
                    }
                  },
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  // getTextStyles: (value) =>
                  //     const TextStyle(color: Colors.white, fontSize: 10),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    String out = "";
                    var val = value.toInt();
                    for (int i = 0; i <= val; i++) {
                      out = (data[i]["name"] ?? 'NA').length > 8
                          ? data[i]["name"].substring(0, 8)
                          : (data[i]["name"] ?? 'NA');
                    }
                    return out;
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  // getTextStyles: (value) =>
                  //     const TextStyle(color: Colors.white, fontSize: 10),
                  rotateAngle: 0,
                  getTitles: (double value) {
                    if (value == 0) {
                      return '0';
                    }
                    return '${(value).toInt()}';
                  },
                  interval: 10,
                  margin: 8,
                  reservedSize: 30,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 5 == 0,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return FlLine(
                        color: const Color(0xff363753), strokeWidth: 3);
                  }
                  return FlLine(
                    color: const Color(0xff2a2747),
                    strokeWidth: 0.8,
                  );
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: List.generate(
                data.length,
                (index) {
                  List<String> tempList = ["MEAL", "WALK", "OTHERS"];
                  List colorList = [
                    Color(0xff19bfff),
                    Color(0xffffdd80),
                    Color(0xff2bdb90),
                  ];
                  var meal = double.parse(
                      data[index]["eventsList"]['MEAL'].toString());
                  var walk = double.parse(
                      data[index]["eventsList"]['WALK'].toString());
                  var others = double.parse(
                      data[index]["eventsList"]['OTHERS'].toString());

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        y: double.parse(
                            "${data[index]["eventsList"]['MEAL'] + data[index]["eventsList"]['WALK'] + data[index]["eventsList"]['OTHERS']}"),
                        width: barWidth,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        rodStackItems: [
                          BarChartRodStackItem(0, meal, Color(0xff19bfff)),
                          BarChartRodStackItem(
                              meal, meal + walk, Color(0xffffdd80)),
                          BarChartRodStackItem(meal + walk,
                              meal + walk + others, Color(0xff2bdb90)),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
