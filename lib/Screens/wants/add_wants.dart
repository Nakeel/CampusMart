import 'dart:async';

import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/expandable_fab.dart';
import 'package:campus_mart/utils/info_dialog.dart';
import 'package:campus_mart/utils/loader_util.dart';
import 'package:campus_mart/utils/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:campus_mart/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWantsMain extends StatefulWidget {
  static const String tag = 'addNewPostScreen';
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");
  final CustomUserInfo user;

  AddWantsMain({Key key, @required this.user}) : super(key: key);

  @override
  _AddWantsMainState createState() => _AddWantsMainState();
}

class _AddWantsMainState extends State<AddWantsMain> {
  String _username, post, selectedCategory;
  int _count = 3;
  Color bgColor = kPrimaryColor;
  int _selectedIconIndex = 0;
  bool _isLoading = false;
  int _selectedColor = 0xFF306948;

  List<IconData> _iconList = [
    Icons.access_time,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.account_balance,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1), () => isShowDialogAgain());
      // getUserData();
    });
    super.initState();
  }

  isShowDialogAgain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(RouteConstant.ADD_REQUEST) ?? true
        ? _showInfoDialog(context)
        : null;
  }

  _showInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => InfoDialogWidget(
            title: 'Need new items',
            description:
                'Create an item request and sit back and wait for user to reach out in no time',
            primaryButtonText: 'Close',
            infoType: RouteConstant.ADD_REQUEST,
            infoIcon: 'assets/icons/onlineadvertising.png',
            primaryButtonFunc: () {
              Navigator.of(context).pop();
            }));
  }

  Widget _buildIcon(int index) {
    if (index == 1) {
      print("index and tag is $index and $_selectedIconIndex ");
    }
    return InkWell(
      onTap: () {
        _selectedIconIndex = index;
        selectedCategory = categoryList[index];
        setState(() {
          _selectedIconIndex = index;
          selectedCategory = categoryList[index];
          print("SelectedIndex" + _selectedIconIndex.toString());
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: _selectedIconIndex == index ? 70 : 60,
                  width: _selectedIconIndex == index ? 70 : 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(50),
                    // ),
                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: _selectedIconIndex == index ? 5.0 : 3.0,
                        spreadRadius: _selectedIconIndex == index ? 2.0 : 1.0,
                        color: kPrimaryColor.withOpacity(0.4),
                      )
                    ],
                    //   image: DecorationImage(
                    //       image: AssetImage("assets/images/img.png"),
                    //       fit: BoxFit.cover,
                    //       alignment: Alignment.centerLeft),
                  ),
                  child: Icon(
                    _iconList[index],
                    color: _selectedIconIndex == index
                        ? Color(_selectedColor)
                        : kPrimaryLightColor,
                    size: _selectedIconIndex == index ? 30 : 25,
                  ),
                ),
                Positioned(
                  right: 1,
                  child: Visibility(
                    visible: _selectedIconIndex == index,
                    child: Icon(
                      Icons.check_circle,
                      color: Color(_selectedColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              categoryList[index],
              style: TextStyle(
                  fontSize: 18,
                  color: _selectedIconIndex == index
                      ? kPrimaryLightColor
                      : Color(_selectedColor),
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("Firebase Email " + widget.user.email);
    return Scaffold(
      body:
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: () => FocusScope.of(context).unfocus(),
          //   onPanDown: (_) => FocusScope.of(context).unfocus(),
          LoadingOverlay(
        isLoading: _isLoading,
        progressIndicator: LoaderUtil(),
        child: Container(
          color: Color(_selectedColor),
          child: Stack(
            children: [
              Container(
                height: size.height * 0.15,
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 34.0,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          splashColor: kPrimaryLightColor,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isLoading = true;
                            });
                            DateTime now = DateTime.now();
                            String currentDate =
                                DateFormat('kk:mm:ss dd-MMM-yyyy').format(now);

                            DatabaseService()
                                .saveWantData(
                                    widget.user.fullname,
                                    widget.user.uuid,
                                    widget.user.university,
                                    "$_selectedColor",
                                    currentDate,
                                    post,
                                    widget.user.profileImgUrl,
                                    widget.user.profileImgHash,
                                    widget.user.phone,
                                    false,
                                    false)
                                .then((result) {
                              if (result == 'Failed') {
                                setState(() {
                                  _isLoading = false;
                                });
                              } else {
                                DatabaseService().updateUserWantsAdData(
                                  widget.user.uuid,
                                );
                                setState(() {
                                  Timer(Duration(seconds: 3), () {
                                    _isLoading = false;
                                    showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                          title: 'Post Successfully added',
                                          description:
                                              'Your product request has been successfully posted. Cheers',
                                          primaryButtonText: 'Close',
                                          primaryButtonFunc: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          }),
                                    );
                                  });
                                });
                              }
                            });
                          },
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      maxLength: 100,
                      onChanged: (value) {
                        setState(() {
                          post = value;
                        });
                      },
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintText: 'Enter Request',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          disabledBorder: InputBorder.none,
                          counter: Offstage()),
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  )),
                ),
              ),
              Positioned(
                bottom: 30,
                child: Container(
                  width: size.width,
                  child: Stack(
                    children: [
                      // Positioned(
                      //   bottom: 5,
                      //   child: Container(
                      //     // height: size.height * 0.4,
                      //     width: size.width * 0.7,
                      //
                      //     child: Align(
                      //       alignment: Alignment.bottomLeft,
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.only(left: 15, bottom: 10),
                      //         child: Column(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceAround,
                      //           children: [
                      //             Column(
                      //               children: [
                      //                 Center(
                      //                   child: Text(
                      //                     'Pick Category',
                      //                     style: TextStyle(
                      //                         fontSize: 16,
                      //                         color: Colors.white,
                      //                         fontWeight: FontWeight.w400),
                      //                   ),
                      //                 ),
                      //                 Center(
                      //                   child: Container(
                      //                     width: size.width * 0.2,
                      //                     height: 2,
                      //                     color: Colors.white,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //             SingleChildScrollView(
                      //               scrollDirection: Axis.horizontal,
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                 children: _iconList
                      //                     .asMap()
                      //                     .entries
                      //                     .map(
                      //                       (e) => _buildIcon(e.key),
                      //                     )
                      //                     .toList(),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // ),
                      // child:
                      // Flexible(
                      //   flex: 1,
                      //   fit: FlexFit.loose,
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 20),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20, top: 60),
                            child:
                                //  Text('data')
                                // SpeedDial()
                                FancyFab(
                              colorId: (value) {
                                setState(() {
                                  _selectedColor = value;
                                });
                              },
                              icon: Icons.add,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // )
            ],
          ),
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
