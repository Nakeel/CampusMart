import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  int resultCount = 0;
  String query = '';
  TextEditingController _controller = TextEditingController();
  int selectedSortBy = 0;
  String selectedSortByString = sortByTypeList[0];
  bool _isSearchActive = false;
    bool liked = false;

  Widget buildSortBy(int index, BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedSortBy = index;
            selectedSortByString = sortByTypeList[index];

            drawerKey.currentState.openEndDrawer();
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
                Text(sortByTypeList[index],
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var goodsList = [];
    GoodAdNotifier goodsNotifier = Provider.of<GoodAdNotifier>(context);

    WantsNotifier wantsNotifier = Provider.of<WantsNotifier>(context);
    List<Wants> wantList = [];

    if (_isSearchActive && query != '') {
      if (selectedSortByString == sortByTypeList[0]) {
        goodsList = (query != '')
            ? goodsNotifier.goodsAdList
                .where((i) =>
                    i.itemTitle.toLowerCase().contains(query.toLowerCase()))
                .toList()
            : goodsNotifier.goodsAdList;
      } else {
        wantList = (query.length >= 3)
            ? wantsNotifier.wantList
                .where(
                    (i) => i.post.toLowerCase().contains(query.toLowerCase()))
                .toList()
            : wantsNotifier.wantList;
      }
    }

    return Scaffold(
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
                      'Search By',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    )),
                  ],
                ),
              ),
              Column(
                children: sortByTypeList
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
        body: SafeArea(
            child: Container(
                height: size.height,
                width: size.width,
                color: Colors.white,
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                       Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              Container(
                                width: size.width * 0.7,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Hero(
                                  tag: 'search',
                                  transitionOnUserGestures: true,
                                  child: Container(
                                    alignment: Alignment.center,
                                    // margin: EdgeInsets.symmetric(
                                    //     horizontal: kDefaultPadding),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding),
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 10),
                                          blurRadius: 50,
                                          color:
                                              kPrimaryColor.withOpacity(0.23),
                                        )
                                      ],
                                    ),

                                    child: Material(
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              controller: _controller,
                                              autofocus: true,
                                              onChanged: (value) {
                                                // if (value.length != 1) {
                                                setState(() {
                                                  query = value;
                                                  _isSearchActive = true;
                                                });
                                                // }
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Search",
                                                hintStyle: TextStyle(
                                                  fontSize: 18,
                                                  color: kPrimaryColor
                                                      .withOpacity(0.5),
                                                ),

                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                // suffixIcon: SvgPicture.asset("assets/images/search.svg"),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                              child: Icon(
                                                Icons.close,
                                                color: kPrimaryColor
                                                    .withOpacity(0.5),
                                              ),
                                              splashColor: kPrimaryColor
                                                  .withOpacity(0.9),
                                              onTap: () {
                                                _controller.clear();
                                                setState(() {
                                                  query = '';
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.sort_sharp),
                                  onPressed: () {
                                    drawerKey.currentState.openEndDrawer();
                                  }),
                            ],
                          ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 30, 20, 5),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  'Search Result : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                Text(
                                  (selectedSortByString == sortByTypeList[0])
                                      ? goodsList.length.toString()
                                      : wantList.length.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (selectedSortByString == sortByTypeList[1])
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: allItems(wantList),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                color: Colors.white,
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
                                )),
                      ],
                    ),
                  ),
                ]))));
  }

  List<Widget> allItems(List<Wants> wantsList) {
    List<WantItems> all = [];
    var dateFormat = DateFormat('kk:mm:ss dd-MMM-yyyy');
    List<Wants> _wantsList = List.from(wantsList);

    // _wantsList = wantsList;

    _wantsList.sort((a, b) => dateFormat
        .parse(b.datePosted)
        .compareTo(dateFormat.parse(a.datePosted)));
    _wantsList.forEach((wantItem) {
      // print("ColorId "+ wantItem.colorId);
      Widget want = WantItems(
          press: () {
            Navigator.pushNamed(context, 'adUserInfo', arguments: wantItem);
          },
          postBgColor: Color(int.parse(wantItem.colorId)),

          // postBgColor: kPrimaryColor,

          postDate: wantItem.datePosted,
          postText: wantItem.post,
          userImgUrl: wantItem.userImgUrl,
          userLocation: wantItem.university,
          userName: wantItem.fullname);
      all.add(want);
    });

    return all;
  }
}
