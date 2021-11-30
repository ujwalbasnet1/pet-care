import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';

class PetTypeTile extends StatelessWidget {
  final String name;
  final String petImage;
  final bool isSelected;
  final Function onPressed;

  PetTypeTile({
    this.petImage,
    this.name,
    this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heigth = constraints.maxHeight;
        return InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: isSelected ? blueClassicColor : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: Offset(3, 5))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: petImage.startsWith("http")
                              ? NetworkImage(petImage)
                              : AssetImage(petImage),
                          fit: BoxFit.fill),
                      shape: BoxShape.circle,
                    ),

                    // child: Image(image: AssetImage(petImage)
                    // )
                  ),
                ),
                Container(
                  height: heigth * 0.2,
                  child: Center(
                      child: Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),
                  )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget choosePetStack() {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 39),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 140,
            width: 130,
            child: Card(
              elevation: 10,
              child: Center(
                child: Text(
                  "Dog",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(
                "https://post.greatist.com/wp-content/uploads/sites/3/2020/02/322868_1100-1100x628.jpg"),
          ),
        ),
      ),
    ],
  );
}
