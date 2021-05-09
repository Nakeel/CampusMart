import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class ItemInfoScreen extends StatelessWidget {
  static const String tag = "item-info";
  final GoodsAd goodItem;

  const ItemInfoScreen({Key key, @required this.goodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        goodItem: goodItem,
      ),
    );
  }
}
