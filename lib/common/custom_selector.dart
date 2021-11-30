import 'package:flutter/material.dart';

class CustomSelector extends StatefulWidget {
  final Function(int value) onChanged;
  final bool isSelected;
  CustomSelector({this.onChanged, this.isSelected});
  @override
  _CustomSelectorState createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  int pointer = 1;

  @override
  void initState() {
    if (widget.isSelected ?? false) {
      pointer = 1;
    }
    super.initState();
  }

  Widget _box(int number) {
    return InkWell(
      onTap: () {
        setState(() {
          pointer = number;
          widget.onChanged(number);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: pointer == number ? Color(0xff1A81FE) : Colors.transparent,
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 40,
        width: 40,
        child: Center(
          child: Text(
            "$number",
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: pointer == number ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _box(1),
          _box(2),
          _box(3),
          _box(4),
          _box(5),
          _box(6),
          _box(7),
        ],
      ),
    );
  }
}
