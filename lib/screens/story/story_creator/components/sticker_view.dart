import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StickerView extends StatelessWidget {
  const StickerView({Key key, this.onSelected}) : super(key: key);
  final Function(String) onSelected;
  @override
  Widget build(BuildContext context) {
    print('sticker');
    return FutureBuilder(
      future: rootBundle.loadString('AssetManifest.json'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data == null) {
          return Text("Loading");
        } else {
          final Map<String, dynamic> manifestMap = jsonDecode(snapshot.data);
          print('sticker ' + jsonEncode(manifestMap));
          final imagePaths = manifestMap.keys
              .where((String key) => key.contains('stickers/'))
              .toList();

          // return Text(imagePaths.toString());
          return GridView.count(
            crossAxisCount: 4,
            children: imagePaths
                .map((path) => InkWell(
                      onTap: () {
                        onSelected(path);
                      },
                      child: Image.asset(path),
                    ))
                .toList(),
          );
        }
      },
    );
  }
}

showStickerSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.75,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.remove,
                        color: Colors.grey[600],
                      ),
                      Expanded(child: StickerView(onSelected: (path) {
                        Navigator.pop(context, path);
                      })),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
