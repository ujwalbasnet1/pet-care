import 'package:flutter/material.dart';

class EarnedCoin extends StatelessWidget {
  final dynamic coins;

  const EarnedCoin({Key key, this.coins = "0"}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff2485FE)),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 2.0),
            child: Image.asset(
              "assets/images/coin.png",
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              " $coins ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
