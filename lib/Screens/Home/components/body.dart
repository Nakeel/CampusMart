import 'dart:async';

import 'package:campus_mart/Screens/Home/components/background.dart';
import 'package:campus_mart/Screens/Home/components/category_list.dart';
import 'package:campus_mart/Screens/Home/components/featured_items.dart';
import 'package:campus_mart/Screens/Home/components/header_with_searchbox.dart';
import 'package:campus_mart/Screens/Home/components/recommended_Item_card.dart';
import 'package:campus_mart/Screens/Home/components/recommended_items.dart';
import 'package:campus_mart/Screens/Home/components/title_with_more_btn.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:campus_mart/services/database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String username = 'User', firstname = '', email = '', fullname = 'User Name';
  CustomUserInfo user;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  GoodAdNotifier goodsNotifier;
  WantsNotifier wantsNotifier;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    GoodAdNotifier goodsNotifier =
        Provider.of<GoodAdNotifier>(context, listen: false);
    DatabaseService().getGoodAds(goodsNotifier);

    WantsNotifier wantsNotifier =
        Provider.of<WantsNotifier>(context, listen: false);
    DatabaseService().getWants(wantsNotifier);

    timer = Timer(Duration(seconds: 4), () {
      setState(() {
        username = user.username;
        email = user.email;
        fullname = user.fullname;
        saveUserInfo(user);
      });
    });

    super.initState();
  }

  saveUserInfo(CustomUserInfo user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(EMAIL, user.email);
    await prefs.setString(USERNAME, user.username);
    await prefs.setString(FULLNAME, user.fullname);
    await prefs.setString(PROFILE_IMG, user.profileImgUrl);
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    DatabaseService().getWants(wantsNotifier);
    DatabaseService().getGoodAds(goodsNotifier);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<CustomUserInfo>(context);
    wantsNotifier = Provider.of<WantsNotifier>(context);
    goodsNotifier = Provider.of<GoodAdNotifier>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await _refresh();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Container(
              //   height: 200,
              //   child: new CarouselSlider(items: ,bo),
              // ),

              HeaderWithSearchBox(
                size: size,
                userNameStyle: Body.userNameStyle,
                // username: user.fullname,
                fullname: fullname,
                username: username,
              ),
              TitleWithMoreBtn(
                title: "Sellers Post",
                press: () {
                  Navigator.pushNamed(context, 'categorizeList',
                      arguments: 'Clothes');
                },
              ),
              RecommendedItems(
                goodsList: goodsNotifier.goodsAdList,
              ),
              wantsNotifier.wantList.isNotEmpty ? Column(
                children: [
                  TitleWithMoreBtn(title: "Buyers Request", press: () {}),
                  FeaturedItems(
                    listWants: wantsNotifier.wantList,
                  ),
                ],
              ) : Container(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 0.0),
                child: CarouselSlider(
                    aspectRatio: 16 / 7,
                    autoPlay: true,
                    reverse: false,
                    initialPage: 1,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    items: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 16 / 5,
                              child: Image.asset(
                                "assets/images/ad1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                "assets/images/ad3.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                "assets/images/ad2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),

              TitleWithMoreBtn(
                title: "Category",
                press: () {},
              ),
              CategoryList(),
              // TitleWithMoreBtn(title: "What's New", press: () {}),
              // Wrap(
              //   direction: Axis.horizontal,
              //   alignment: WrapAlignment.spaceAround,
              //   children: [
              //     RecommendedItemCard(
              //       tag: 'jdjhsd',
              //       image:
              //           "https://firebasestorage.googleapis.com/v0/b/campus-market-f0309.appspot.com/o/goods%2F%20vRjT4dV118dyuPq2933fSlqMBTR2%2FCharger0?alt=media&token=26b8e162-7361-4642-b69d-3cce6f238d2b",
              //       imgHash: 'L45GU#*HLSOjrKr_XhMxuenSWUR%',
              //       title: "Samantha",
              //       school: "Russia",
              //       price: "440",
              //       press: () {},
              //     ),
              //     RecommendedItemCard(
              //       tag: 'kjdfd',
              //       imgHash: 'L45GU#*HLSOjrKr_XhMxuenSWUR%',
              //       image:
              //           "https://firebasestorage.googleapis.com/v0/b/campus-market-f0309.appspot.com/o/goods%2F%20vRjT4dV118dyuPq2933fSlqMBTR2%2FCharger0?alt=media&token=26b8e162-7361-4642-b69d-3cce6f238d2b",
              //       title: "Samantha",
              //       school: "Russia",
              //       price: "440",
              //       press: () {},
              //     ),
              //     RecommendedItemCard(
              //       image:
              //           "https://firebasestorage.googleapis.com/v0/b/campus-market-f0309.appspot.com/o/goods%2F%20vRjT4dV118dyuPq2933fSlqMBTR2%2FCharger0?alt=media&token=26b8e162-7361-4642-b69d-3cce6f238d2b",
              //       title: "Samantha",
              //       imgHash: 'L45GU#*HLSOjrKr_XhMxuenSWUR%',
              //       tag: 'jjdfjhdf',
              //       school: "Russia",
              //       price: "440",
              //       press: () {},
              //     ),
              //     RecommendedItemCard(
              //       image:
              //           "https://firebasestorage.googleapis.com/v0/b/campus-market-f0309.appspot.com/o/goods%2F%20vRjT4dV118dyuPq2933fSlqMBTR2%2FCharger0?alt=media&token=26b8e162-7361-4642-b69d-3cce6f238d2b",
              //       title: "Samantha",
              //       imgHash: 'L45GU#*HLSOjrKr_XhMxuenSWUR%',
              //       tag: 'jkdjkf',
              //       school: "Russia",
              //       price: "440",
              //       press: () {},
              //     ),
              //   ],
              // ),

              SizedBox(
                height: kDefaultPadding,
              )
            ],
          ),
        ),
      ),
    );
  }
}
