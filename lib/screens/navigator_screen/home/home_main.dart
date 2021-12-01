import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/add_schedule_modal.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/coachmark_widgets.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/custom_image.dart';
import 'package:pets/common/indicatorSlideHome.dart';
import 'package:pets/common/invite_bottom_sheet.dart';
import 'package:pets/common/update_dialog.dart';
import 'package:pets/screens/five-steps/pet_type.dart';
import 'package:pets/screens/story/components/rect_story.dart';
import 'package:pets/screens/story/explore/shorts_main.dart';
import 'package:pets/screens/story/gif_stories.dart';
import 'package:pets/screens/story/story_viewer/story_home.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/utils/static_variables.dart';
import 'components/app_drawer.dart';
import 'components/earned_coin.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/service/network.dart';
import 'components/family_points.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/screens/navigator_screen/profiles/notification_prefs/notification_list.dart';
import 'components/home_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';

class HomeMain extends StatefulWidget {
  final Function(int, int) onPressTabChange;
  const HomeMain({
    Key key,
    this.onPressTabChange,
  }) : super(key: key);
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  var _pageController;
  var userId = "";
  @override
  void initState() {
    setCurrentScreen(ScreenName.homeMain);

    if (mounted) {
      getPoint();
    }
    _pageController = PageController();
    super.initState();
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'feedback@mypetslife.us',
      queryParameters: {'subject': 'Feedback'});
  // upDateStatus() async {
  //   userData = await SharedPref().read("userData");
  //   setState(() {});
  // }

  var points = "0";

  getPoint() async {
    // force => update
    // false => update and skip

    await context.read<UserProvider>().fetchUserInfo(context, force: false);
    if (showMissedNotification) {
      if (!isNotificationShown) {
        await checkUpdate();
        checkMissedNotification();
      }
    }
    return true;
  }

  pulltoRefresh() async {
    return await context.read<UserProvider>().onHomeRefresh(context);
  }

  checkUpdate() async {
    var os = Platform.isAndroid ? 'android' : 'ios';
    var version = (await getAppInfo()).version;
    var buildNumber = (await getAppInfo()).buildNumber;
    var queries = "?platform=$os&currentVersion=$version.$buildNumber";
    var res = await RestRouteApi(context, ApiPaths.storeUpdate + queries).get();
    if (res != null) {
      if (res['data'] != null) {
        if (res['data']['isUpdate'] && res['data']['isShow']) {
          showUpdateDialog(context, res['data'], isCupertino: os == 'ios');
        }
      }
    }
  }

  checkMissedNotification() async {
    var notiSelectedPets = context
        .read<UserProvider>()
        .getPetList
        .map((e) => e['_id'])
        .toList()
        .join(",");

    var d = DateTime.now().toString().split(" ")[0];
    var time = (DateTime.parse(d).toUtc().millisecondsSinceEpoch) ~/ 1000;
    var data = await RestRouteApi(
            context,
            ApiPaths.getNotificationsFilter +
                "?time=${time.toString()}&pet=$notiSelectedPets&isMissed=true")
        .get();
    if (data != null) {
      isNotificationShown = true;
      if (data['data'].length > 0) {
        openScreen(context, NotificationList(missedNoti: data['data']));
      }
    }
  }

  getTaskById(petID) async {
    // ignore: unused_local_variable
    var data =
        await RestRouteApi(context, ApiPaths.getTaskByPetId + petID).get();
    if (mounted) setState(() {});

    return true;
  }

  @override
  Widget build(BuildContext context) {
    body() {
      return Consumer(
        builder: (BuildContext context, UserProvider uPro, Widget child) {
          _suggestionComponents() {
            return Container(
              width: double.infinity,
              height: 70,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: new LinearGradient(
                    colors: [
                      Color(0xffFFE259),
                      Color(0xffFFA751),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: InkWell(
                onTap: () async {
                  await launch(_emailLaunchUri.toString());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Share your suggestions/feature request",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "feedback@mypetslife.us",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          _petsOfTheWeek() {
            return InkWell(
              onTap: () {
                openScreen(
                    context,
                    ShortsMain(
                      data: {'stories': gifStories},
                      index: 2,
                      isMaterial: true,
                      petsOfTheWeekIndex: 2,
                    ));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.red,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image:
                            AssetImage("assets/images/pet_of_the_week_2.png"))),
              ),
            );
          }

          _petDetails() {
            return PageView.builder(
              controller: _pageController,
              itemCount: uPro.getPetList.length,
              itemBuilder: (BuildContext context, int index) {
                var petInfoData = uPro.getPetList[index];

                var petID = petInfoData['_id'];
                List members = petInfoData['group']['members'] as List;
                members.sort((a, b) => a['points'].compareTo(b['points']));
                members = members.reversed.toList();
                _header() {
                  return Container(
                    key: index == 0
                        ? MarkHelper.swipeLeft.key
                        : Key(index.toString()),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    // color: Colors.red,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                capitalize(petInfoData['name']) ?? "",
                                style: latoTextStyle(fontSize: 25),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                              ),
                              Text(
                                petInfoData['breed'] ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Container(
                                height: 32,
                                child: FloatingActionButton.extended(
                                  icon: Icon(Icons.add),
                                  label: Text("Pet Activity"),
                                  onPressed: () {
                                    showCustomModalAtBottom(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            width: 120,
                            height: 120,
                            child: CustomImage(
                              url: petInfoData['image'],
                              // fit: BoxFit,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                _membersPoints() {
                  return InkWell(
                    onTap: () {
                      widget.onPressTabChange(2, index);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          petInfoData['group']['name'] ?? "Family",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        Container(
                          key: index == 0
                              ? MarkHelper.barGraphPoints.key
                              : Key((index + 200).toString()),
                          margin: EdgeInsets.only(bottom: 20.0, top: 8),
                          width: double.infinity,
                          child: FamilyPointsDart(
                            members: members,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var userInfo = uPro.getUserData['data']['userInfo'] ?? {};
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        strokeWidth: 3,
                        onRefresh: () => pulltoRefresh(),
                        child: ListView(
                          padding: const EdgeInsets.only(
                              top: 0,
                              right: padding,
                              left: padding,
                              bottom: padding),
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new StoryHome().createState().storyRow(
                              "${userInfo['fname']}",
                              "${userInfo['avatar']}",
                              context,
                              onFollowPressed: () {
                                widget.onPressTabChange(4, 4);
                              },
                            ),
                            // Container(
                            //   height: 85,
                            //   width: double.maxFinite,
                            //   child: SingleChildScrollView(
                            //     scrollDirection: Axis.horizontal,
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceEvenly,
                            //       children: [],
                            //     ),
                            //   ),
                            // ),
                            uPro.getUserData == null ? Container() : _header(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(uPro.getPetList.length,
                                  (uindex) {
                                return IndicatorSliderHome(
                                  isSelected: index == uindex,
                                  imageUrl: uPro.getPetList[uindex]['image'] ??
                                      "https://d2m3ee76kdhdjs.cloudfront.net/static_assets/dog.png",
                                  onPressed: () {
                                    _pageController.animateToPage(
                                      uindex,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            _membersPoints(),
                            members.length > 1
                                ? Container()
                                : Container(
                                    height: 72,
                                    margin: EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        var groupDetails = petInfoData['group'];
                                        new InviteBottomSheet(
                                          context,
                                          groupDetails,
                                          uPro.getUserInfo.userId,
                                        ).showBottomSheet(context);
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
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/caretaker.png"),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Invite Caretaker for your Pet",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            RectStory(),
                            _petsOfTheWeek(),
                            _suggestionComponents(),

                            HomeTask(
                              tasks: petInfoData['task'],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }

          final double iconSize = 18;

          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: Builder(
                  builder: (context) {
                    return TextButton(
                      child: Icon(
                        Icons.menu,
                        color: blueClassicColor,
                      ),
                      onPressed: () {
                        logEvent(ScreenName.navigation, isEvent: true);
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                actions: [
                  Center(
                    child: EarnedCoin(
                      coins: uPro.getTotalPoints ??
                          "0".toString(), // petInfoData['points'] ?? points,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton(
                    offset: Offset(0, 45),
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Post'),
                              Image.asset(
                                "assets/images/schedule.png",
                                height: 20,
                                width: 20,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          value: 'Post'),
                      PopupMenuItem<String>(
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reel'),
                              Image.asset(
                                "assets/images/video.png",
                                height: 20,
                                width: 20,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          value: 'Reel'),
                    ],
                    child: Icon(
                      Icons.add_box_outlined,
                      color: Colors.blue,
                      size: iconSize + 8,
                    ),
                    onSelected: (_) {},
                  ),
                  Container(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationList(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          "assets/images/notification_final.png",
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              drawer: AppDrawer(),
              backgroundColor: Colors.transparent,
              body: StoryHome(
                  body: uPro.getUserData == null
                      ? LoadingIndicator()
                      : uPro.getPetList.isEmpty
                          ? Center(
                              child: RoundRectangleButton(
                                title: "Add a Pet to Become a Caretaker",
                                onPressed: () {
                                  var infoData = {};
                                  infoData['petsCount'] = 1;
                                  infoData['currentScreen'] = 1;
                                  openScreen(
                                      context,
                                      PetType(
                                        infoData: infoData,
                                        isFromAddPets: true,
                                      ));
                                },
                              ),
                            )
                          //  LoadingIndicator(
                          //     imageUrl: "assets/gif/sad_dog.gif",
                          //     message: "Data Not Found",
                          //     textColor: Colors.black)
                          : _petDetails()));
        },
      );
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: body(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.wallet_giftcard_outlined),
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return CheckInWidget();
                });
          },
        ));
  }
}

class CheckInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 8,
          ),
          Container(
            height: 6,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 16),
          Icon(
            Icons.wallet_giftcard,
            size: 84,
            color: Colors.black54,
          ),
          SizedBox(height: 16),
          Text(
            "Checked in",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          SizedBox(height: 8),
          Text(
            "You have checked in for 3 days.",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          SizedBox(height: 12),
          Text(
            "See in my check-in calender >",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
