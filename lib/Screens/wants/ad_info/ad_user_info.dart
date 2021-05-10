import 'dart:io';

import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/reusablewidget/confirm_message_app.dart';
import 'package:campus_mart/utils/expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:url_launcher/url_launcher.dart';

class AdUserInfo extends StatefulWidget {
  static const String tag = "adUserInfo";
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");
  final Wants want;

  AdUserInfo({Key key, @required this.want}) : super(key: key);

  @override
  _AdUserInfoState createState() => _AdUserInfoState();
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

class _AdUserInfoState extends State<AdUserInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        color: kPrimaryColor.withOpacity(0.2),
        child: Stack(
          children: [
            Container(
              height: size.height * 0.15,
              width: size.width,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: kPrimaryColor,
                          size: 34.0,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        }),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Text(
                        'User Info',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.6,
                width: size.width,
                padding: EdgeInsets.fromLTRB(10, 130, 10, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.want.fullname,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: UnconstrainedBox(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.3),
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.map,
                                color: kPrimaryColor,
                              ),
                              Text(
                                widget.want.university,
                                style: TextStyle(
                                    fontSize: 12, color: kPrimaryColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchCaller(widget.want.phone);
                            // _launchCaller('2349025179651');
                            
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
                            print('PhoneCall' + widget.want.phone);
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmMessageAppDialog(
                                   primaryButtonText: 'Close',
                                  primaryButtonFunc: () {
                                    launchWhatsApp(
                                        phone: widget.want.phone, message: 'Hi, I like to make enquiry about your ad of '+widget.want.post + ' on Campus Martet');
                                    Navigator.of(context).pop();
                                  },
                                  secButtonFunc: () {
                                    launchSmsSeller(
                                        phone: widget.want.phone, message: 'Hi, I like to make enquiry about your ad of '+widget.want.post + ' on Campus Martet');
                                    Navigator.of(context).pop();
                                  }
                                  ),
                            );
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
                // ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.5,
              left: size.width * 0.15,
              child: Container(
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
                  //   image: DecorationImage(
                  //       image: AssetImage("assets/images/img.png"),
                  //       fit: BoxFit.cover,
                  //       alignment: Alignment.centerLeft),
                ),
                child: Hero(
                  tag: widget.want.datePosted,
                  // transitionOnUserGestures: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(250),
                    child: widget.want.userImgUrl != '' ? Image(
                      image: NetworkImage(
                          widget.want.userImgUrl),
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                    ) : Icon(
                      Icons.person,
                      color: kPrimaryColor,
                      size: 240,
                    ),
                    // BlurHash(
                    //         color: Colors.blueGrey[100],
                    //         hash: '',
                    //         image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    //         imageFit: BoxFit.cover,
                    //         duration: Duration(seconds: 5),
                    //         curve: Curves.easeOut,
                    //       ),
                    
                    
                  ),
                ),
              ),
            ),
          ],
        ),
        // SingleChildScrollView(
        //   child: Column(
        //     children: [
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
