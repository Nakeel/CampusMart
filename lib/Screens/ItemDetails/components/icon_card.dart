import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconCard extends StatefulWidget {
  IconCard({
    this.icon,
    this.pressed,
    this.isActive,
  }) : super();

  final String icon;
  final Function pressed;
  bool isActive;

  @override
  _IconCardState createState() => _IconCardState();
}

class _IconCardState extends State<IconCard> {
  

  @override
  Widget build(BuildContext context) {
    print('here ${widget.isActive}');
    Size size = MediaQuery.of(context).size;
    return
     Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
      padding: EdgeInsets.all(kDefaultPadding / 2),
      height: 62,
      width: 62,
      decoration: BoxDecoration(
        color: widget.isActive ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 15),
            blurRadius: 22,
            color: kPrimaryColor.withOpacity(0.22),
          ),
          BoxShadow(
            offset: Offset(-15, -15),
            blurRadius: 20,
            color: Colors.white,
          ),
        ],
      ),
      child: SvgPicture.asset(widget.icon),
    );
  }
}
