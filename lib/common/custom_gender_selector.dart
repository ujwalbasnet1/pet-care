import 'package:flutter/material.dart';

class CustomGenderSelector extends StatefulWidget {
  final Function(String value) onChanged;
  final bool isSelected;
  final int initValue;
  CustomGenderSelector({this.onChanged, this.isSelected, this.initValue = 1});
  @override
  _CustomGenderSelectorState createState() => _CustomGenderSelectorState();
}

class _CustomGenderSelectorState extends State<CustomGenderSelector> {
  int pointer = 1;

  @override
  void initState() {
    pointer = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _box(String value, int number,
        {IconData iconData, String imageUrl}) {
      return InkWell(
        onTap: () {
          setState(() {
            pointer = number;
          });
          widget.onChanged(value);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: pointer == number ? Color(0xff1A81FE) : Colors.transparent,
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconData != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1,
                        ),
                        child: Icon(
                          iconData,
                          color:
                              pointer == number ? Colors.white : Colors.black,
                          size: 20,
                        ),
                      )
                    : Container(),
                imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          imageUrl,
                          height: 20,
                        ),
                      )
                    : Container(),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: pointer == number ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      child: Row(
        children: [
          _box("MALE", 1, imageUrl: "assets/images/man.png"),
          SizedBox(
            width: 10,
          ),
          _box("FEMALE", 2, imageUrl: "assets/images/woman.png"),
          SizedBox(
            width: 10,
          ),
          _box("OTHER", 3),
        ],
      ),
    );
  }
}
