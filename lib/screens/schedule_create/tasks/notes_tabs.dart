import 'dart:convert';
import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/gradient_bg.dart';

class NoteTabs extends StatefulWidget {
  final double width;
  final double height;
  final family;
  NoteTabs({this.width, this.height, this.family});
  @override
  _NoteTabsState createState() => _NoteTabsState();
}

class _NoteTabsState extends State<NoteTabs>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  LoadingProgressDialog loadingIndicator = new LoadingProgressDialog();
  TabController _tabController;
  var selectedPets = "all";
  List list;
  void initState() {
    if (mounted) init();
    super.initState();
  }

  init() {
    var data = context.read<UserProvider>().getPetList;
    _tabController = TabController(length: data.length, vsync: this);
    getPetList(force: false);
    return true;
  }

  getPetList({force: false}) async {
    await context.read<UserProvider>().fetchListData(context, force: force);
    return true;
  }

  List<Color> colorList = [
    Colors.pink[200],
    Colors.yellow,
    Colors.cyan,
    Colors.lightGreenAccent[100],
    Colors.red[200],
    Colors.deepPurple[100]
  ];

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar:
              appBarWidget(context: context, name: "Notes", color: Colors.blue),
          body: Consumer(
            builder: (BuildContext context, UserProvider uPro, Widget child) {
              var petListData = uPro.getPetListData;
              return petListData == null
                  ? LoadingIndicator()
                  : petListData == false || petListData.length == 0
                      ? LoadingIndicator(
                          imageUrl: "assets/gif/sad_dog.gif",
                          message: "Data Not Found",
                          textColor: Colors.black)
                      : Column(
                          children: [
                            TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                tabs:
                                    List.generate(petListData.length, (index) {
                                  var pet = petListData[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(150),
                                            child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        pet['image']
                                                        //  + "?x=${DateTime.now()}"
                                                        ),
                                                  ),
                                                ))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            pet['name'],
                                            softWrap: true,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                            Expanded(
                                child: Container(
                              child: TabBarView(
                                controller: _tabController,
                                children:
                                    List.generate(petListData.length, (index) {
                                  List list =
                                      (petListData[index]['notes'] as List) ??
                                          [];
                                  log(list.toString());
                                  return list.isEmpty
                                      ? Container(
                                          child: Center(
                                            child: Text(
                                              "ADD Notes for Your Pet by clicking on Add notes button below",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    fontSize: 17,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  children: List.generate(
                                                    list.length,
                                                    (index) {
                                                      return Card(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Text(
                                                            list[index],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6,
                                                          ),
                                                          color: colorList[
                                                              index %
                                                                  colorList
                                                                      .length],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                }),
                              ),
                            )),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: () {
                                  var pets = context
                                      .read<UserProvider>()
                                      .getPetListData;
                                  // _showDialog(pet['']);
                                  _showDialog(pets[_tabController.index]['_id'],
                                      context);
                                },
                                child: DottedBorder(
                                  padding: EdgeInsets.all(10),
                                  radius: Radius.circular(30),
                                  color: Colors.blue,
                                  strokeWidth: 2,
                                  dashPattern: [
                                    10,
                                    6,
                                  ],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        child: Icon(Icons.add),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Add New Note",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );

              // Wrap(
              //   children: [FamilyCard()],
              // ),
            },
          )),
    );
  }

  void _showDialog(id, nt_context) {
    showModal(
      context: nt_context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: AlertDialog(
            title: Container(
              child: Stack(
                children: [
                  Text(
                    "New Note",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            // backgroundColor: Colors.blue[300],
            content: TextField(
              controller: nameController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Example: Goofy\'s Favourite Picnic Spot.',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              // decoration: InputDecoration(
              //   hintText: "Example: Goofy's Favourite Picnic Spot.",
              //   labelStyle: Theme.of(context)
              //       .textTheme
              //       .headline6
              //       .copyWith(color: Colors.blue),
              //   // border: OutlineInputBorder(),
              //   border: InputBorder.none,
              // ),
            ),
            // title: Text("Enter Title"),
            actions: [
              TextButton(
                child: Text(
                  "DISCARD",
                  style: TextStyle(color: blueClassicColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "ADD",
                  style: TextStyle(color: blueClassicColor),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  if (nameController.text != "") {
                    var postAbleData = {
                      "pet": [id],
                      "note": (nameController.text)
                    };
                    loadingIndicator.show(nt_context);
                    var res = await RestRouteApi(nt_context, ApiPaths.addNotes)
                        .post(jsonEncode(postAbleData));
                    await getPetList(force: true);
                    loadingIndicator.hide(nt_context);
                    nameController.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
