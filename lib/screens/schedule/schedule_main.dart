import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/theming/theme.dart';
import 'create_schedule.dart';
import 'other_activity.dart';
import 'custom_activity.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/screens/schedule_create/schedule_create.dart';
import 'package:provider/provider.dart';

class ScheduleMain extends StatefulWidget {
  @override
  _ScheduleMainState createState() => _ScheduleMainState();
}

class _ScheduleMainState extends State<ScheduleMain> {
  String selectedPet;
  List scheduleType = [
    {"type": "meal", "title": "Add Meal Time"},
    {"type": "walk", "title": "Add Walk Time"},
    {"type": "other", "title": "Other Daily Activity"},
    {"type": "custom", "title": "Custom Activity"},
    {"type": "new", "title": "New Screen - Updated"},
  ];
  LoadingProgressDialog loadingIndicator = new LoadingProgressDialog();
  var petList;
  var taskList;

  @override
  void initState() {
    setCurrentScreen(ScreenName.scheduleMain);

    getPets();
    super.initState();
  }

  getPets() async {
    var uPro = context.read<UserProvider>();
    await uPro.fetchListData(context, force: false);
    var data = uPro.getPetListData;

    if (data != null) {
      setState(() {
        petList = data['data'];
      });
    }

    return true;
  }

  getTaskByPets(id) async {
    var data =
        await RestRouteApi(context, ApiPaths.getTaskByPetId + taskList).get();

    if (data != null) {
      setState(() {
        taskList = data['data'];
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBarWidget(color: Colors.blue, name: "Add Schedule"),
          body: petList == null
              ? LoadingIndicator()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    _selectPet() {
                      return FormBuilderDropdown(
                        hint: Text("Select Pet"),
                        // initialValue: selectedPet ?? petList[0]['name'],
                        items: petList.map<DropdownMenuItem>((e) {
                          return DropdownMenuItem(
                            child: Text(e['name']),
                            value: e['_id'],
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPet = value;
                          });
                        },
                        name: "petname",
                      );
                    }

                    return Container(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Pet Name"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _selectPet(),
                          ),
                          Expanded(
                            child: ListView(
                                children: scheduleType.map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: padding / 2),
                                child: ListTile(
                                  title: Text(e['title']),
                                  subtitle: Text("None"),
                                  trailing: FloatingActionButton(
                                    // heroTag: e,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (selectedPet == null) {
                                        showToast("Select a pet", context);
                                        return;
                                      }
                                      var screen;
                                      switch (e['type']) {
                                        case "other":
                                          screen = OtherActivity(
                                              scheduleType: e,
                                              petId: selectedPet);
                                          break;
                                        case "new":
                                          screen = ScheduleCreate();
                                          break;
                                        case "custom":
                                          screen = CustomActivity(
                                              scheduleType: e,
                                              petId: selectedPet);
                                          break;
                                        default:
                                          screen = CreateSchedule(
                                              scheduleType: e,
                                              petId: selectedPet);
                                      }
                                      openScreen(context, screen);
                                    },
                                  ),
                                ),
                              );
                            }).toList()),
                          ),
                        ],
                      ),
                    );
                  },
                )),
    );
  }
}
