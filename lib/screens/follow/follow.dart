import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/screens/contacts/components/contact_tile.dart';
import 'package:pets/screens/contacts/components/selected_avatar.dart';

class Follow extends StatefulWidget {
  @override
  State<Follow> createState() => _FollowState();
}

class _FollowState extends State<Follow> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Follow"),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Icon(
                //   Icons.menu,
                //   color: Colors.black87,
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                Text(
                  "Contact on My Pets Life",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 12,
                ),
                _itemFollow(context),
                SizedBox(
                  height: 12,
                ),
                _itemFollow(
                  context,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Phone Contacts",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                (isLoading)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ContactTile(
                          contact: contacts[index],
                          onInvitePressed: (_) {},
                          disableMargin: true,
                        ),
                        separatorBuilder: (_, __) => SizedBox(height: 12),
                        itemCount: contacts.length,
                      ),

                SizedBox(height: 120),
              ],
            ),
          ),
          Positioned(
            right: 8,
            left: 8,
            bottom: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(16)),
              child: Text(
                "Follow Your Friends and Family to see their stories and latest updates from them. ",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _itemFollow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  "https://static.remove.bg/remove-bg-web/a76316286d09b12be1ebda3b400e3f44716c24d0/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg"),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              "Matthew Collins",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
        TextButton(
            onPressed: () {},
            child: Container(
                width: 78,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text("UnFollow")))
      ],
    );
  }

  _itemInvite(Contact contact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(44),
                child: Image.memory(
                  contact.avatar,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.blueGrey.withOpacity(0.5)),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              contact.displayName,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Container(
            width: 78,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue),
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                "Invite",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _handleContactPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  initialize() async {
    try {
      bool isGranted = await _handleContactPermission(Permission.contacts);
      if (isGranted) {
        getAllContacts();
      } else {
        isGranted = await _handleContactPermission(Permission.contacts);
      }
    } catch (e) {
      print(e);
    }
  }

  List<Contact> contacts = [];

  bool isLoading = false;

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
}
