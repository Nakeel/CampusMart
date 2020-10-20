import 'package:flutter/material.dart';
import 'package:campus_mart/constants.dart';

class AlreadyHaveAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAccountCheck({
    Key key, 
    this.login = true, 
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't have an Account ? " : "Already have an Account ",
          style:  TextStyle(
            color: kPrimaryColor
          ),
        ),
        GestureDetector(
          onTap: press,
            child: Text(
              login ? "Sign Up" :"Sign In",
              style:  TextStyle(
                fontWeight:  FontWeight.bold,
                color: kPrimaryColor
              ),
            ),
        ),

      ],
    );
  }
}

