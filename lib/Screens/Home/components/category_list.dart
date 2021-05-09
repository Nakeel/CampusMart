import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

import 'item_category.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: kDefaultPadding),
      child: Row(children: <Widget>[
        ItemCategory(
          press: () {
            Navigator.pushNamed(context, 'categorizeList',
                arguments: 'FootWears');
          },
          catName: "FootWears",
          endColor: Colors.grey[500],
          leadingColor: Colors.grey[200],
          imgdir: 'assets/images/footwear.png',
        ),
        ItemCategory(
          catName: "Gadgets",
          endColor: Colors.grey[500],
          leadingColor: Colors.grey[200],
          imgdir: 'assets/images/gadgets.png',
           press: () {
            Navigator.pushNamed(context, 'categorizeList',
                arguments: 'Gadgets');
          },
        ),
        ItemCategory(
          catName: "Home Appliances",
          endColor: Colors.grey[500],
          leadingColor: Colors.grey[200],
          imgdir: 'assets/images/homeappliances.png',
          press: () {
            Navigator.pushNamed(context, 'categorizeList',
                arguments: 'Home Appliances');
          },
        ),
        ItemCategory(
          catName: "Clothes",
          endColor: Colors.grey[500],
          leadingColor: Colors.grey[200],
          imgdir: 'assets/images/wears.png',
          press: () {
            Navigator.pushNamed(context, 'categorizeList',
                arguments: 'Clothes');
          },
        ),
      ]),
    );
  }
}
