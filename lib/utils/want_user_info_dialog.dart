import 'dart:async';
import 'dart:io';

import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class WantUserInfoDialogWidget extends StatefulWidget {
  final Wants wantItem;

  WantUserInfoDialogWidget({
    Key key,
    this.wantItem,
  }) : super(key: key);

  @override
  _WantUserInfoDialogWidgetState createState() =>
      _WantUserInfoDialogWidgetState();
}

class _WantUserInfoDialogWidgetState extends State<WantUserInfoDialogWidget> {
  String currentTime = '';
  Timer timer;

  void updateMainContainer() {
    final now = new DateTime.now();

    DateFormat format = DateFormat("kk:mm:ss dd-MMM-yyyy");
    DateTime currentDate = format.parse(widget.wantItem.datePosted);
    final difference = now.difference(currentDate);
    currentTime = timeago.format(now.subtract(difference));
    setState(() {});
  }

  @override
  void initState() {
    timeago.setLocaleMessages('uk', timeago.UkMessages());

    timer = mounted
        ? Timer.periodic(new Duration(seconds: 1), (_) => updateMainContainer())
        : null;
    super.initState();
  }

  @override
  bool get mounted => super.mounted;

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  _launchCaller(String userPhone) async {
    print('PhoneCall ' + userPhone);
    if (await canLaunch('tel:' + userPhone)) {
      await launch('tel:' + userPhone);
    } else {
      print('PhoneCall' + userPhone);
      throw 'Could not launch $userPhone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    )
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Request Owners Info',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600),),

                  SizedBox(
                    height: 10,
                  ),

                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kPrimaryLightColor.withOpacity(0.4),
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.all(
                            //   Radius.circular(63),
                            // ),

                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 60,
                                color: kPrimaryColor.withOpacity(0.3),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: widget.wantItem.userImgUrl != ''
                                ? Image(
                                    image: NetworkImage(
                                        widget.wantItem.userImgUrl),
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.person,
                                    color: kPrimaryColor,
                                    size: 90,
                                  ),
                          )),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.wantItem.fullname,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(widget.wantItem.phone,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('Institution: ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      Expanded(
                        child: Text(widget.wantItem.university,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('Created: ', style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                      Text(currentTime,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _launchCaller(widget.wantItem.phone);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.3),
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.call,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showPicker(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          decoration: BoxDecoration(
                            color: Colors.orange[100].withOpacity(0.7),
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.message,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Positioned(
            //   right: -2,
            //     top: 0,
            //     child: GestureDetector(
            //   onTap: (){
            //     Navigator.pop(context);
            //   },
            //   child: Icon(
            //     Icons.cancel_outlined,
            //     color: Constants.primaryColor,
            //     size: 40,
            //   ),
            // ))
          ],
        ));
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
                      title: new Text('Send text message to user'),
                      onTap: () {
                        launchSmsSeller(
                            phone: widget.wantItem.phone,
                            message:
                            'Hi, I like to make enquiry about your request ad of \"' +
                                widget.wantItem.post +
                                '\" on Campus Mart');
                        Navigator.of(context).pop();
                      }),
                  new Divider(),
                  new ListTile(
                    leading: Image.asset('assets/icons/whatsapp.png',height: 20,width: 20),
                    title: new Text('Chat with user on whatsapp'),
                    onTap: () {
                      launchWhatsApp(
                          phone: widget.wantItem.phone,
                          message:
                          'Hi, I like to make enquiry about your request ad of \"' +
                              widget.wantItem.post +
                              '\" on Campus Mart');
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
