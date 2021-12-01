import 'package:flutter/material.dart';

class Follow extends StatelessWidget {
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
                SizedBox(
                  height: 12,
                ),
                _itemInvite(context),
                SizedBox(
                  height: 12,
                ),
                _itemInvite(
                  context,
                ),
                SizedBox(
                  height: 20,
                ),
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

  _itemInvite(BuildContext context) {
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
}
