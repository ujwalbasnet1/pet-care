import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/screens/caretaker/screens/caretake_info/addnew_contact.dart';
import 'package:pets/screens/contacts/components/contact_tile.dart';
import 'package:pets/screens/contacts/components/selected_avatar.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:pets/widgets/loading_indicator.dart';

class ContactsScreen extends StatefulWidget {
  final String userId;
  final String referLink;
  final groupInfo;
  final String referCode;
  const ContactsScreen(
      {Key key, this.userId, this.referLink, this.groupInfo, this.referCode})
      : super(key: key);
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Set<Contact> contactsSelected = {};
  TextEditingController searchController = TextEditingController();
  bool search = false;
  bool isLoading;
  @override
  void initState() {
    setCurrentScreen(ScreenName.contactScreen);
    _handleContactPermission(Permission.contacts);
    getAllContacts();
    searchController.addListener(() {
      filterContacts();
    });
    super.initState();
  }

  String flatternPhoneNumber(String phoneStr) {
    return phoneStr.replaceAll(RegExp(r'^(\+)|\D'), '');
  }

  getAllContacts() async {
    setState(() {
      isLoading = true;
    });

    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false))
            .toList()
            .where((element) => element.phones.length > 0)
            .toList();

    setState(() {
      contacts = _contacts;
      for (var i = 0; i < contacts.length; i++) {
        var k = contacts[i];
      }
      isLoading = false;
    });
  }

  getMobileNo(Contact element) {
    return element.phones
        .firstWhere((element) => element.label == 'mobile', orElse: null)
        .value;
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      String searchTerm = searchController.text.toLowerCase();
      _contacts = _contacts
          .where((element) =>
              (element.displayName ??
                      element.givenName ??
                      element.middleName ??
                      element.familyName ??
                      element.phones.first.value)
                  .toLowerCase()
                  .contains(searchTerm) ||
              element.phones.toString().toLowerCase().contains(searchTerm))
          .toList();
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<void> _handleContactPermission(Permission permission) async {
    final status = await permission.request();
  }

  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Caretaker Group",
              ),
              Text(
                "${contacts.length} Contacts",
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          backgroundColor: blueClassicColor,
          actions: [
            IconButton(
              icon: Icon(
                search ? Icons.cancel_outlined : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  search = !search;
                });
                if (!search) {
                  setState(() {
                    searchController.clear();
                  });
                } else {
                  focusNode.requestFocus();
                }
              },
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.more_vert),
            // ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              search
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        focusNode: focusNode,
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          labelText: "Search",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
              // widget.groupInfo == null
              //     ? Container(
              //         padding: const EdgeInsets.all(8.0),
              //       )
              //     :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    openScreen(
                        context,
                        AddNewContact(
                          groupId: widget.groupInfo == null
                              ? ""
                              : widget.groupInfo['_id'],
                          referCode: widget.groupInfo == null
                              ? widget.referCode
                              : widget.groupInfo['referCode'],
                        ));
                  },
                  leading: CircleAvatar(
                    child: Icon(Icons.person_add),
                  ),
                  title: Text(
                    "New Contact without phone#",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 18,
                          color: Colors.indigo[900],
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "Phone Contacts",
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: contactsSelected.length > 0 ? 100 : 1,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      contactsSelected.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: contactsSelected.length,
                              itemBuilder: (context, index) {
                                return SelectedAvatar(
                                  contact: contactsSelected.toList()[index],
                                  onTap: () {
                                    setState(() {
                                      contactsSelected.remove(
                                          contactsSelected.toList()[index]);
                                    });
                                  },
                                );
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  thickness: 8,
                  radius: Radius.circular(10),
                  child: ListView.builder(
                    itemCount:
                        isSearching ? contactsFiltered.length : contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = isSearching
                          ? contactsFiltered[index]
                          : contacts[index];

                      return ContactTile(
                        contact: contact,
                        onInvitePressed: (str) async {
                          if (str != null) {
                            LoadingProgressDialog()
                                .show(context, message: "Sending Invite");
                            var postableData = {
                              "to": str.replaceAll(" ", "").replaceAll("-", ""),
                              "userID": widget.userId ?? "",
                              "groupReferLink": widget.referLink ?? ""
                            };
                            await RestRouteApi(
                                    context, ApiPaths.inviteCaretaker)
                                .post(jsonEncode(postableData));
                            LoadingProgressDialog().hide(context);
                          } else {
                            showToast("Invalid Mobile No.", context);
                          }
                        },
                      );
                    },
                  ),
                  // child: SingleChildScrollView(
                  //   child: Column(
                  //     children: List.generate(
                  //       isSearching ? contactsFiltered.length : contacts.length,
                  //       (index) {
                  //         Contact contact = isSearching
                  //             ? contactsFiltered[index]
                  //             : contacts[index];

                  //         return ContactTile(
                  //           contact: contact,
                  //           onInvitePressed: (str) async {
                  //             LoadingProgressDialog()
                  //                 .show(context, message: "Sending Invite");
                  //             var postableData = {
                  //               "to":
                  //                   str.replaceAll(" ", "").replaceAll("-", ""),
                  //               "userID": widget.userId ?? "",
                  //               "groupReferLink": widget.referLink ?? ""
                  //             };
                  //

                  //             await RestRouteApi(
                  //                     context, ApiPaths.inviteCaretaker)
                  //                 .post(jsonEncode(postableData));
                  //             LoadingProgressDialog().hide(context);
                  //           },
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ),
              ),
              RoundRectangleButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => BottomNavigation()));
                },
                title: "Finish",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
