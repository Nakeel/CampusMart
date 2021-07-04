import 'dart:async';

import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

import 'color_dot.dart';

class FancyFab extends StatefulWidget {
  ValueChanged<int> colorId;
  final String tooltip;
  final IconData icon;

  FancyFab({this.colorId, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  bool _visible = false;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
    setState(() {
      Timer(Duration(milliseconds: 300), () => _visible = isOpened);
    });
  }

  Widget add() {
    return  GestureDetector(
      onTap: () {
        widget.colorId(primaryColorString);
      },
      child: ColorDot(
        color: Color(primaryColorString),
      ),
    );
  }

  Widget image() {
    return GestureDetector(
      onTap: () {
        widget.colorId(secColorString);
      },
      child: ColorDot(
        color: Colors.green,
      ),
    );
  }

  Widget inbox() {
    return GestureDetector(
      onTap: () {
        widget.colorId(0xFF306948);
      },
      child: ColorDot(
        color:Color(0xFF306948),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: animate,
        child: Icon(
          Icons.color_lens_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Visibility(
          visible: _visible,
          // child: Transform(
          //   transform: Matrix4.translationValues(
          //     0.0,
          //     _translateButton.value * 3.0,
          //     0.0,
          //   ),
            child: Padding(
              padding:  EdgeInsets.only(bottom: 8.0),
              child: add(),
            ),
          // ),
        ),
        Visibility(
          visible: _visible,
          // child: Transform(
          //   transform: Matrix4.translationValues(
          //     0.0,
          //     _translateButton.value * 2.0,
          //     0.0,
          //   ),
            child: Padding(
              padding:  EdgeInsets.only(bottom: 8.0),
              child: image(),
            ),
          // ),
        ),
        Visibility(
          visible: _visible,
          // child: Transform(
          //   transform: Matrix4.translationValues(
          //     0.0,
          //     _translateButton.value,
          //     0.0,
          //   ),
            child: Padding(
              padding:  EdgeInsets.only(bottom: 8.0),
              child: inbox(),
            ),
          // ),
        ),
        toggle(),
      ],
    );
  }
}
