import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

showUpdateDialog(mContext, data, {isCupertino = false}) async {
  await showDialog(
    barrierDismissible: !data['force'],
    context: mContext,
    builder: (BuildContext context) {
      return isCupertino
          ? _cupertinoAlertDialog(data['force'], data['title'], data['version'],
              data['releaseNotes'], data['url'], context)
          : _alertDialog(data['force'], data['title'], data['version'],
              data['releaseNotes'], data['url'], context);
    },
  );
}

AlertDialog _alertDialog(bool force, String title, String message,
    String releaseNotes, String url, BuildContext context) {
  Widget notes;
  if (releaseNotes != null) {
    notes = Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Release Notes:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              releaseNotes,
              maxLines: 15,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
  return AlertDialog(
    title: Text(title),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(message),
        Padding(padding: EdgeInsets.only(top: 15.0), child: Text(releaseNotes)),
        // if (notes != null) notes,
      ],
    ),
    actions: <Widget>[
      !force
          ? TextButton(
              child: Text("SKIP"),
              onPressed: () {
                Navigator.pop(context);
              })
          : Container(),
      TextButton(
          child: Text("UPDATE NOW"),
          onPressed: () async {
            await launch(url);
          }),
    ],
  );
}

CupertinoAlertDialog _cupertinoAlertDialog(bool force, String title,
    String message, String releaseNotes, String url, BuildContext context) {
  Widget notes;
  if (releaseNotes != null) {
    notes = Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          children: <Widget>[
            Text('Release Notes:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              releaseNotes,
              maxLines: 14,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
  return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(message),
          Padding(
              padding: EdgeInsets.only(top: 15.0), child: Text(releaseNotes)),
        ],
      ),
      actions: !force
          ? [
              CupertinoDialogAction(
                  // isDefaultAction: true,
                  child: Text("SKIP"),
                  onPressed: () async {
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                  // isDefaultAction: true,
                  child: Text("UPDATE NOW"),
                  onPressed: () async {
                    await launch(url);
                  })
            ]
          : [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("UPDATE NOW"),
                  onPressed: () async {
                    await launch(url);
                  })
            ]);
}
