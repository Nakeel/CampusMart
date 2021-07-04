import 'package:campus_mart/Screens/Login/components/already_have_acct_check.dart';
import 'package:campus_mart/components/round_button.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:campus_mart/utils/sharedpref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/Screens/Login/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_mart/Screens/Login/components/rounded_input_field.dart';
import 'package:campus_mart/Screens/Login/components/rounded_password_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password, error;
  bool _showloader = false;
  final AuthService _authService = AuthService();

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  var sharedpref = SharedPreference();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      showloader: _showloader,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Center(
                  child: SvgPicture.asset(
                    "assets/icons/login.svg",
                    height: size.height * 0.3,
                  ),
                ),
                Center(
                  child: RoundedInputField(
                    validateEmail: (val) => (!val.contains("@") && val.isEmpty)
                        ? "Enter a valid email address"
                        : null,
                    hintText: "Your Email",
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                ),
                Center(
                  child: RoundedPasswordField(
                    validatePass: (val) => val.length < 6
                        ? "Password must be atleast 6 characters"
                        : null,
                    obscure: _obscureText,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    showPass: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 40),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed('forgotPassword');
                    },
                    child: Text(
                     "Forgot Password",
                      style:  TextStyle(
                          fontWeight:  FontWeight.bold,
                          color: kPrimaryColor
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Center(
                  child: RoundedButton(
                    text: "Login",
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _showloader = true;
                        });
                        await _authService
                            .signInWithEmailAndPass(_email, _password)
                            .then((result) {
                              setState(() {
                                _showloader = false;
                            });
                          if (result is User) {

                            sharedpref.addBoolToSF(hasUserLogin, true);
                            sharedpref.addStringToSF('email', _email);
                            sharedpref.addStringToSF('password', _password);
                            Navigator.pushReplacementNamed(context, "home");

                          } else {
                            Fluttertoast.showToast(
                                msg: result.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            // setState(() {
                            //   error = result.toString();
                            // });
                          }
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                AlreadyHaveAccountCheck(
                  press: () {
                    Navigator.of(context).pushNamed('sign-up');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
