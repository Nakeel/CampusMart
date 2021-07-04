
import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/info_dialog.dart';
import 'package:campus_mart/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String selectedPopup;
  GoodAdNotifier goodsNotifier;
  UserData user;

  List<GoodsAd> goodsList;


  Widget buildGridItem(GoodsAd goodsAdItem, int index) {
    return GridItem(
      isLikedPressed: liked,
      tag: goodsAdItem.itemTitle + goodsAdItem.datePosted,
      image: goodsAdItem.itemImgList[0],
      title: goodsAdItem.itemTitle,
      school: goodsAdItem.university,
      price: goodsAdItem.itemPrice,
      myAds: true,
      views: '9',
      moreOptionPressed: (item){
        print("More pressed");
        _showDeleteCautionDialog(index, goodsAdItem.uid);
      },
      press: () {
        },
    );
  }

  showPopMenu(){
  }

  _showInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => InfoDialogWidget(
            title: 'Manage Posted Ads',
            description:
            'View how all your ads posted are been interacted with and also delete older ads',
            primaryButtonText: 'Close',
            infoType: RouteConstant.MY_ADs,
            infoIcon: 'assets/icons/onlineadvertising.png',
            primaryButtonFunc: () {
              Navigator.of(context).pop();
            }));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getGoodsAd();
      Future.delayed(Duration(seconds: 1), () => isShowDialogAgain());
      // getUserData();
    });
    super.initState();
  }

  getGoodsAd() async {
    GoodAdNotifier goodsNotifiers = Provider.of<GoodAdNotifier>(context, listen: false);
    await DatabaseService().getGoodAdsById(goodsNotifiers, user.uid);
    goodsList = goodsNotifiers.goodsAdListById.toList();
    print('Goodstt ${goodsList.length}');
    setState(() {
    });
  }


  isShowDialogAgain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(RouteConstant.MY_ADs) ?? true
        ? _showInfoDialog(context)
        : null;
  }

  _showDeleteCautionDialog(int index, String uid){
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
          title: 'Delete Request',
          description:
          'Are you sure? \n NB. Operation is not reversible',
          primaryButtonText: 'Yes',
          secButtonTxt: 'No',
          secButtonFunc: (){
            Navigator.of(context).pop();
          },
          primaryButtonFunc: () {
            print('Index $index goodSize ${goodsList.length}');
            setState(() {
              goodsList.removeAt(index);
            });

            print('Ind $index goodSize ${goodsList.length}');
            DatabaseService().deleteAd(uid);
                // .then((value) =>
                // DatabaseService().getGoodAdsById(goodsNotifier));
            Navigator.of(context).pop();
          }),
    );
  }


  @override
  Widget build(BuildContext context) {

    goodsNotifier = Provider.of<GoodAdNotifier>(context);
    user = Provider.of<UserData>(context);
    Size size = MediaQuery
        .of(context)
        .size;

    // if (_isSearchActive && query != '') {
    //   if (selectedSortByString == sortByTypeList[0]) {
    //     goodsList = (query != '')
    //         ? goodsNotifier.goodsAdList
    //         .where((i) =>
    //         i.itemTitle.toLowerCase().contains(query.toLowerCase()))
    //         .toList()
    //         : goodsNotifier.goodsAdList;
    //   } else {
    //     wantList = (query.length >= 3)
    //         ? wantsNotifier.wantList
    //         .where(
    //             (i) => i.post.toLowerCase().contains(query.toLowerCase()))
    //         .toList()
    //         : wantsNotifier.wantList;
    //   }
    // }

    return Scaffold(
        key: drawerKey,
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
                                icon: Icon(Icons.arrow_back, size: 40,),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  'Ads Posted',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 38),
                                ),
                                // Text(
                                //   (selectedSortByString == sortByTypeList[0])
                                //       ? goodsList.length.toString()
                                //       : wantList.length.toString(),
                                //   style: TextStyle(fontSize: 16),
                                // ),
                              ],
                            ),
                          ),
                        ),

                        goodsList==null ? Container(
                          width: size.width,
                          height: size.height * .8,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ) : goodsList.isNotEmpty ?
                        Container(
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
                                    (e) => buildGridItem(goodsList[e.key], e.key),
                              )
                                  .toList(),
                            )) : Container(
                          width: size.width,
                          height: size.height * .8,
                          child: Center(
                            child: Text('You have no new ads'),
                          ),
                        ),
                      ],
                    ),
                  )
                ]))));
  }
}
