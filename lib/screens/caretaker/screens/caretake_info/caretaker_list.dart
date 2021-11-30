import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/coachmark_widgets.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/theming/theme.dart';
import 'package:share/share.dart';
import 'addnew_contact.dart';
import 'package:pets/utils/app_utils.dart';
import '../../components/group_title.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';

class CaretakerList extends StatefulWidget {
  final groupInfo;

  const CaretakerList({Key key, this.groupInfo}) : super(key: key);
  @override
  _CaretakerListState createState() => _CaretakerListState();
}

class _CaretakerListState extends State<CaretakerList> {
  List members;
  String groupId;
  @override
  void initState() {
    setCurrentScreen(ScreenName.careTakerList);
    groupId = widget.groupInfo['_id'];
    members = widget.groupInfo['members'];
    // if (mounted) {
    //   Timer(Duration(seconds: 1),
    //       () => MarkHelper.showMark(MarkHelper.inviteFriends));
    //   // ;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(name: "Participants", color: Colors.blue, actions: [
        Container()
        // IconButton(
        //   icon: Icon(
        //     Icons.edit,
        //     color: Colors.white,
        //   ),
        //   onPressed: showEditDialog,
        // )
      ]),
      body: GradientBg(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTile(
                  key: MarkHelper.inviteFriends.key,
                  image: "assets/images/add_user.png",
                  name: "Invite Caretaker",
                  onTap: () async {
                    var message =
                        "Welcome to My Pet's Life and Join ${widget.groupInfo['name']}\n${widget.groupInfo['referLink']}\n${widget.groupInfo['referCode']}";

                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0))),
                      builder: (BuildContext context) {
                        return Container(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      Clipboard.setData(new ClipboardData(
                                          text:
                                              "${widget.groupInfo['referLink']}"));
                                      Navigator.pop(context);
                                    },
                                    label: Text("Copy Link"),
                                  ),
                                  ElevatedButton.icon(
                                      label: Text("Share"),
                                      icon: Icon(Icons.share),
                                      onPressed: () async {
                                        await Share.share(message);
                                        Navigator.pop(context);
                                      }),
                                  ElevatedButton.icon(
                                      label: Text("Copy Code"),
                                      icon: Icon(Icons.copy),
                                      onPressed: () {
                                        Clipboard.setData(new ClipboardData(
                                            text:
                                                "${widget.groupInfo['referCode']}"));
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              GroupTile(
                image: "assets/images/add_minor.png",
                name: "Add Minor (Without Phone)",
                onTap: () {
                  openScreen(
                      context,
                      AddNewContact(
                        groupId: widget.groupInfo['_id'],
                        referCode: widget.groupInfo['referCode'],
                      ));
                },
              ),
              Divider(),
              Text(
                "Current Participants",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    var groupInfo = members[index]['person']['userInfo'];
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GroupTile(
                          image: groupInfo['avatar'],
                          name: groupInfo['fname'],
                          onTap: () {
                            // openScreen( // TODO
                            //     context, CaretakerList(members: groupInfo['members']));
                          },
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            var body = {
                              "caretakerId": members[index]['person']['_id'],
                              "groupId": groupId
                            };
                            LoadingProgressDialog().show(context);
                            var res = await RestRouteApi(
                                    context, ApiPaths.removeCareTaker)
                                .post(jsonEncode(body));
                            LoadingProgressDialog().hide(context);
                            if (res != null) if (res.status
                                    .toString()
                                    .toLowerCase() ==
                                "success") {
                              await context
                                  .read<UserProvider>()
                                  .getCareTakeGroup(context);
                              members.removeAt(index);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var message =
      //         "Welcome to My Pet's Life and Join ${widget.groupInfo['name']}\n${widget.groupInfo['referLink']}\n${widget.groupInfo['referCode']}";
      //     await Share.share(message);
      //     // openScreen(
      //     //     context, InviteScreen(referLink: widget.groupInfo['referLink']));
      //   },
      //   child: Icon(Icons.person_add),
      // ),
    );
  }

  void showEditDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 280,
              padding: const EdgeInsets.all(padding * 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Edit Group Name",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  CommonTextField(
                    name: "group_name",
                    labelText: "Group Name",
                  ),
                  Spacer(),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        color: Colors.red,
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text("Ok"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
