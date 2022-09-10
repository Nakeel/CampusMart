import 'package:campus_mart/Screens/Login/components/already_have_acct_check.dart';
import 'package:campus_mart/Screens/Login/components/rounded_input_field.dart';
import 'package:campus_mart/Screens/Login/components/rounded_password_field.dart';
import 'package:campus_mart/Screens/Register/components/background.dart';
import 'package:campus_mart/components/mini_round_button.dart';
import 'package:campus_mart/components/round_button.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  final Widget child;

  const Body({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password, _phone, fullname, nick, university, error;
  bool _showloader = false;
  final AuthService _authService = AuthService();
  String selectedUser;

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;
  bool complete = false;
  bool hideBack = false;
  String buttontext = 'Continue';
  List<Step> steps;

  next() {
    currentStep + 1 != steps.length
        ? goto(currentStep + 1)
        : setState(() {
            complete = true;
          });
  }

  cancel() {
    if (currentStep > 0) {
      goto(currentStep - 1);
    }
  }

  goto(int step) {
    setState(() {
      currentStep = step;
      hideBack = (currentStep == 0);
      buttontext = (currentStep + 1) == steps.length ? 'Finish' : 'Continue';
    });
    print('curr' + currentStep.toString());
  }

  @override
  void initState() {
    super.initState();
    steps = [
      Step(
          isActive: true,
          state: StepState.complete,
          title: Text(
            'Create New Account',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          content: Column(
            children: [
              RoundedInputField(
                validateEmail: (val) => (!val.contains("@") && val.isEmpty)
                    ? "Enter a valid email address"
                    : null,
                // (value) {
                //   value ? "Enter a valid email address" : null;
                // },
                hintText: "FullName",
                onChanged: (value) {
                  setState(() {
                    fullname = value;
                  });
                },
              ),
              RoundedInputField(
                validateEmail: (val) => (!val.contains("@") && val.isEmpty)
                    ? "Enter a valid email address"
                    : null,
                // (value) {
                //   value ? "Enter a valid email address" : null;
                // },
                icon: Icons.email,
                hintText: "Your Email",
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ],
          )),
      Step(
          isActive: false,
          state: StepState.editing,
          title: Text(
            'User Info',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          content: Column(children: [
            RoundedInputField(
              validateEmail: (val) => (!val.contains("@") && val.isEmpty)
                  ? "Enter a valid email address"
                  : null,
              // (value) {
              //   value ? "Enter a valid email address" : null;
              // },
              icon: Icons.phone,
              hintText: "Your Phone",
              onChanged: (value) {
                setState(() {
                  _phone = value;
                });
              },
            ),
            RoundedInputField(
              validateEmail: (val) => (!val.contains("@") && val.isEmpty)
                  ? "Enter a valid email address"
                  : null,
              // (value) {
              //   value ? "Enter a valid email address" : null;
              // },
              icon: Icons.perm_identity,
              hintText: "Nick/Bussinesname",
              onChanged: (value) {
                setState(() {
                  nick = value;
                });
              },
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  "Select item",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                value: selectedUser,
                iconEnabledColor: kPrimaryColor,
                onChanged: (String Value) {
                  setState(() {
                    selectedUser = Value;
                  });
                },
                items: universityList.map((String user) {
                  return DropdownMenuItem<String>(
                      value: user,
                      child: Text(
                        user,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ));
                }).toList(),
              ),
            ),
          ])),
      Step(
          isActive: false,
          state: StepState.editing,
          title: Text('Create Password'),
          content: Column(
            children: [
              RoundedPasswordField(
                validatePass: (val) => val.length < 6
                    ? "Password must be atleast 6 characters"
                    : null,
                obscure: _obscureText,
                hint: 'Your Password',
                onChanged: (value) {},
                showPass: () {
                  hidePass();
                },
              ),
              RoundedPasswordField(
                validatePass: (val) => val.length < 6
                    ? "Password must be atleast 6 characters"
                    : null,
                obscure: _obscureText,
                hint: 'Confirm Password',
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                showPass: () {
                  hidePass();
                },
              ),
            ],
          )),
    ];
  }

  hidePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  performRequest() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _showloader = true;
      });
      await _authService
          .registerWithEmailAndPass(
              _email, _password, nick, _phone, fullname, university)
          .then((result) {
        if (result == null) {
          setState(() {
            _showloader = false;
          });
          setState(() {
            error = 'Please enter all required fields';
          });
        } else {
          Navigator.pushReplacementNamed(context, "home");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      showloader: _showloader,
      // child: GestureDetector(
      //   behavior: HitTestBehavior.opaque,
      //   onTap: () => FocusScope.of(context).unfocus(),
      //   onPanDown: (_) => FocusScope.of(context).unfocus(),

      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Register On \nCampus Market',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                //   SizedBox(
                //   height: size.height * 0.02,
                // ),
                // Expanded(
                //     child:
                Stepper(
                  currentStep: currentStep,
                  onStepCancel: cancel,
                  onStepContinue: next,
                  onStepTapped: (step) => goto(step),
                  steps: steps,
                  // type: StepperType.horizontal,
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: [
                        MiniRoundedButton(
                            text: buttontext,
                            color: kPrimaryColor,
                            textColor: Colors.white,
                            press: controls.onStepContinue),
                        Visibility(
                          visible: (currentStep != 0),
                          child: MiniRoundedButton(
                              text: "Back",
                              color: kPrimaryLightColor,
                              textColor: Colors.black,
                              press: controls.onStepCancel),
                        ),
                      ],
                    );
                  },
                  // )
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                AlreadyHaveAccountCheck(
                  login: false,
                  press: () {
                    Navigator.of(context).pushNamed('log-in');
                  },
                ),
              ],
            )),
      ),
      // ),
    );
  }
}
