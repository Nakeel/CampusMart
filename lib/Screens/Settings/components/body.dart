
import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/info_dialog.dart';
import 'package:campus_mart/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  int resultCount = 0;
  String query = '';
  TextEditingController _controller = TextEditingController();
  int selectedSortBy = 0;
  String selectedSortByString = sortByTypeList[0];
  bool _isSearchActive = false;
  bool liked = false;
  String selectedPopup;
  GoodAdNotifier goodsNotifier;
  UserData user;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Future.delayed(Duration(seconds: 1), () => isShowDialogAgain());
      // getUserData();
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery
        .of(context)
        .size;


    return Scaffold(
        key: drawerKey,
        body: SafeArea(
            child: Container(
                height: size.height,
                width: size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                   child: Column(
                     children: <Widget>[
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           IconButton(
                               icon: Icon(Icons.arrow_back, size: 40,),
                               onPressed: () {
                                 Navigator.pop(context);
                               }),
                         ],
                       ),
                       Container(
                         margin: EdgeInsets.fromLTRB(10, 0, 20, 5),
                         child: Text(
                           'Settings',
                           style: TextStyle(
                               fontWeight: FontWeight.w700,
                               fontSize: 38),
                         ),
                       ),
                       SizedBox(height: 30,),

                       Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 20),
                         child: Column(
                           children: [
                             InkWell(
                               onTap: () {
                                 // navigationTapped(2);
                                 Navigator.of(context).pushNamed('editProfile');
                               },
                               child: Container(
                                 height: 70,
                                 decoration: cardViewDecoration,
                                 child: Padding(
                                   padding:
                                   const EdgeInsets.all(8.0),
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     children: [
                                       Text(
                                         'Edit Profile',
                                         style: boldPrimaryTextStyle,
                                       ),
                                       Icon(
                                         Icons.keyboard_arrow_right,
                                         color: darkLilac,
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),


                     ],
                   ),
                 ))));
  }
}
