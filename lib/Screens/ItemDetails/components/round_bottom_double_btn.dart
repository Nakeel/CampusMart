import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class RoundBottomDoubleButton extends StatelessWidget {
  const RoundBottomDoubleButton({
    Key key, this.positiveFunc, this.negativeFunc, this.positiveText, this.negativeText,
  }) : super(key: key);


  final Function positiveFunc, negativeFunc;
  final String positiveText, negativeText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        SizedBox(
          width: size.width / 2,
          height: 64,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            color: kPrimaryColor,
            onPressed: positiveFunc,
            child: Text(
              positiveText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: negativeFunc,
            child: Text(
              negativeText,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
