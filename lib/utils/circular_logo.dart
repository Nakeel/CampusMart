import 'package:flutter/material.dart';

import '../constants.dart';

class CircularLogoItem extends StatelessWidget {
  const CircularLogoItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kPrimaryColor,
      radius: 50.0,
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
