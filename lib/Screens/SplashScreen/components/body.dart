import 'dart:async';

import 'package:campus_mart/Screens/Onboarding/onboarding_screen.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:campus_mart/utils/circular_logo.dart';
import 'package:campus_mart/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/Screens/SplashScreen/components/background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool showLoadingBar = false;
  final AuthService _authService = AuthService();
  var hasBeenCalled = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 3), () => setLoading(true)
        // _getStartupScreen(context)
        );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _getStartupScreen(BuildContext context) {
    SharedPreference().getBoolValuesSF(appHasRun).then((value) {
      handleHasRun(value, context);
    });
  }

  _loginUser(String email, String password, BuildContext context) async {
    showLoadingBar = true;
    await _authService.signInWithEmailAndPass(email, password).then((result) {
      if (result == null) {
        // setState(() {
        //   showLoadingBar = false;
        Navigator.pushReplacementNamed(context, "log-in");
        // });
      } else {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  Future<void> handleUserLoggin(bool hasLogin, BuildContext context) async {
    String destRoute;
    if (!hasLogin) {
      // SharedPreference().addBoolToSF(hasUserLogin, true);
      destRoute = "welcome";
      Navigator.pushReplacementNamed(context, destRoute);
    } else {
      var stillLoggedIn =
          await SharedPreference().getBoolValuesSF(hasUserLogin);
      if (stillLoggedIn) {
        var email = await SharedPreference().getStringValuesSF('email');
        var password = await SharedPreference().getStringValuesSF('password');
        _loginUser(email, password, context);
      } else {
        destRoute = "log-in";
        Navigator.pushReplacementNamed(context, destRoute);
      }
    }
  }

  Future<void> handleHasRun(bool hasRun, BuildContext context) async {
    var sharedpref = SharedPreference();
    if (!hasRun) {
      print(hasRun);
      sharedpref.addBoolToSF(appHasRun, true);
      Navigator.pushReplacementNamed(context, "onboarding");
    } else {
      var login = await sharedpref.getBoolValuesSF(hasUserLogin);
      handleUserLoggin(login, context);
    }
  }

  void setLoading(bool show) {
    setState(() {
      showLoadingBar = show;
      hasBeenCalled = true;
    });
    // Navigator.pushNamed(context, _getStartupScreen());
  }

  @override
  Widget build(BuildContext context) {
    if (!hasBeenCalled) {
      _getStartupScreen(context);
    }
    ;
    Size size = MediaQuery.of(context).size;
    //provide screen size
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CircularLogoItem(),
                  Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      child: Image.asset(
                        "assets/images/cm_logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    "Campus Market",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: showLoadingBar,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Text(
                "The biggest marketplace \n for all students",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
