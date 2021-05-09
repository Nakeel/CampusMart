import 'dart:async';

import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// import 'item_category.dart';

class CategorizeList extends StatefulWidget {
  static const String tag = 'categorizeList';
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  final String category;

  const CategorizeList({Key key, this.category}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<CategorizeList> {
  // int _initPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    selectedCatString = widget.category;
    selectedCategory = categoryList.indexOf(selectedCatString);
    Timer(Duration(milliseconds: 200), () {
      _pageController.animateToPage(categoryList.indexOf(selectedCatString),
          duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
    });
  }

  List<GoodsAd> featuredItems = [];

  int selectedCategory = 0;

  int selectedSortBy = 0;
  String selectedSortByString;
  String selectedCatString;
  bool liked = false;
  bool _isLiked = false;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  Widget buildGridItem(GoodsAd goodsAdItem) {
    return GridItem(
      isLikedPressed: liked,
      tag: goodsAdItem.itemTitle + goodsAdItem.datePosted,
      image: goodsAdItem.itemImgList[0],
      title: goodsAdItem.itemTitle,
      school: goodsAdItem.university,
      price: goodsAdItem.itemPrice,
      likePressed: () {
        setState(() {
          liked = !liked;
        });
        print('liked' + liked.toString());
      },
      press: () {
        Navigator.pushNamed(context, 'item-info', arguments: goodsAdItem);
      },
    );
  }

  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
                selectedCatString = categoryList[index];
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.bounceInOut);
              });
            },
            child: Text(categoryList[index],
                style: TextStyle(
                    color: index == selectedCategory
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.4),
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: index == selectedCategory
                    ? kPrimaryColor
                    : Colors.transparent),
          )
        ],
      ),
    );
  }

  Widget buildSortBy(int index, BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedSortBy = index;
            selectedSortByString = sortByList[index];
          });
        },
        child: Container(
          color:
              index == selectedSortBy ? Colors.grey[100] : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sortByList[index],
                    style: TextStyle(
                        color: index == selectedSortBy
                            ? kPrimaryColor
                            : kPrimaryColor.withOpacity(0.4),
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                Visibility(
                    visible: index == selectedSortBy,
                    child: Icon(
                      Icons.check,
                      color: kPrimaryColor,
                    ))
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<CustomUserInfo>(context);
    var goodsList = [];
    GoodAdNotifier goodsNotifier = Provider.of<GoodAdNotifier>(context);
    print('GoodCat' + goodsList.length.toString() + selectedCatString);


    goodsList = goodsNotifier.goodsAdList
        .where((i) => i.category == selectedCatString)
        .toList();

    if (selectedSortByString == sortByList[1]) {
      goodsList.sort(
          (a, b) => int.parse(b.itemPrice).compareTo(int.parse(a.itemPrice)));
    }
    if (selectedSortByString == sortByList[0]) {
      goodsList.sort(
          (a, b) => int.parse(a.itemPrice).compareTo(int.parse(b.itemPrice)));
    }

    if (selectedSortByString == sortByList[2]) {
      goodsList.sort(
          (a, b) => int.parse(a.itemPrice).compareTo(int.parse(b.itemPrice)));
    }
    if (selectedSortByString == sortByList[3]) {
      goodsList.sort(
          (a, b) => int.parse(b.itemPrice).compareTo(int.parse(a.itemPrice)));
    }
    if (selectedSortByString == sortByList[4]) {
      goodsList.sort(
          (a, b) => int.parse(a.itemPrice).compareTo(int.parse(b.itemPrice)));
    }
    if (selectedSortByString == sortByList[5]) {
      goodsList.sort(
          (a, b) => int.parse(a.itemPrice).compareTo(int.parse(b.itemPrice)));
    }

    
    var dateFormat = DateFormat('kk:mm dd-MMM-yyyy');
    featuredItems = List.from(goodsNotifier.goodsAdList);

  // _wantsList = wantsList;

  // featuredItems.sort((a, b) =>
  //     dateFormat.parse(b.datePosted).compareTo(dateFormat.parse(a.datePosted)));

    print('GoodCat' + goodsList.length.toString() + selectedCatString);

    Size size = MediaQuery.of(context).size;
    // selectedCategory =
    Orientation orientation = MediaQuery.of(context).orientation;
    return MaterialApp(
      home: Scaffold(
        key: drawerKey,
        endDrawer: Drawer(
          child: ListView(
            children: [
              Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          drawerKey.currentState.openEndDrawer();
                        }),
                    SizedBox(
                      width: 30,
                    ),
                    Center(
                        child: Text(
                      'Sort By',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    )),
                  ],
                ),
              ),
              Column(
                children: sortByList
                    .asMap()
                    .entries
                    .map(
                      (e) => buildSortBy(e.key, context),
                    )
                    .toList(),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            height: size.height * 1.5,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        flex: 25,
                        child: PageView(
                          pageSnapping: false,
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (index) {},
                          children: categoryImgAsset
                              .asMap()
                              .entries
                              .map((e) => buildCatImage(e))
                              .toList(),
                        )),
                    SizedBox(height: 5,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 170, 5, 10),
                        color: Colors.white,
                        child: Column(children: [
                          Container(
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) =>
                                    buildCategory(index, context)),
                          ),
                          Expanded(
                              child: GridView.count(
                            // physics: ScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            padding: const EdgeInsets.all(4.0),
                            mainAxisSpacing: 0.5,
                            crossAxisSpacing: 4.0,
                            children: goodsList
                                .asMap()
                                .entries
                                .map(
                                  (e) => buildGridItem(goodsList[e.key]),
                                )
                                .toList(),
                          ))
                        ]),
                      ),
                      flex: 85,
                    )
                  ],
                ),
                Positioned(
                  top: 35,
                  child: Container(
                    width: size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          IconButton(
                              icon: Icon(Icons.sort,
                                  color: Colors.white, size: 40),
                              onPressed: () {
                                drawerKey.currentState.openEndDrawer();
                              }),
                        ]),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 20,
                  child: Container(
                    width: size.width - 2 * 18,
                    child: Column(
                      children: [
                        Container(
                          width: size.width - 2 * 17,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Featured',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Swiper(
                          itemCount: 3,
                          itemWidth: size.width - 2 * 16,
                          itemHeight: 280,
                          viewportFraction: 0.5,
                          layout: SwiperLayout.TINDER,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: featuredItems
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) => CategorizeItems(good: featuredItems[e.key],isLiked: _isLiked, isLikedPressed: (){
                                            setState(() {
                                              _isLiked = !_isLiked;
                                            });
                                          },
                                          itemClicked: (){
                                            Navigator.pushNamed(context, 'item-info', arguments: featuredItems[e.key]);
                                          },
                                          ),
                                        ).take(3)
                                        .toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Image buildCatImage(MapEntry<int, String> e) {
    return Image.asset(
      categoryImgAsset[e.key],
      fit: BoxFit.cover,
      height: 200,
    );
  }
}

class CategorizeItems extends StatelessWidget {
  const CategorizeItems({Key key, this.good, this.isLiked, this.isLikedPressed, this.itemClicked})
      : super(key: key);

  final GoodsAd good;
  final bool isLiked;
  final Function isLikedPressed, itemClicked;

  @override
  Widget build(BuildContext context) {
    Text _buildRatingStars(int rating) {
      String stars = '';
      for (int i = 0; i < rating; i++) {
        stars += '⭐ ';
      }
      stars.trim;
      return Text(stars);
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 220,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 6),
                blurRadius: 5,
                color: kPrimaryColor.withOpacity(0.1),
              )
            ]),
        child: Row(
          children: [
            Expanded(
              flex: 11,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10.0)),
                child: InkWell(
                  onTap: itemClicked,
                  child: Image(
                    image: NetworkImage(
                      good.itemImgList[0],
                    ),
                    width: 170,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      good.itemTitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      good.university,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    // SizedBox(
                    //   height: 7,
                    // ),
                    Container(
                      child: Text(
                        good.itemDesc,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                good.itemPrice,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                              IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite_outline
                                        : Icons.favorite,
                                    color: kPrimaryColor,
                                  ),
                                  splashColor: kPrimaryColor,
                                  onPressed: isLikedPressed)
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
