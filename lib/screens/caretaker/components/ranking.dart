import 'package:flutter/material.dart';
import 'package:pets/utils/app_utils.dart';

class Ranking extends StatefulWidget {
  final String name;
  final String taskDetail;
  final int rank;
  final Color color;
  final String imageUrl;
  final Function() onTap;
  Ranking({
    this.name,
    this.taskDetail,
    this.rank,
    this.color,
    this.imageUrl,
    this.onTap,
  });
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(7),
                ),
              ),
              height: 135,
              width: 40,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(-90 / 360),
                child: FittedBox(
                  child: Text(
                    "REMOVE",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 18,
                          color: Color(0xffF7F9FF),
                        ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(2, 2))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
              height: 135,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl ??
                            "https://th.bing.com/th/id/OIP.KaUl_COifO17lipZqzZTYAHaHa?w=182&h=182&c=7&o=5&dpr=1.75&pid=1.7"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            widget.name ?? "Piyush",
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // width: 130,
                          child: Text(
                            widget.taskDetail ?? "Top Task",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Color(0xff7F8FA4),
                                    ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        //Don't remove below commented code
                        // InkWell(
                        //   onTap: () {},
                        //   child: Row(
                        //     children: [
                        //       Text("View All"),
                        //       Icon(Icons.arrow_downward_outlined)
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: widget.color ?? Color(0xff7B85F9),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(14),
              ),
            ),
            height: 135,
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.rank == 1
                      ? Image.asset(
                          "assets/images/cup2.png",
                          height: 30,
                        )
                      : Container(),
                  Center(
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(-90 / 360),
                      child: FittedBox(
                        child: Text(
                          "RANK ${widget.rank ?? 1}",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 18,
                                color: Color(0xffF7F9FF),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
