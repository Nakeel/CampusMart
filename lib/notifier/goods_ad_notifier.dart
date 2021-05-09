import 'dart:collection';

import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:flutter/cupertino.dart';

class GoodAdNotifier with ChangeNotifier {
  List<GoodsAd> _goodsAdList = [];
  GoodsAd _currentgoodsAd;

  UnmodifiableListView<GoodsAd> get goodsAdList => UnmodifiableListView(_goodsAdList);

  GoodsAd get currentGoods => _currentgoodsAd;

  set goodsAdList(List<GoodsAd> goodsAdList) {
    _goodsAdList = goodsAdList;
    notifyListeners();
  }

  set currentGood(GoodsAd goodsAds) {
    _currentgoodsAd = goodsAds;
    notifyListeners();
  }
}
