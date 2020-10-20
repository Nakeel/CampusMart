import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class InitialsDot extends StatelessWidget {
  final String initials;
  const InitialsDot({
    Key key, this.initials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: kDefaultPadding / 4,
        right: kDefaultPadding / 2,
      ),
      padding: EdgeInsets.all(2.5),
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: AutoSizeText(
            initials,
            maxFontSize: 20,
            minFontSize: 11,
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 20
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
