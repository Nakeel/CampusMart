import 'package:campus_mart/Screens/ItemDetails/components/body.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  static const String tag = "item-details";
  final GoodsAd goodItem;

  const ItemDetailsScreen({Key key, @required this.goodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(goodItem: goodItem,),
    );
  }
}
