import 'dart:async';

import 'package:campus_mart/Screens/ItemDetails/item_details_screen.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'recommended_Item_card.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({
    Key key,
    @required this.goodsList,
  }) : super(key: key);

  final List<GoodsAd> goodsList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ShowItemList(
        goodsList: goodsList,
      ),
    );
  }
}

class ShowItemList extends StatelessWidget {
  final List<GoodsAd> goodsList;

  const ShowItemList({Key key, this.goodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget itemWidget;
    print('Goods1' + goodsList.toString());

    // Timer timer;
    // timer = Timer(Duration(seconds: 3), () {
      


     if (goodsList.length != 0) {
        return DataList(goodsList);
      } else if (goodsList == null) {
        print('Goods is null');
        return Container(
          height: 40,
        );
      } else {
        return ShimmerList();
      }
    // });

    
  }
}

List<Widget> allItems(List<GoodsAd> goodsList, BuildContext context) {
  print('Goods' + goodsList.toString());

  List<RecommendedItemCard> all = [];
  var dateFormat = DateFormat('kk:mm dd-MMM-yyyy');
  List<GoodsAd> _goodsList = List.from(goodsList);

  // _wantsList = wantsList;

  _goodsList.sort((a, b) =>
      dateFormat.parse(b.datePosted).compareTo(dateFormat.parse(a.datePosted)));
  
  _goodsList.take(5).forEach((goodAdItem) {
    Widget goods = RecommendedItemCard(
      image: goodAdItem.itemImgList[0],
      title: goodAdItem.itemTitle,
      school: goodAdItem.university,
      price: goodAdItem.itemPrice,
      tag: goodAdItem.itemTitle+goodAdItem.datePosted,
      imgHash: goodAdItem.itemImgListHash[0],
      press: () {
        Navigator.pushNamed(context, 'item-details',
                      arguments: goodAdItem);
        //     MaterialPageRoute(builder: (context) => ItemDetailsScreen()));
      },
    );
    all.add(goods);
  });

  return all;
}



class DataList extends StatelessWidget {
  final List<GoodsAd> goodsList;
  DataList(this.goodsList);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: allItems(goodsList, context),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //     itemCount: 3,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Padding(
    //         padding: EdgeInsets.symmetric(vertical: 15),
    //         child: Shimmer.fromColors(
    //             child: ShimmerLayout(),
    //             baseColor: Colors.grey[300],
    //             highlightColor: kPrimaryColor.withOpacity(0.3)),
    //       );
    //     });
    return Shimmer.fromColors(
        child: ShimmerLayout(),
        baseColor: Colors.grey[300],
        highlightColor: kPrimaryColor.withOpacity(0.3));
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Row(children: <Widget>[
        RecommendedShimmerItem(),
        RecommendedShimmerItem(),
        RecommendedShimmerItem()
      ]),
    );
  }
}

class RecommendedShimmerItem extends StatelessWidget {
  const RecommendedShimmerItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            width: size.width,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.all(kDefaultPadding / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 5,
                  width: size.width,
                  color: Colors.grey,
                ),
                SizedBox(height: 5),
                Container(
                  height: 5,
                  width: size.width * 0.5,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
