import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pets/utils/app_utils.dart';

class NeedHelpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showModal(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  width: double.infinity,
                  height: 70,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await sendEmail();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Need Help? Please send us mail at",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          "feedback@mypetslife.us",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Need Help"),
            Icon(Icons.help_outline),
          ],
        ),
      ),
    );
  }
}
