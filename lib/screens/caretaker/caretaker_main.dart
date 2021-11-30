import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/invite_bottom_sheet.dart';
import 'package:pets/screens/caretaker/components/chart.dart';
import 'package:pets/screens/caretaker/components/ranking.dart';
import 'package:pets/screens/schedule_list/tab_bar.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/widgets/loading_indicator.dart';

enum Sharing { whatsapp, facebook, other }

class CareTakerMain extends StatefulWidget {
  final int currentTab;

  const CareTakerMain({Key key, this.currentTab}) : super(key: key);
  @override
  _CareTakerMainState createState() => _CareTakerMainState();
}

class _CareTakerMainState extends State<CareTakerMain> {
  @override
  void initState() {
    getCareTakeGroup(force: false);
    setCurrentScreen(ScreenName.careTakerMain);
    // _handleContactPermission(Permission.contacts);
    super.initState();
  }

  getCareTakeGroup({force: false}) async {
    if (mounted) {
      Future.delayed(Duration.zero).then((value) async {
        // LoadingProgressDialog().show(context, message: "Refreshing");
        await context
            .read<UserProvider>()
            .getCareTakeGroup(context, force: force);
        // LoadingProgressDialog().hide(context);
      });
      return true;
    }
  }

  Widget getLable() {
    var list = ["Meal", "Walk", "Others"];
    var colorList = [
      Color(0xff19bfff),
      Color(0xffffdd80),
      Color(0xff2bdb90),
    ];
    return Column(
      children: List.generate(
        list.length,
        (index) {
          return Row(
            children: [
              Container(
                height: 10,
                width: 10,
                color: colorList[index],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${list[index]}",
                style: TextStyle(
                  fontFamily: "Proxima Nova",
                  color: Colors.white,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getText(String text, dynamic title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$text",
          style: TextStyle(
            fontFamily: "Proxima Nova",
            color: Colors.white,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "$title",
          style: TextStyle(
            fontFamily: "Proxima Nova",
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, UserProvider uPro, child) {
        var petCareTaker = uPro.getGroupData;

        return petCareTaker == null
            ? LoadingIndicator()
            : petCareTaker == false
                ? LoadingIndicator(
                    imageUrl: "assets/gif/sad_dog.gif",
                    message: "Data Not Found",
                    textColor: Colors.black)
                : TabBarGeneric(
                    selectedTab: widget.currentTab ?? 0,
                    isScrollable: true,
                    appBarTitle: "Caretaker",
                    titles: (petCareTaker as List)
                        .map<String>((e) => e['name'])
                        .toList(),
                    screens: List.generate(petCareTaker.length, (index) {
                      var groupInfo = petCareTaker[index];
                      var groupId = groupInfo['_id'];
                      var members = petCareTaker[index]['members'] as List;
                      members
                          .sort((a, b) => a['points'].compareTo(b['points']));
                      members = members.reversed.toList();
                      var maxY = 0;
                      var barDetails = members.map(
                        (e) {
                          var totalPoints = e["eventsList"]['MEAL'] +
                              e["eventsList"]['WALK'] +
                              e["eventsList"]['OTHERS'];
                          maxY = totalPoints > maxY ? totalPoints : maxY;
                          return {
                            "name": e['person']['userInfo']['fname'],
                            "points": 20.0,
                            "totalEvents": e['eventsNum'],
                            "eventsList": e['eventsList'],
                            "topTask": "MEAL"
                          };
                        },
                      ).toList();
                      var userRankingList = members.map((e) {
                        final grossing =
                            e["eventsList"]['WALK'] > e["eventsList"]['MEAL']
                                ? 'WALK'
                                : 'MEAL';
                        return Ranking(
                          onTap: () async {
                            if (context
                                .read<UserProvider>()
                                .getUserInfo
                                .isMinor) {
                              showToast(
                                  'You are Minor. A Minor cannot perform this Task.',
                                  context);
                              return;
                            }
                            var body = {
                              "caretakerId": e['person']['_id'],
                              "groupId": groupId
                            };
                            LoadingProgressDialog().show(context);
                            var res = await RestRouteApi(
                              context,
                              ApiPaths.removeCareTaker,
                            ).post(jsonEncode(body));
                            await context
                                .read<UserProvider>()
                                .onScheduleChange(context);
                            LoadingProgressDialog().hide(context);
                            if (res != null) if (res.status
                                    .toString()
                                    .toLowerCase() ==
                                "success") {
                              await context
                                  .read<UserProvider>()
                                  .getCareTakeGroup(context);
                              members.removeAt(index);
                              setState(
                                  () {}); //TODO remove setState but exists initState
                            }
                          },
                          color: Color(0xff7B85F9),
                          name: e['person']['userInfo']['fname'],
                          imageUrl: e['person']['userInfo']['avatar'],
                          taskDetail:
                              "Top Task - $grossing \nWalk : ${e["eventsList"]['WALK']}, Meal : ${e["eventsList"]['MEAL']}",
                          rank: members.indexOf(e) + 1,
                        );
                      }).toList();

                      return GradientBg(
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  height: 250,
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: size.width / 3.5,
                                        decoration: BoxDecoration(
                                            color: Color(0xff261E7A),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              getText("Group Event",
                                                  groupInfo['totalEvents']),
                                              getText("Group Points",
                                                  groupInfo['totalPoints']),
                                              getText("Total Points",
                                                  groupInfo['totalPoints']),
                                              getLable(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: BarChartSample5(
                                              data: barDetails, maxY: maxY),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]..addAll(
                                  userRankingList,
                                ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: IconButton(
                            icon: Icon(Icons.person_add, color: Colors.white),
                            onPressed: () {
                              Map groupDetails =
                                  petCareTaker[uPro.getCurrentGenericTab.index];

                              if (!groupDetails['isInviteAccess']) {
                                showToast(
                                    "You don't have Invite Access", context);
                                return;
                              }
                              new InviteBottomSheet(
                                context,
                                groupDetails,
                                uPro.getUserInfo.userId,
                              ).showBottomSheet(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}
