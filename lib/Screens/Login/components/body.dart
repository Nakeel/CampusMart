import 'package:campus_mart/Screens/Login/components/already_have_acct_check.dart';
import 'package:campus_mart/components/round_button.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:campus_mart/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/Screens/Login/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_mart/Screens/Login/components/rounded_input_field.dart';
import 'package:campus_mart/Screens/Login/components/rounded_password_field.dart';

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
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.35,
                ),
                RoundedInputField(
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
                RoundedPasswordField(
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
                RoundedButton(
                  text: "Login",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _showloader = true;
                      });
                      await _authService
                          .signInWithEmailAndPass(_email, _password)
                          .then((result) {
                        if (result == null) {
                          setState(() {
                            _showloader = false;
                          });
                          setState(() {
                            error = 'Please enter all required fields';
                          });
                        } else {
                          
                          sharedpref.addBoolToSF(hasUserLogin, true);
                          sharedpref.addStringToSF('email', _email);
                          sharedpref.addStringToSF('password', _password);
                          Navigator.pushReplacementNamed(context, "home");
                        }
                      });
                    }
                  },
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
