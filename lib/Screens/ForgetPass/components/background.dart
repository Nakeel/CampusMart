import 'package:campus_mart/utils/loader_util.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool showloader;
  const Background({
    @required this.child,
    Key key,
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
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/login_bottom.png",
                width: size.width * 0.3,
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: child),
          ],
        ),
      ),
    );
  }
}
