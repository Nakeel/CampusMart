import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String firstname, email;
  const Background({
    @required this.child,
    Key key, this.firstname, this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: child,
    );
  }
}
