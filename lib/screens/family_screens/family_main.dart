import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/utils/app_utils.dart';
import 'components/family_card.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/gradient_bg.dart';

class FamilyMain extends StatefulWidget {
  final double width;
  final double height;
  final family;
  FamilyMain({this.width, this.height, this.family});
  @override
  _FamilyMainState createState() => _FamilyMainState();
}

class _FamilyMainState extends State<FamilyMain> {
  @override
  void initState() {
    setCurrentScreen(ScreenName.familyMain);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBarWidget(
              context: context, name: "Family Tree", color: Colors.blue),
          body: DefaultTabController(
              length: widget.family.length,
              child: Column(
                children: [
                  TabBar(
                      isScrollable: true,
                      tabs: List.generate(widget.family.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              widget.family[index]['image']
                                              //  + "?x=${DateTime.now()}"
                                              ),
                                        ),
                                      ))),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.family[index]['name'],
                                  softWrap: true,
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList()),
                  Expanded(
                      child: Container(
                    child: TabBarView(
                      children: List.generate(widget.family.length, (index) {
                        var members =
                            widget.family[index]['group']['members'] as List;
                        members
                            .sort((a, b) => a['points'].compareTo(b['points']));
                        members = members.reversed.toList();
                        _bar(points, {color = Colors.green}) {
                          return Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 50,
                            width: 5,
                            color: color,
                          );
                        }

                        return ListView(
                            padding: EdgeInsets.all(padding),
                            children: List.generate(members.length, (index) {
                              var memberInfo = members[index]['person'];
                              var points = memberInfo['totalpoints'];
                              var name = memberInfo['userInfo']['fname'];
                              var gender = memberInfo['userInfo']['gender'];

                              var last = memberInfo['userInfo']['lname'];
                              var fullName = "$name $last";
                              var eventsNum = memberInfo['eventsNum'];
                              var dailyEvents = memberInfo['dailyEvents'];
                              var fullEvents = memberInfo['fullEvents'];

                              var graph = Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _bar(
                                    eventsNum,
                                    color: Colors.green,
                                  ),
                                  _bar(
                                    dailyEvents,
                                    color: Colors.green,
                                  ),
                                  _bar(
                                    fullEvents,
                                    color: Colors.green,
                                  ),
                                ],
                              );

                              return TimelineTile(
                                isLast: index == widget.family.length,
                                isFirst: index == 0,
                                indicatorStyle: IndicatorStyle(
                                    color: Colors.blue,
                                    width: 30,
                                    height: 30,
                                    // iconStyle: IconStyle(iconData: Icons.cu),
                                    indicator: CircleAvatar(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: index == 0
                                            ? Image.asset(
                                                "assets/images/cup2.png",
                                              )
                                            : Text("${index + 1}"),
                                      ),
                                    )),
                                alignment: TimelineAlign.center,
                                endChild: index.isEven
                                    ? FamilyCard(
                                        isMale: gender == "MALE",
                                        points: points,
                                        name: fullName,
                                        graph: graph)
                                    : Container(),
                                startChild: index.isOdd
                                    ? FamilyCard(
                                        isMale: gender == "MALE",
                                        points: points,
                                        name: fullName,
                                        graph: graph)
                                    : Container(),
                              );
                            })

                            //  widget.family.map((e) ).toList(),
                            );
                      }),
                    ),
                  ))
                ],
              ))

          // Wrap(
          //   children: [FamilyCard()],
          // ),
          ),
    );
  }
}
