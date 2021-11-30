import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/provider/user_profile_provider.dart';
import 'package:provider/provider.dart';

class UserStats extends StatelessWidget {
  final String userName;
  final String image;
  final String petImage;
  final String petName;
  final String follower;
  String following;
  final String posts;
  final List stories;

  final Function() onFollow;

  UserStats(
      {Key key,
      this.userName = 'Mr. Odom',
      this.follower = '300',
      this.following = '110',
      this.posts = '900',
      this.onFollow,
      this.image,
      this.stories,
      this.petName = "Echo",
      this.petImage =
          "https://barkingroyalty.com/wp-content/uploads/2015/12/pomeraninan-puppy.jpg"})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    _items(subTitle, title) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      );
    }

    _statsRow() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _items('Posts', posts),
            _items('Follower', follower),
            Consumer(
              builder: (BuildContext context, UserProfileProvider upPro,
                  Widget child) {
                if (upPro.isFollowing != null) {
                  following = upPro.isFollowing
                      ? (int.parse(following) + 1).toString()
                      : (int.parse(following) - 1).toString();
                }
                return _items('Following', following);
              },
            )
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.maxHeight;
        return Container(
          color: height > 120 ? Colors.transparent : blueClassicColor,
          // color: Colors.transparent,
          padding: EdgeInsets.only(
              left: (height < 220 ? 50 : 12),
              right: 12,
              top: (height < 220 ? 15 : 12)),
          child: Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.2,
                            color:
                                height < 120 ? Colors.white : blueClassicColor),
                        borderRadius: BorderRadius.circular(height)),
                    padding: EdgeInsets.all(2),
                    // color: Colors.red,
                    child: Container(
                      height: height * (height < 120 ? 0.4 : 0.3),
                      width: height * (height < 120 ? 0.4 : 0.3),
                      decoration: BoxDecoration(
                          // color: blueClassicColor,
                          borderRadius: BorderRadius.circular(150),
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                image ??
                                    'https://unsplash.com/photos/2UZ4kQRImVg/download?force=true&w=640',
                              ))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: height < 120
                                    ? Colors.white
                                    : blueClassicColor),
                          ),
                          height < 170 ? Container() : _statsRow(),
                          height < 220
                              ? Container()
                              : SizedBox(
                                  width: double.infinity,
                                  child: Consumer(
                                    builder: (BuildContext context,
                                        UserProfileProvider upPro,
                                        Widget child) {
                                      String text = upPro.isFollowing == null
                                          ? "Follow"
                                          : upPro.isFollowing
                                              ? "Following"
                                              : "Follow";
                                      return ElevatedButton(
                                          onPressed: () {
                                            upPro.isFollowing =
                                                upPro.isFollowing == null
                                                    ? true
                                                    : !upPro.isFollowing;
                                          },
                                          child: Text(text));
                                    },
                                  ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              height < 300
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('He Owns'),
                              Text(
                                '$petName',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text('Dog'),
                            ],
                          )),
                          Container(
                            height: height * 0.3,
                            width: height * 0.3,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                // color: blueClassicColor,
                                borderRadius: BorderRadius.circular(150),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      '$petImage',
                                    ))),
                          )
                        ],
                      ),
                    )
            ],
          )),
        );
      },
    );
  }
}
