import 'package:campus_mart/Screens/Home/components/category_list.dart';
import 'package:campus_mart/Screens/Home/components/featured_items.dart';
import 'package:campus_mart/Screens/Home/components/header_with_searchbox.dart';
import 'package:campus_mart/Screens/Home/components/recommended_Item_card.dart';
import 'package:campus_mart/Screens/Home/components/recommended_items.dart';
import 'package:campus_mart/Screens/Home/components/title_with_more_btn.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'item_category.dart';

class FavoriteMain extends StatefulWidget {
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<FavoriteMain> {
  String _username;
  int _count = 3;
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUserInfo>(context);
    var goodsList = [];
    GoodAdNotifier goodsNotifier = Provider.of<GoodAdNotifier>(context);
    // goodsList = goodsNotifier.goodsAdList.toList();

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              child: Text(
                'You have $_count items in your favourite list',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            Column(
              children: goodsList
                  .asMap()
                  .entries
                  .map(
                    (e) => FavouriteItems(
                      goodsAd: goodsList[e.key],
                      delete: () {
                        print('delete at' + e.key.toString());
                        setState(() {
                          goodsList.removeAt(e.key);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            // ListView.builder(
            //   itemCount: items.length,
            //   itemBuilder: (context, index) {
            //     final item = items[index];
            //     return FavouriteItems();
            //     //   Dismissible(
            //     //     // Specify the direction to swipe and delete
            //     //     direction: DismissDirection.endToStart,
            //     //     key: Key(item),
            //     //     onDismissed: (direction) {
            //     //       // Removes that item the list on swipwe
            //     //       setState(() {
            //     //         items.removeAt(index);
            //     //       });
            //     //       },
            //     //     background: Container(color: Colors.red),
            //     //     child: FavouriteItems(),
            //     //   );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class FavouriteItems extends StatelessWidget {
  const FavouriteItems({
    Key key,
    @required this.goodsAd,
    this.delete,
  }) : super(key: key);
  final GoodsAd goodsAd;
  final Function delete;

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

    return Stack(children: [
      Container(
        margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        goodsAd.itemTitle,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '\#' + goodsAd.itemPrice,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          goodsAd.isNegotiable
                              ? 'Negotiable'
                              : 'Non Negotiable',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                goodsAd.category,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              // _buildRatingStars(5),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(top: 10.0),
                  //   width: 70.0,
                  //   decoration: BoxDecoration(
                  //     color: kPrimaryLightColor,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: Text('Delete'),
                  // ),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: delete,
                      color: kPrimaryColor,
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))
                  // Container(
                  //   width: 70.0,
                  //   decoration: BoxDecoration(
                  //     color: kPrimaryLightColor,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: Text('Delete'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 20.0,
        top: 15.0,
        bottom: 15.0,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'item-info', arguments: goodsAd);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage(goodsAd.itemImgList[0]),
              width: 110.0,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ]);
  }
}
