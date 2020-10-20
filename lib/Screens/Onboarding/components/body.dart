import 'package:campus_mart/components/round_button.dart';
import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class Body extends StatefulWidget {
  static const TextStyle appNameStyle = TextStyle(
      color: Colors.grey,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");
  static const TextStyle greyStyle = TextStyle(
      color: Colors.grey,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");
  static const TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle appNameStyleWhite = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle descStyleWhite = TextStyle(
      color: Colors.grey,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");
  static const TextStyle desHeaderStyleWhite = TextStyle(
      color: Colors.white,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle infoStyle = TextStyle(
      color: Colors.grey,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle infoStyleWhite = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool showGetStartedBtn = false;
  double pos_t;
  double pos_b;

  final pages = [
    Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Positioned(
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Campus Mart",
                    style: Body.appNameStyle,
                  ),
                  Text(
                    "Skip",
                    style: Body.appNameStyle,
                  ),
                ],
              ),
            ),
          ),
          Image.asset("assets/images/buy.png"),
          Column(
            children: <Widget>[
              Text(
                "Online",
                style: Body.greyStyle,
              ),
              Text(
                "Gambling",
                style: Body.boldStyle,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "A nice app to enjoy and \nearn seamlessly",
                  style: Body.infoStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: Color(0xFF55006c),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Campus Mart",
                  style: Body.appNameStyleWhite,
                ),
                Text(
                  "Skip",
                  style: Body.appNameStyleWhite,
                ),
              ],
            ),
          ),
          Image.asset("assets/images/shop.png"),
          Column(
            children: <Widget>[
              Text(
                "Awesome",
                style: Body.desHeaderStyleWhite,
              ),
              Text(
                "Community",
                style: Body.descStyleWhite,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "A nice app to enjoy and \nearn seamlessly",
                  style: Body.infoStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: Color(0xFFfc016c),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Campus Mart",
                  style: Body.appNameStyleWhite,
                ),
                Text(
                  "Skip",
                  style: Body.appNameStyleWhite,
                ),
              ],
            ),
          ),
          Image.asset("assets/images/sell.png"),
          Column(
            children: <Widget>[
              Text(
                "Online",
                style: Body.descStyleWhite,
              ),
              Text(
                "Gaming",
                style: Body.desHeaderStyleWhite,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "A nice app to enjoy and \nearn seamlessly",
                  style: Body.infoStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //provide screen size
    return Stack(
      children: <Widget>[
        LiquidSwipe(
          pages: pages,
          enableLoop: false,
          enableSlideIcon: false,
          fullTransitionValue: 300,
          waveType: WaveType.liquidReveal,
          positionSlideIcon: 0.7,
          onPageChangeCallback: (activePageIndex) {
            setState(() {
              if (activePageIndex != 2) {
                pos_t = size.width * 0.6;
                showGetStartedBtn = false;
              } else {
                showGetStartedBtn = true;
                pos_t = size.width * 0.3;
              }
            });
          },
        ),
        // SizedBox(
        //   height: size.height * 0.05,
        // ),
        Visibility(
          visible: showGetStartedBtn,
          child: AnimatedPositioned(
            bottom: 10,
            left: pos_t,
            duration: Duration(milliseconds: 1000),
            child: RoundedButton(
              text: "Get Started",
              textColor: Colors.white,
              press: () {
                Navigator.pushNamed(context, "welcome");
              },
            ),
          ),
        )
      ],
    );
  }
}
