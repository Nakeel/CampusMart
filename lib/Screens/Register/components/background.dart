import 'package:campus_mart/utils/loader_util.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool showloader;
  const Background({
    Key key,
    @required this.child,
    this.showloader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: showloader,
      opacity: 0.7,
      color: Colors.white,
      progressIndicator: LoaderUtil(),
      child: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/signup_top.png",
                width: size.width * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.25,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
