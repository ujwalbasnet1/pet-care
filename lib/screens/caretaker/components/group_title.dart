import 'package:flutter/material.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/custom_image.dart';

class GroupTile extends StatelessWidget {
  final String image;
  final String name;
  final Function() onTap;
  final Function() onDelete;

  const GroupTile({Key key, this.image, this.name, this.onTap, this.onDelete})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: padding),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: image.startsWith("http")
                        ? CustomImage(url: image)
                        : Image.asset(image),
                  )),

              // CircleAvatar(
              //   radius: 30,
              //   child: image.startsWith("http")
              //       ? Image.network(image)
              //       : Image.asset(image),
              // ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onDelete == null
                ? Container()
                : IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
