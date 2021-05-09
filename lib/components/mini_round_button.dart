
import 'package:flutter/material.dart';

class MiniRoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const MiniRoundedButton({
    Key key,
    this.text,
    this.color ,
    this.textColor,
    this.press
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      child: ClipRRect(
        
        borderRadius: BorderRadius.circular(15),
        child: FlatButton( 
          onPressed: press, 
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          color: color,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

