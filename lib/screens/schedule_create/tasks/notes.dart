import 'package:animations/animations.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  List<Widget> list;
  void Function(String time) getTime;
  void Function(String time) getTitle;
  Notes({
    this.list,
    this.getTime,
    this.getTitle,
  });
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController nameController = TextEditingController();
  String selectedPets = 'ALL';
  List<String> list = [];
  var data = {
    "Notes": [
      "Need to Talk Oreo to Walk",
      "Pet addictive",
      "My Name is Piyush.",
      "Need to Talk Oreo to Walk",
      "Pet addictive",
      "My Name is Piyush.",
      "Need to Talk Oreo to Walk",
      "Pet addictive",
      "My Name is Piyush.",
      "Need to Talk Oreo to Walk",
      "Pet addictive",
      "My Name is Piyush.",
    ],
  };
  void _showDialog() {
    FocusNode focusNode = FocusNode();
    showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: nameController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: "Enter Note Description",
              labelStyle: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.blue),
              // border: OutlineInputBorder(),
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
          // title: Text("Enter Title"),
          actions: [
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (nameController.text != "") {
                  setState(() {
                    list.add(capitalize(nameController.text));
                  });
                  nameController.clear();
                }
              },
            ),
          ],
        );
      },
    );
    focusNode.requestFocus();
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

  void updateData() {
    list = data["Notes"];
    // print(list);
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
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
          centerTitle: false,
          name: "Notes",
        ),
        body: list.isEmpty
            ? Container(
                child: Center(
                  child: Text(
                    "ADD Notes for Your Pet by clicking on Add notes button below",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 17,
                        ),
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Pet",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 16),
                      ),
                      Consumer(
                        builder: (BuildContext context, UserProvider uPro,
                            Widget child) {
                          List petInfoList = uPro.getPetList;
                          var petList = [
                            {"id": 'ALL', "name": 'ALL'}
                          ];
                          if (petInfoList != null) {
                            petInfoList.forEach((e) {
                              petList.add({
                                "id": e['_id'],
                                "name": e['name'],
                                "image": e['image']
                              });
                            });
                          }
                          return CustomPicker(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            // selectedItems: selectedPets,
                            initiallySelected: true,
                            selectedPointer: petList
                                .map<String>((e) => e['name'])
                                .toList()
                                .indexOf(selectedPets),
                            list:
                                petList.map<String>((e) => e['name']).toList(),
                            imageUrls:
                                petList.map<String>((e) => e['image']).toList(),
                            // getSelectedItem: (selectedItems) {
                            //   print(selectedItems);
                            // },
                            onPressed: (title, index) {
                              var id = petList[index]['id'];
                              selectedPets = id;
                              setState(() {});
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: List.generate(
                          list.length,
                          (index) {
                            return Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  list[index],
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                color: colorList[index % colorList.length],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            _showDialog();
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
                  ),
                ),
              ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _showDialog();
        //   },
        //   tooltip: "Add Notes",
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }
}
