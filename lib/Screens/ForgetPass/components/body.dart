import 'package:campus_mart/components/round_button.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:campus_mart/utils/sharedpref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';
import 'background.dart';
import 'rounded_input_field.dart';
import 'rounded_password_field.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password, error;
  bool _showloader = false, isEnterPassword = false;
  final AuthService _authService = AuthService();
  PageController _pageController;
  int _page = 0;

  void navigationTapped(int page) {
    _pageController.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }


  bool _obscureText = true, _obscureTextConfirm = true;
  String  _confirmPassword, verifyCode;
  final _formKey = GlobalKey<FormState>();
  var sharedpref = SharedPreference();

  void sendPassReset(String email, BuildContext contxt) async {
      if (_formKey.currentState.validate()) {
        setState(() {
          _showloader = true;
        });
        try {
          await _authService.forgotPassword(_email).whenComplete(() => setState(() {
            _showloader = false;
            showDialog(
              context: context,
              builder: (context) => CustomDialog(
                  title: 'Password Email Sent',
                  description:
                  'A password reset link has been sent to your email, Kindly follow the link to reset password',
                  primaryButtonText: 'Close',
                  primaryButtonFunc: () {
                    Navigator.of(context).pop();
                    Navigator.of(contxt).pop();
                    // setState(() {
                    //   isEnterPassword = true;
                    // });
                  }),
            );
          }));

          }catch (e) {
            Fluttertoast.showToast(
                msg: e.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
  }

  handleBackPressed() {
    if (_page == 1) {
      setState(() {
        isEnterPassword = false;
      });
    } else  {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => handleBackPressed(),
      child:
      Background(
        showloader: _showloader,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          onPanDown: (_) => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  IconButton(
                      icon: Icon(Icons.arrow_back, size: 40,),
                      onPressed: () {
                        handleBackPressed();
                      }),
                          !isEnterPassword ?SingleChildScrollView(
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Text(
                                    "Enter your registered email to reset \nyour password in no time",
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Center(
                                  child: Image.asset(
                                    "assets/images/forgotPass.png",
                                    height: size.height * 0.3,
                                  ),
                                ),SizedBox(
                                  height: 40,
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
                                SizedBox(
                                  height: 20,
                                ),

                                Center(
                                  child: RoundedButton(
                                    text: "Reset Password",
                                    press: (){
                                      sendPassReset(_email, context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                         : SingleChildScrollView(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  SizedBox(
                                    height: 25,
                                  ),
                                  Center(
                                    child: Text(
                                      "New Password",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        "Enter the verification code sent to your email and your new password",
                                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  Center(
                                    child: Image.asset(
                                      "assets/images/forgotPass.png",
                                      height: size.height * 0.3,
                                    ),
                                  ),SizedBox(
                                    height: 40,
                                  ),
                                  RoundedInputField(
                                    validateEmail: (val) =>
                                    (val.isEmpty) ? "Enter a valid fields" : null,
                                    hintText: "Verification Code",
                                    onChanged: (value) {
                                      setState(() {
                                        verifyCode = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: RoundedPasswordField(
                                      validatePass: (val) =>
                                      val != _password ? "Password doesnt match" : null,
                                      obscure: _obscureTextConfirm,
                                      hint: 'Confirm Password',
                                      onChanged: (value) {
                                        setState(() {
                                          _confirmPassword = value;
                                        });
                                      },
                                      showPass: () {
                                        setState(() {
                                          _obscureTextConfirm = !_obscureTextConfirm;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Center(
                                    child: RoundedButton(
                                      text: "Create Password",
                                      press: (){
                                        // sendPassReset(_email);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
