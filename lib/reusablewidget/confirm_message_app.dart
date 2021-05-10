import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class ConfirmMessageAppDialog extends StatefulWidget {
  final String  primaryButtonText, secButtonTxt;

  final Function primaryButtonFunc, secButtonFunc;

  const ConfirmMessageAppDialog(
      {Key key,
      @required this.primaryButtonText,
      this.secButtonTxt,
      @required this.primaryButtonFunc,
      this.secButtonFunc})
      : super(key: key);

  @override
  _ConfirmMessageAppDialogState createState() =>
      _ConfirmMessageAppDialogState();
}

class _ConfirmMessageAppDialogState extends State<ConfirmMessageAppDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();

    Timer(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ConfirmMessageAppDialog oldWidget) {
    if (widget != oldWidget) {
      controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return
        // ScaleTransition(
        //   scale: scaleAnimation,
        //   child:
        Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    )
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chat on',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        splashColor: kPrimaryColor,
                        onPressed: widget.primaryButtonFunc,
                        icon: Icon(
                          Icons.whatshot_sharp,
                          size: 65,
                          color: Colors.green[400],
                        ),
                      ),
                      SizedBox(
                        width: 85,
                      ),
                      IconButton(
                        splashColor: kPrimaryColor,
                        onPressed: widget.secButtonFunc,
                        icon: Icon(
                          Icons.message,
                          size: 65,
                          color: Colors.blue[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AutoSizeText(
                      'Cancel',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ))
        ],
      ),
      // ),
    );
  }
}
