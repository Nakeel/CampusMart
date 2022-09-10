import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_mart/Screens/Login/components/already_have_acct_check.dart';
import 'package:campus_mart/Screens/Login/components/rounded_input_field.dart';
import 'package:campus_mart/Screens/Login/components/rounded_password_field.dart';
import 'package:campus_mart/Screens/Signup/components/background.dart';
import 'package:campus_mart/Screens/Signup/components/or_divider.dart';
import 'package:campus_mart/Screens/Signup/components/social_icon.dart';
import 'package:campus_mart/components/round_button.dart';
import 'package:campus_mart/components/searchable_item_screen.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/country_code.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:campus_mart/utils/institution.dart';
import 'package:campus_mart/utils/sharedpref.dart';
import 'package:campus_mart/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';

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
  String _email,
      _password,
      _confirmPassword,
      _phone,
      fullname,
      nick,
      selectedUniversity,
      error;
  bool _showloader = false;
  final AuthService _authService = AuthService();

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  var sharedpref = SharedPreference();

  List<CountryCode> countriesList = [];

  CountryCode selectedCountry;
  CountryCode selectedCountryCode;

  loadCountries() async {
    String data = await rootBundle.loadString('assets/json/country.json');
    countriesList = countryCodeFromJson(data);
    selectedCountryCode = countriesList[0];
    setState(() {});

    print(countriesList);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCountries();
    });
    super.initState();
  }



  getSearchableDropdown(List<String> listData) async {
    print('list $listData');
    try {
      final val = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false, // s
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchableItemWidget(
              items: listData,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));
      if (val != null) {
        setState(() {
          selectedUniversity = val;
        });
      }
    } catch (e) {
      print('Error $e');
    }
  }

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
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  // SvgPicture.asset(
                  //   "assets/icons/signup.svg",
                  //   height: size.height * 0.3,
                  // ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  RoundedInputField(
                    validateEmail: (val) =>
                        (val.isEmpty) ? "Enter a valid fields" : null,
                    // (value) {
                    //   value ? "Enter a valid email address" : null;
                    // },
                    hintText: "Fullname",
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
                    inputType: TextInputType.emailAddress,
                    hintText: "Your Email",
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),

                  SizedBox(height: 15),
                  Container(
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(20)),
                      width: size.width * .8,
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: DropdownButton<CountryCode>(
                                  underline: SizedBox(),
                                  isExpanded: true,
                                  hint: Text("Select"),
                                  value: selectedCountryCode,
                                  isDense: false,
                                  onChanged: (CountryCode newValue) {
                                    setState(() {
                                      selectedCountryCode = newValue;
                                    });
                                    print(selectedCountryCode);
                                  },
                                  items: countriesList.map((country) {
                                    return new DropdownMenuItem<CountryCode>(
                                      value: country,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: SvgPicture.network(
                                                country.flag,
                                                semanticsLabel: 'CountryCode',
                                                // placeholderBuilder: (context) => Icon(Icons.flag_sharp,color: Constants.primaryColor,),
                                              ),
                                            ),
                                            Text(
                                              '+${country.callingCodes[0]}',
                                              style: new TextStyle(
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: 1,
                            color: Colors.white,
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: TextFormField(
                                maxLength: 11,
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    labelText: 'Phone',
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    )),
                                onChanged: (value) {
                                  setState(() {
                                    _phone = value;
                                  });
                                },
                                validator: (val) =>
                                    (val.length != 11 && val.isEmpty)
                                        ? "Enter a valid phone number"
                                        : null,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 15),
                  //
                  // RoundedInputField(
                  //   validateEmail: (val) => (val.length!=11 && val.isEmpty)
                  //       ? "Enter a valid phone number"
                  //       : null,
                  //   // (value) {
                  //   //   value ? "Enter a valid email address" : null;
                  //   // },
                  //   icon: Icons.phone,
                  //   inputType: TextInputType.phone,
                  //   hintText: "Phone No",
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _phone = value;
                  //     });
                  //   },
                  // ),
                  RoundedInputField(
                    validateEmail: (val) =>
                        (val.isEmpty) ? "Enter a valid field" : null,
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
                  GestureDetector(
                    onTap: (){
                      getSearchableDropdown(institutionList);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        // shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(3.0, 3.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            color: kPrimaryColor.withOpacity(0.3),
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              selectedUniversity ?? 'Select',
                              minFontSize: 16,
                              maxFontSize: 20,
                              maxLines: 2,
                              style: TextStyle(
                                  color: selectedUniversity!=null ? Colors.black: Colors.grey.withOpacity(.6),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey.withOpacity(.8),)
                        ],
                      ),
                      // child: DropdownButtonHideUnderline(
                      //   child: DropdownButton<String>(
                      //     isExpanded: true,
                      //     hint: Text(
                      //       "Choose nearest Institution",
                      //       style: TextStyle(
                      //           color: Colors.black87,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     value: selectedUniversity,
                      //     iconEnabledColor: kPrimaryColor,
                      //     onChanged: (String selectedInstitution) {
                      //       setState(() {
                      //         selectedUniversity =
                      //             selectedInstitution;
                      //       });
                      //     },
                      //     items: institutionList.map((String user) {
                      //       return DropdownMenuItem<String>(
                      //           value: user,
                      //           child: Text(
                      //             user,
                      //             overflow: TextOverflow.ellipsis,
                      //             style: TextStyle(
                      //                 color: Colors.black87,
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w500),
                      //           ));
                      //     }).toList(),
                      //   ),
                      // ),
                    ),
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
                  RoundedPasswordField(
                    validatePass: (val) =>
                        val != _password ? "Password doesnt match" : null,
                    obscure: _obscureText,
                    hint: 'Confirm Password',
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                      });
                    },
                    showPass: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),

                  RoundedButton(
                    text: "Sign up",
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _showloader = true;
                        });
                        final userPhone = '+' +
                            selectedCountryCode.callingCodes[0] + ' ' +
                            Util.removeFirstZero(_phone);
                        await _authService
                            .registerWithEmailAndPass(_email, _password, nick,
                                userPhone, fullname, selectedUniversity)
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
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  AlreadyHaveAccountCheck(
                    login: false,
                    press: () {
                      Navigator.of(context).pushNamed('log-in');
                    },
                  ),

                  // OrDivider(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     SocialIcon(
                  //       iconSrc: "assets/icons/facebook.svg",
                  //       press: () {},
                  //     ),
                  //     SocialIcon(
                  //       iconSrc: "assets/icons/twitter.svg",
                  //       press: () {},
                  //     ),
                  //     SocialIcon(
                  //       iconSrc: "assets/icons/google-plus.svg",
                  //       press: () {},
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
