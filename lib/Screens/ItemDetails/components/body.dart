import 'dart:io';

import 'package:campus_mart/Screens/ItemDetails/components/image_and_icons.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/reusablewidget/confirm_message_app.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'round_bottom_double_btn.dart';
import 'title_and_price.dart';

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ImageAndIcons(
              size: size,
              goodsAd: goodItem,
            ),
            TitleAndPrice(
              title: goodItem.itemTitle,
              country: goodItem.isNegotiable ? 'Negotiable' : 'Non-Negotiable',
              price: int.parse(goodItem.itemPrice),
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            RoundBottomDoubleButton(
              positiveFunc: () {
                _launchCaller(goodItem.sellerPhoneNo);
              },
              positiveText: "Call Seller",
              negativeFunc: () {
                showPicker(context);
              },
              negativeText: "Chat with",
            ),
            // ColorAndSize(),
          ],
        ),
      ),
    );
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
