import 'dart:math';

import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class LoaderUtil extends StatefulWidget {
  @override
  _LoaderUtilState createState() => _LoaderUtilState();
}

class _LoaderUtilState extends State<LoaderUtil>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation_rotation;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;

  final double initailRadius = 30.0;
  double radius = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animation_radius_in = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));
    animation_radius_out = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animation_radius_in.value * initailRadius;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animation_radius_out.value * initailRadius;
        }
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Center(
        
        
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
            
          //   children: [
            
              child: Stack(
                children: [
                  Dot(
                    radius: 20.0,
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                  RotationTransition(
                    turns: animation_rotation,
                    child: Stack(
                      children: [
                        Transform.translate(
                          offset:
                              Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                          child: Dot(
                            radius: 5.0,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
              // Padding(padding: EdgeInsets.only(top: 40)),
              // Text(
              //   "Loading",
              //   style: TextStyle(
              //     fontSize: 14,
              //   ),
              // )
      //       ],
      //     ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  const Dot({Key key, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
      ),
    );
  }
}
