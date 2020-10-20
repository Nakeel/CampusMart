import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService();

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference wantsCollection =
      FirebaseFirestore.instance.collection('wants');

  final CollectionReference goodPostCollection =
      FirebaseFirestore.instance.collection('goods');

  Future updateUserData(String fullname, String username, String email,
      String phone, String university, String uid) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'university': university,
      'totalSalesAd': 0,
      'uuid': uid,
      'totalWantsAd': 0
    });
  }

  Future updateUserSalesAdData(String uid) async {
    return await userCollection
        .doc(uid)
        .update({'totalSalesAd': FieldValue.increment(1)});
  }

  Future updateUserWantsAdData(String uid) async {
    return await userCollection
        .doc(uid)
        .update({'totalWantsAd': FieldValue.increment(1)});
  }

  Future saveWantData(
      String fullname,
      String uuid,
      String university,
      String colorId,
      String datePosted,
      String post,
      String category,
      bool isBought,
      bool isPromoted) async {
    await wantsCollection.doc(uuid).set({
      datePosted: {
        'fullname': fullname,
        'uuid': uuid,
        'university': university,
        'post': post,
        'colorId': colorId,
        'datePosted': datePosted,
        'category': category,
        'isBought': isBought,
        'isPromoted': isPromoted
      }
    }, SetOptions(merge: true)).then((value) {
      print('firebase success');
      return value;
    }).catchError((onError) {
      print('firebase failed' + onError.toString());
      return 'Failed';
    });
  }

  Future postGoodsData(
      String fullname,
      String uuid,
      String university,
      String itemTitle,
      String datePosted,
      String itemDesc,
      String category,
      String itemPrice,
      String phone,
      bool isNegotiable,
      List<String> itemImgList,
      List<String> itemFeatures,
      bool isSold,
      bool isPromoted) async {
    await goodPostCollection.doc(uuid).set({
      datePosted: {
        'fullname': fullname,
        'uuid': uuid,
        'university': university,
        'itemTitle': itemTitle,
        'itemDesc': itemDesc,
        'itemFeatures': itemFeatures,
        'category': category,
        'itemPrice': itemPrice,
        'phone': phone,
        'itemImgList': itemImgList,
        'isNegotiable': isNegotiable,
        'datePosted': datePosted,
        'isSold': isSold,
        'isPromoted': isPromoted
      }
    }, SetOptions(merge: true)).then((value) {
      print('firebase success');
      return value;
    }).catchError((onError) {
      print('firebase failed' + onError.toString());
      return 'Failed';
    });
  }

  //user stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  getWants(WantsNotifier wantNotifier) async {
    QuerySnapshot wantsDoc = await wantsCollection.get();
    List<Wants> _wantList = [];

    wantsDoc.docs.forEach((doc) {
      Map<String, dynamic> listWantsData = doc.data();
      print("Wants " + listWantsData.length.toString());
      var listWants = listWantsData.values.toList();
      listWants.forEach((wantItem) {
        print("Wants2 " + wantItem.length.toString());
        Wants want = Wants.fromMap(wantItem);
        _wantList.add(want);
      });
    });
    print("Wants3 " + _wantList.length.toString());
    wantNotifier.wantList = _wantList;
  }

  getGoodAds(GoodAdNotifier goodAdNotifier) async {
    QuerySnapshot goodAdsDoc = await goodPostCollection.get();
    List<GoodsAd> _goodAdList = [];

    goodAdsDoc.docs.forEach((doc) {
      Map<String, dynamic> listGoodAdsData = doc.data();
      print("GoodAds " + listGoodAdsData.length.toString());
      var listWants = listGoodAdsData.values.toList();
      listWants.forEach((goodAdItem) {
        print("goodAd2 " + goodAdItem.length.toString());
        GoodsAd goodAd = GoodsAd.fromMap(goodAdItem);
        _goodAdList.add(goodAd);
      });
    });
    print("goodAds3 " + _goodAdList.length.toString());
    goodAdNotifier.goodsAdList = _goodAdList;
  }

//user data from snapshot
  CustomUserInfo _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return CustomUserInfo.fromMap(snapshot.data());
  }

  //user stream
  Stream<CustomUserInfo> userData(String uid) {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapShot);
  }
}
