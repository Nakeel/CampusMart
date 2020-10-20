import 'dart:async';

import 'package:campus_mart/constants.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/Screens/Welcome/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_mart/components/round_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _authService = AuthService();

  bool _showLoader = false;

  void setLoading(bool load) {
    setState(() {
      _showLoader = false;
    });
    Navigator.pushReplacementNamed(context, "home");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //provide screen size
    return Background(
      // // child: LoaderUtil(),
      // child: LoadingOverlay(
      //   isLoading: true,
      //   opacity: 0.5,
      //   progressIndicator: LoaderUtil(),
      showLoader: _showLoader,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Campus Mart",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              SvgPicture.asset(
                "assets/icons/chat.svg",
                height: size.height * 0.4,
              ),
              RoundedButton(
                text: "Login",
                press: () {
                  Navigator.of(context).pushNamed('log-in');

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return LoginScreen();
                  //     },
                  //   ),
                  // );
                },
              ),
              RoundedButton(
                text: "Sign Up",
                press: () {
                  Navigator.of(context).pushNamed('register');

                  // Navigator.push(context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return SignUpScreen();
                  //     },
                  //   ),
                  // );
                },
                textColor: Colors.black,
                color: kPrimaryLightColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Or",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              RoundedButton(
                text: "Alternative Sign up ",
                press: (){
                    Navigator.of(context).pushNamed('sign-up');
                  // dynamic result = await _authService
                  //     .anonSignIn()
                  //     .whenComplete(() => setState(() {
                  //   print(_showLoader);
                  //           _showLoader = false;
                  //         }));
                  // if (result == null) {
                  //   print('error signing in');
                  // } else {
                  //   print('signed in');
                  //   print(result);
                  // }
                  // Navigator.push(context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return SignUpScreen();
                  //     },
                  //   ),
                  // );
                },
                textColor: Colors.black,
                color: kPrimaryLightColor,
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
