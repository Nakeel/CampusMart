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
        child: child,
      ),
    );
  }
}
