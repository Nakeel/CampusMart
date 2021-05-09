import 'dart:io';

import 'package:campus_mart/Screens/ItemDetails/components/image_and_icons.dart';
import 'package:campus_mart/Screens/ItemDetails/components/item_img_widget.dart';
import 'package:campus_mart/Screens/ItemDetails/components/title_and_price.dart';
import 'package:campus_mart/Screens/itemInfo/components/round_bottom_double_btn.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/utils/color_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatelessWidget {
  final GoodsAd goodItem;

  _launchCaller(String userPhone) async {
    print('PhoneCall ' + userPhone);
    if (await canLaunch('tel:' + userPhone)) {
      await launch('tel:' + userPhone);
    } else {
      print('PhoneCall' + userPhone);
      throw 'Could not launch $userPhone';
    }
  }

  void launchSmsSeller({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return 'sms:$phone&body=$message';
      } else {
        return 'sms:+234$phone?body=$message';
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ';
    }
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/+234$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=+234$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ';
    }
  }

  const Body({Key key, @required this.goodItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('GoodsNew' + goodItem.itemImgList[0]);
    return
      // SafeArea(
      //   child:
        Container(
            height: size.height,
            width: size.width,
            child: Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: size.height * 0.4,
                      width: size.width,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            child: Container(
                                height: size.height * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ItemImgWidget(itemImgList: goodItem)),
                          ),
                          Positioned(
                            top: 35,
                            left: 3,
                            child: IconButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding),
                                icon: SvgPicture.asset(
                                    "assets/icons/back_arrow.svg"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width,
                      // child: 
                      // Flexible(
                      //     child: Container(
                            margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            TitleAndPrice(
                              price: int.parse(goodItem.itemPrice),
                              title: goodItem.itemTitle,
                              country: goodItem.isNegotiable
                                  ? 'Negotiable'
                                  : 'Non Negotiable',
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: 
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, bottom: 10),
                                      child: Text(
                                        'ITEM INFO',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ),
                                    ),
                                Container(
                                  width: size.width * 0.83,
                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(-2.5, 3.0),
                                        blurRadius: 1.5,
                                        spreadRadius: 1.5,
                                        color: kPrimaryColor.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    goodItem.itemDesc,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: 
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, bottom: 10),
                                      child: Text(
                                        'ITEM FEATURES',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    ),
                                Container(
                                  width: size.width * 0.83,
                                  margin: EdgeInsets.only(bottom: 100),
                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(-2.5, 3.0),
                                        blurRadius: 1.5,
                                        spreadRadius: 1.5,
                                        color: kPrimaryColor.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: goodItem.itemFeatures
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) => ItemFeatureWidget(
                                              itemDesc: e.value),
                                        )
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      // )
                      // ),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, -2.0),
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          color: kPrimaryColor.withOpacity(0.2),
                        )
                      ],
                    ),
                    child: RoundBottomDoubleButton(
                      positiveFunc: () {
                        _launchCaller(goodItem.sellerPhoneNo);
                      },
                      positiveText: "Call Seller",
                      negativeFunc: () {
                        showPicker(context);
                      },
                      negativeText: "Chat with",
                    ),
                  )),
            ]))
    // )
    ;
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.message,
                        color: kPrimaryColor,
                      ),
                      title: new Text('Send text message to seller'),
                      onTap: () {
                        launchSmsSeller(
                            phone: goodItem.sellerPhoneNo,
                            message:
                                'Hi, I like to make enquiry about your ad of ' +
                                    goodItem.itemTitle +
                                    ' on Campus Mart');
                        Navigator.of(context).pop();
                      }),
                  new Divider(),
                  new ListTile(
                    leading: Image.asset('assets/icons/whatsapp.png',height: 20,width: 20),
                    title: new Text('Chat with seller on whatsapp'),
                    onTap: () {
                      launchWhatsApp(
                          phone: goodItem.sellerPhoneNo,
                          message:
                              'Hi, I like to make enquiry about your ad of ' +
                                  goodItem.itemTitle +
                                  ' on Campus Mart');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ItemFeatureWidget extends StatelessWidget {
  const ItemFeatureWidget({
    Key key,
    this.itemDesc,
  }) : super(key: key);

  final String itemDesc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(2.5),
            height: 14,
            width: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Flexible(
            child: Text(
              itemDesc,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
