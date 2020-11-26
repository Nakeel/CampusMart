import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class MenuTileWidget extends StatelessWidget {
  const MenuTileWidget({
    Key key,
    this.press,
    this.selectedIndex,
    this.index, this.icon, this.title,
  }) : super(key: key);
  final Function press;
  final int selectedIndex;
  final int index;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      splashColor: kPrimaryColor,
      child: Container(
          height: 60,
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: selectedIndex==index ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
          child: Row(
            children: [
              Icon(icon, 
              color: selectedIndex==index ? kPrimaryColor : Colors.grey[800]),
              SizedBox(
                width: 30,
              ),
              Text(
                title,
                style: TextStyle(
                    color: selectedIndex==index ? kPrimaryColor : Colors.grey[800],
                    fontSize: 16,
                    fontWeight: selectedIndex==index ?  FontWeight.w700 : FontWeight.w400),
              ),
            ],
          )),
    );
  }
}
