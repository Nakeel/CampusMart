class GoodsAd {
  String uid;
  String university, itemPrice, itemDesc,sellerPhoneNo;

  String fullname, datePosted, category, itemTitle;
  bool isNegotiable, isPromoted, isSold;
  List<dynamic> itemFeatures, itemImgList, itemImgListHash;

  GoodsAd.fromMap(Map<String, dynamic> data) {
    uid = data['uuid'];
    itemPrice = data['itemPrice'];
    itemDesc = data['itemDesc'];
    university = data['university'];
    fullname = data['fullname'];
    isNegotiable = data['isNegotiable'];
    isSold = data['isSold'];
    sellerPhoneNo = data['phone'];
    itemFeatures = data['itemFeatures'];
    itemImgList = data['itemImgList'];
    itemImgListHash = data['itemImgListHash'];
    isPromoted = data['isPromoted'];
    datePosted = data['datePosted'];
    itemTitle = data['itemTitle'];
    category = data['category'];
  }

  
}
