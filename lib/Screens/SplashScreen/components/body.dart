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

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => setLoading(true));
  }

  void _getStartupScreen() {
    SharedPreference()
        .getBoolValuesSF(appHasRun)
        .then((value) => handleHasRun(value));
  }

  _loginUser(String email, String password) async {
    setState(() {
      showLoadingBar = true;
    });
    await _authService.signInWithEmailAndPass(email, password).then((result) {
      if (result == null) {
        setState(() {
          showLoadingBar = false;
          Navigator.pushReplacementNamed(context, "log-in");
        });
      } else {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  Future<void> handleUserLoggin(bool hasLogin) async {
    String destRoute;
    if (!hasLogin) {
      // SharedPreference().addBoolToSF(hasUserLogin, true);
      destRoute = "welcome";
    } else {
      var stillLoggedIn =
          await SharedPreference().getBoolValuesSF(hasUserLogin);
      if (stillLoggedIn) {
        var email = await SharedPreference().getStringValuesSF('email');
        var password = await SharedPreference().getStringValuesSF('password');
        _loginUser(email, password);
      } else {
        destRoute = "home";
      }
    }
    Navigator.pushReplacementNamed(context, destRoute);
  }

  Future<void> handleHasRun(bool hasRun) async {
    var sharedpref = SharedPreference();
    if (!hasRun) {
      print(hasRun);
      sharedpref.addBoolToSF(appHasRun, true);
      Navigator.pushReplacementNamed(context, "onboarding");
    } else {
      var login = await sharedpref.getBoolValuesSF(hasUserLogin);
      handleUserLoggin(login);
    }
  }

  void setLoading(bool show) {
    setState(() {
      showLoadingBar = show;
    });
    _getStartupScreen();
    // Navigator.pushNamed(context, _getStartupScreen());
  }

  @override
  Widget build(BuildContext context) {
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
                    "Campus Mart",
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
                "Flexible Online Store \n For Students",
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
