import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/provider/main_provider.dart';
import 'package:pets/screens/contacts/contacts_screen.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';

class TabBarGeneric extends StatefulWidget {
  final List<String> titles;
  final List<Widget> screens;
  final String appBarTitle;
  final List<Widget> actions;
  final bool centerTitle;
  final bool isScrollable;
  final int selectedTab;
  TabBarGeneric({
    this.titles,
    this.screens,
    this.appBarTitle,
    this.actions,
    this.centerTitle,
    this.isScrollable,
    this.selectedTab = 0,
  });

  @override
  _TabBarGenericState createState() => _TabBarGenericState();
}

class _TabBarGenericState extends State<TabBarGeneric>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> tabList = [];
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  void init() {
    _tabController = TabController(
        initialIndex: widget.selectedTab,
        length: widget.titles.length,
        vsync: this);
    _tabController.addListener(
        context.read<UserProvider>().currentSelectedTab(_tabController));
    for (int i = 0; i < widget.titles.length; i++) {
      tabList.add(
        Tab(
          text: "${widget.titles[i]}",
        ),
      );
    }
  }

  Future<void> _handleContactPermission(Permission permission) async {
    final status = await permission.request();
  }

  Widget _socials(String imageUrl) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        // var whatsappUrl = "whatsapp://send?";
        // await canLaunch(whatsappUrl)
        //     ? launch(whatsappUrl)
        //     : launch(
        //         "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_US&gl=US");
        // : print(
        //     "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
        // Share.share(
        //   "Hi there, my name is Gaurav. Please add your pet",
        // );
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16,
              ),
          isScrollable: widget.isScrollable ?? false,
          tabs: tabList,
        ),
        title: Text(widget.appBarTitle ?? "Tabs Demo"),
        actions: widget.actions,
        centerTitle: widget.centerTitle ?? false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.screens,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}

class ScheduledTimeScreen extends StatefulWidget {
  //  String userId;
  // ScheduledTimeScreen({this.userId});
  @override
  _ScheduledTimeScreenState createState() => _ScheduledTimeScreenState();
}

class _ScheduledTimeScreenState extends State<ScheduledTimeScreen> {
  var selectedPets = "all";
  void initState() {
    if (mounted) getTaskList("all");
    super.initState();
  }

  getTaskList(id, {force: false}) async {
    selectedPets = id;
    await context
        .read<UserProvider>()
        .fetchTask(context, selectedPets, force: force);
    return true;
  }

  String getTimeString(int millisecondsSinceEpoch) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final value = DateTime.now().difference(dateTime).abs();
    String stringTime = value.toString();
    String dueInTime = stringTime.replaceRange(4, 14, "");

    return dueInTime;
  }

  var icons = {
    "meal": "assets/images/updog2.png",
    "walk": "assets/images/updog1.png",
    "custom": "assets/images/updog1.png",
    "other": "assets/images/updog1.png",
  };

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var _decoration = InputDecoration(
        contentPadding: EdgeInsets.only(top: 10, left: 10, right: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)));
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Center(
                child: GestureDetector(
              onTap: () async {
                LoadingProgressDialog loadingProgressDialog =
                    new LoadingProgressDialog();
                loadingProgressDialog.show(context);
                await getTaskList(selectedPets, force: true);
                loadingProgressDialog.hide(context);
              },
              child: Icon(
                Icons.refresh_rounded,
                color: Colors.black,
                size: 30,
              ),
            )),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Schedule",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 21),
        ),
      ),
      body: TabBarGeneric(
        titles: ["ALL", "Cheeta", "Cheems"],
      ),
      // body: Consumer(
      //   builder: (context, UserProvider uPro, child) {
      //     var petList = [];
      //     petList.add({"name": "All", "_id": "all"});
      //     petList.addAll(uPro.getPetList);
      //     return Column(children: [
      //       petList == null
      //           ? Container()
      //           : Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   vertical: 8.0, horizontal: 20),
      //               child: FormBuilderDropdown(
      //                 initialValue: petList[0]['_id'],
      //                 decoration: _decoration.copyWith(hintText: "Select"),
      //                 items: (petList ?? []).map<DropdownMenuItem>((e) {
      //                   return DropdownMenuItem(
      //                     child: Text(e['name']),
      //                     value: e['_id'].toString(),
      //                   );
      //                 }).toList(),
      //                 onChanged: (value) {
      //                   getTaskList(value, force: true);
      //                 },
      //                 name: "second",
      //               ),
      //             ),
      //       Expanded(
      //         child: uPro.getTaskList == null
      //             ? LoadingIndicator()
      //             : uPro.getTaskList == false || uPro.getTaskList.length == 0
      //                 ? LoadingIndicator(
      //                     imageUrl: "assets/gif/sad_dog.gif",
      //                     message: "Data Not Found",
      //                     textColor: Colors.black)
      //                 : RefreshIndicator(
      //                     onRefresh: () =>
      //                         getTaskList(selectedPets, force: true),
      //                     child: ListView.builder(
      //                         padding:
      //                             EdgeInsets.symmetric(horizontal: padding),
      //                         itemCount: uPro.getTaskList.length,
      //                         itemBuilder: (BuildContext context, int index1) {
      //                           var el = uPro.getTaskList[index1];

      //                           return InkWell(
      //                             onTap: () async {
      //                               if (context
      //                                   .read<UserProvider>()
      //                                   .getUserInfo
      //                                   .isMinor) {
      //                                 showToast(
      //                                     "Minor Cannot Edit a Pet", context);
      //                                 return;
      //                               } else {
      //                                 openScreen(
      //                                     context,
      //                                     OtherActivity(
      //                                         petId: selectedPets, data: el));
      //                               }
      //                             },
      //                             child: ScheduleCard(
      //                               petImage: icons[
      //                                   (el['type']).toString().toLowerCase()],
      //                               noofFeeds: 1,
      //                               timediff: getTimeFromMinutes(
      //                                   el['taskMinuteNumber'] ??
      //                                       ((int.parse(el['taskDate']) / 1000)
      //                                               .round())
      //                                           .toString()),
      //                               name: el['name'],
      //                               category: el['category'],
      //                               type: el['type'],
      //                               localTime: el['localTime'],
      //                               initialSwitchValue: el['isActive'],
      //                               onChanged: (value) async {
      //                                 LoadingProgressDialog().show(context,
      //                                     message: "Updating Status");
      //                                 var d = await RestRouteApi(
      //                                         context, ApiPaths.toggleTask)
      //                                     .post(jsonEncode({
      //                                   "tasks": [el['_id']],
      //                                   "value": value
      //                                 }));

      //                                 if (d != null) {
      //                                   if (d.message != 'error') {
      //                                     showToast(d.message, context);
      //                                   }
      //                                 }
      //                                 LoadingProgressDialog().hide(context);
      //                               },
      //                               onDelete: () async {
      //                                 if (context
      //                                     .read<UserProvider>()
      //                                     .getUserInfo
      //                                     .isMinor) {
      //                                   showToast("Minor Cannot Delete a Task",
      //                                       context);
      //                                   return;
      //                                 }
      //                                 String id = el['_id'];
      //                                 var body = {"id": id};
      //                                 LoadingProgressDialog()
      //                                     .show(context, message: "Deleting");
      //                                 var res = await RestRouteApi(
      //                                         context, ApiPaths.deleteTask)
      //                                     .post(jsonEncode(body));

      //                                 if (res != null) if (res.status
      //                                         .toString()
      //                                         .toLowerCase() ==
      //                                     "success") {
      //                                   await getTaskList(selectedPets,
      //                                       force: true);
      //                                   // members.removeAt(index);
      //                                 }
      //                                 LoadingProgressDialog().hide(context);
      //                               },
      //                               onEdit: () async {
      //                                 String id = el['_id'];
      //                                 if (context
      //                                     .read<UserProvider>()
      //                                     .getUserInfo
      //                                     .isMinor) {
      //                                   showToast(
      //                                       "Minor Cannot Edit a Pet", context);
      //                                   return;
      //                                 } else {
      //                                   openScreen(
      //                                       context,
      //                                       OtherActivity(
      //                                           petId: selectedPets, data: el));
      //                                 }
      //                               },
      //                             ),
      //                           );
      //                         }),
      //                   ),
      //       )
      //     ]);
      //   },
      // ),
    );
  }
}

feedTimeStack(String petImage, int noofFeeds, var timediff, String name,
    String category, String type) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 22, right: 22),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
              height: 140,
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffB122FF),
                                border: Border.all(
                                  color: Color(0xffB122FF),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 8.0),
                              child: Text(
                                "${timediff.toString().split(".")[0]}",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0, top: 20),
          child: CircleAvatar(
            radius: 45.0,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(petImage ?? "assets/images/updog1.png"),
          ),
        ),
      ),
    ],
  );
}

Widget walkTimeStack(String petImage, int noofWalks, var timediff) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 22, right: 22),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
              height: 140,
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff2CC2DC),
                                border: Border.all(
                                  color: Color(0xff2CC2DC),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Due In $timediff Mins",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 19.0),
                        child: Text(
                          "Walk Time",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Garden",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "$noofWalks walk remaining",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0, top: 20),
          child: CircleAvatar(
            radius: 45.0,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(petImage ?? "assets/images/updog1.png"),
          ),
        ),
      ),
    ],
  );
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
