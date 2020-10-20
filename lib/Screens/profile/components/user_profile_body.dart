import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_info_item.dart';

class UserProfileBody extends StatefulWidget {
  static const String tag = "profileUserInfo";
  static const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _UserProfileBodyState createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<CustomUserInfo>(context);

    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: kPrimaryColor,
          child: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300].withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                // child: null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        child: Text(
                          'Sales and Request',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Product Sans",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Total Sales",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  user.totalSalesAd.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.white,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Total Request",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  user.totalWantsAd.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: size.height * 0.72,
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(30, 25, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3.0),
                        blurRadius: 10.0,
                        spreadRadius: 7.0,
                        color: kPrimaryColor.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ProfileInfoItem(size: size,
                      containerColor: kPrimaryColor,
                      icon: Icons.person,
                      iconColor: kPrimaryColor,
                      showEdit: false,
                      infoText: user.fullname,

                      ),
                       SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(size: size,
                      containerColor: Colors.deepPurpleAccent,
                      icon: Icons.email,
                      iconColor: Colors.deepPurpleAccent,
                      showEdit: false,
                      infoText: user.email,
                      
                      ),
                       SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(size: size,
                      containerColor: Colors.cyan,
                      icon: Icons.phone,
                      iconColor: Colors.cyan,
                      showEdit: true,
                      infoText: user.phone,
                      
                      ),
                       SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(size: size,
                      containerColor: Colors.green,
                      icon: Icons.location_city,
                      iconColor: Colors.green,
                      showEdit: false,
                      infoText: user.university,
                      
                      ),
                       SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(size: size,
                      containerColor: kPrimaryColor,
                      icon: Icons.person,
                      iconColor: kPrimaryColor,
                      showEdit: false,
                      infoText: 'Danny Rogue',
                      
                      )
                    ],
                  ),
                  // ),
                ),
              ),
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

