import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/provider/main_provider.dart';
import 'package:pets/screens/five-steps/about_pet.dart';
import 'package:pets/screens/five-steps/pet_type.dart';
import 'package:pets/service/network.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';
import 'manage_pet_edit.dart';

class ManagePetList extends StatefulWidget {
  @override
  _ManagePetListState createState() => _ManagePetListState();
}

class _ManagePetListState extends State<ManagePetList> {
  void initState() {
    setCurrentScreen(ScreenName.managePetList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Manage Pets"),
        ),
        body: Consumer(
          builder: (BuildContext context, UserProvider uPro, Widget child) {
            return uPro.getPetList == 0
                ? Container()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(padding),
                          itemCount: uPro.getPetList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var e = uPro.getPetList[index];
                            return Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              e["image"] ??
                                                  "https://d2m3ee76kdhdjs.cloudfront.net/static_assets/dog.png",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          capitalize(e['name']),
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff080040)),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (context
                                              .read<UserProvider>()
                                              .getUserInfo
                                              .isMinor) {
                                            showToast(
                                                "Minor Cannot Delete a Pet",
                                                context);
                                            return;
                                          }
                                          String id = e['_id'];
                                          var body = {"id": id};
                                          LoadingProgressDialog().show(context);
                                          var res = await RestRouteApi(
                                                  context, ApiPaths.removePet)
                                              .post(jsonEncode(body));

                                          if (res != null) if (res.status
                                                  .toString()
                                                  .toLowerCase() ==
                                              "success") {
                                            await context
                                                .read<UserProvider>()
                                                .onPetChange(context);
                                            // members.removeAt(index);
                                          }
                                          LoadingProgressDialog().hide(context);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          // ignore: unused_local_variable
                                          String id = e['_id'];
                                          if (context
                                              .read<UserProvider>()
                                              .getUserInfo
                                              .isMinor) {
                                            showToast("Minor Cannot Edit a Pet",
                                                context);
                                            return;
                                          } else {
                                            openScreen(context,
                                                ManagePetEdit(data: e));
                                          }
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: InkWell(
                            onTap: () {
                              var infoData = {};
                              infoData['petsCount'] = 1;
                              infoData['currentScreen'] = 1;

                              openScreen(
                                  context,
                                  PetType(
                                      infoData: infoData, isFromAddPets: true));
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
                                    "Add More",
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
