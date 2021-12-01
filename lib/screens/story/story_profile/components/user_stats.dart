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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    _statsRow() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          color: Colors.transparent,
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.2, color: blueClassicColor),
                          borderRadius: BorderRadius.circular(height)),
                      padding: EdgeInsets.all(2),
                      // color: Colors.red,
                      child: Container(
                        height: height * 0.15,
                        width: height * 0.15,
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
                            // Text(
                            //   userName,
                            //   style: TextStyle(
                            //       fontSize: 24,
                            //       fontWeight: FontWeight.bold,
                            //       color: height < 120
                            //           ? Colors.white
                            //           : blueClassicColor),
                            // ),

                            height < 170 ? Container() : _statsRow(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: height < 120 ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  "Product/Service",
                  style: TextStyle(fontSize: 14, color: Color(0xFF7a7a7a)),
                ),
                const SizedBox(height: 4),
                Text(
                  "This is my beautiful dog which is good and handsome and realy good",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 32,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: SizedBox(
                      width: double.infinity,
                      child: Consumer(
                        builder: (BuildContext context,
                            UserProfileProvider upPro, Widget child) {
                          String text = upPro.isFollowing == null
                              ? "Follow"
                              : upPro.isFollowing
                                  ? "Following"
                                  : "Follow";
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      upPro.isFollowing =
                                          upPro.isFollowing == null
                                              ? true
                                              : !upPro.isFollowing;
                                    },
                                    child: Text(text)),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Message",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )),
                ),
                const SizedBox(height: 12),
                height < 320
                    ? Container()
                    : Row(
                        //   shrinkWrap: true,
                        // padding: EdgeInsets.zero,
                        //
                        //   scrollDirection: Axis.horizontal,
                        children: [
                          _ownsDogWidget(height * 0.125),
                          _ownsDogWidget(height * 0.125),
                          _ownsDogWidget(height * 0.125),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  _ownsDogWidget(double size) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size,
            width: size,
            alignment: Alignment.centerLeft,
            //  margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
                // color: blueClassicColor,
                borderRadius: BorderRadius.circular(150),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      '$petImage',
                    ))),
          ),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Text('$petName ', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 1),
              Text('Dog'),
            ],
          )),
        ],
      ),
    );
  }
}
