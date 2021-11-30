import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/gradient_bg.dart';

class PetSchedule extends StatefulWidget {
  @override
  _PetScheduleState createState() => _PetScheduleState();
}

class _PetScheduleState extends State<PetSchedule> {
  List<String> list = ["Oreo & Joe's Walk"];
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodyText1;
    var gradient = LinearGradient(
      colors: [
        Color(0xff6D788F),
        Color(0xff424A59),
      ],
    );
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
          name: "Create Schedule",
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Past Events",
                  style: style.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                  children: List.generate(5, (index) {
                return ListTile(
                  title: Text(
                    list[0],
                    style: style.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Due in 30 mins",
                    style: style.copyWith(
                      fontSize: 14,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                  leading: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://d2m3ee76kdhdjs.cloudfront.net/static_assets/dog.png",
                        ),
                      ),
                    ),
                  ),
                  trailing: Container(
                    width: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            gradient: gradient,
                          ),
                          width: 90,
                          height: 30,
                          child: Text(
                            "3:00 PM",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            gradient: gradient,
                          ),
                          width: 30,
                          height: 30,
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upcoming Events",
                  style: style.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                  children: List.generate(5, (index) {
                return ListTile(
                  title: Text(
                    list[0],
                    style: style.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Due in 30 mins",
                    style: style.copyWith(
                      fontSize: 14,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                  leading: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://d2m3ee76kdhdjs.cloudfront.net/static_assets/dog.png",
                        ),
                      ),
                    ),
                  ),
                  trailing: Container(
                    width: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            gradient: gradient,
                          ),
                          width: 90,
                          height: 30,
                          child: Text(
                            "3:00 PM",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            gradient: gradient,
                          ),
                          width: 30,
                          height: 30,
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
            ],
          ),
        ),
      ),
    );
  }
}
