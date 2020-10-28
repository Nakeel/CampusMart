import 'package:campus_mart/Screens/Home/components/recommended_Item_card.dart';
import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

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

    // _pageController.animateToPage(categoryList.indexOf(selectedCatString),
    //     duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
  }

  List<CategorizeItems> listItem = [
    CategorizeItems(),
    CategorizeItems(),
    CategorizeItems(),
  ];

  int selectedCategory = 0;
  String selectedCatString;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  Widget buildGridItem(GoodsAd goodsAdItem) {
    bool liked = false;
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
        Navigator.pushNamed(context, 'item-details', arguments: goodsAdItem);
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

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<CustomUserInfo>(context);

    GoodAdNotifier goodsNotifier = Provider.of<GoodAdNotifier>(context);
    var goodsList = goodsNotifier.goodsAdList
        .where((i) => i.category == selectedCatString)
        .toList();
    print('GoodCat' + goodsList.length.toString());

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
                  children: [
                    

                  ],
                ),
              ),
              ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home),
                // onTap: navigateTo(2),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('Buy'),
                leading: Icon(Icons.home),
                // onTap: navigateTo(0),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('Sell'),
                leading: Icon(Icons.home),
                // onTap: navigateTo(2),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('My Carts'),
                leading: Icon(Icons.home),
              ),
              SizedBox(
                height: 10,
              ),
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
                                  (e) => buildGridItem(
                                      goodsNotifier.goodsAdList[e.key]),
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
                              icon: Icon(Icons.sort, color: Colors.white),
                              onPressed: () {
                                print('drawer Clicked');
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
                          layout: SwiperLayout.STACK,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: listItem,
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
  const CategorizeItems({
    Key key,
  }) : super(key: key);

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
                child: Image(
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/campus-market-f0309.appspot.com/o/goods%2FvRjT4dV118d2933fSlqMBTR2%2FStanding%20fan0?alt=media&token=9c2e9096-90fc-4499-abdf-2ece0ea7470f"),
                  width: 170,
                  height: 220,
                  fit: BoxFit.cover,
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
                      'Name of item',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Location of item',
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
                        'Few Desc of item file Desc of item file Location of item data Location of item',
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
                                '2500.0',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    color: kPrimaryColor,
                                  ),
                                  splashColor: kPrimaryColor,
                                  onPressed: () {})
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
