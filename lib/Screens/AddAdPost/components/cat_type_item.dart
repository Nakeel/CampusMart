import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class CategoryTypeItem extends StatelessWidget {
  const CategoryTypeItem({
    Key key,
    this.itemSelected,
    this.icon,
  }) : super(key: key);

  final bool itemSelected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: itemSelected ? 70 : 60,
                width: itemSelected ? 70 : 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(50),
                  // ),
                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(3.0, 3.0),
                      blurRadius: itemSelected ? 5.0 : 3.0,
                      spreadRadius: itemSelected ? 2.0 : 1.0,
                      color: kPrimaryColor.withOpacity(0.4),
                    )
                  ],
                  //   image: DecorationImage(
                  //       image: AssetImage("assets/images/img.png"),
                  //       fit: BoxFit.cover,
                  //       alignment: Alignment.centerLeft),
                ),
                child: Icon(
                  Icons.add_to_queue,
                  color: itemSelected ? kPrimaryColor : kPrimaryLightColor,
                  size: itemSelected ? 30 : 25,
                ),
              ),
              Positioned(
                right: 1,
                child: Visibility(
                  visible: itemSelected,
                  child: Icon(
                    Icons.check_circle,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Gadgets',
            style: TextStyle(
                fontSize: 18,
                color: itemSelected ? kPrimaryColor : kPrimaryLightColor,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
