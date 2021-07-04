
import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/auth_notifier.dart';
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
  CustomUserInfo user;
  // TextEditingController fullnameController

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery
        .of(context)
        .size;



    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
     user = authNotifier.userDoc;


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
                           'Edit Profile',
                           style: TextStyle(
                               fontWeight: FontWeight.w700,
                               fontSize: 38),
                         ),
                       ),
                       SizedBox(height: 30,),


                       SizedBox(height: 20,),
                       ClipRRect(
                         borderRadius: BorderRadius.circular(100),
                         child: user.profileImgUrl ==null ?Icon(
                           Icons.person_outline_sharp,
                           size: 150,
                           color: kPrimaryColor.withOpacity(.7),
                         ): Image(
                           image: NetworkImage(user.profileImgUrl),
                           width: 170,
                           height: 170,
                           fit: BoxFit.cover,
                         ),
                       ),
                       SizedBox(height: 20,),

                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'Full',
                             style: TextStyle(
                                 fontSize: 14, fontWeight: FontWeight.w400),
                           ),
                           SizedBox(
                             height: 7,
                           ),
                           Container(
                             width: size.width * 0.85,
                             decoration: BoxDecoration(
                               color: Color(0xFFEFF0F6),
                               borderRadius: BorderRadius.all(
                                 Radius.circular(16),
                               ),
                             ),
                             child:
                             // Center(
                             //     child:
                             Padding(
                               padding: EdgeInsets.symmetric(
                                   horizontal: 10, vertical: 3),
                               child: TextFormField(
                                 // controller: _itemTitleController,
                                 textAlign: TextAlign.justify,
                                 keyboardType: TextInputType.number,
                                 decoration: new InputDecoration(
                                   border: InputBorder.none,
                                   focusedBorder: InputBorder.none,
                                   enabledBorder: InputBorder.none,
                                   errorBorder: InputBorder.none,
                                   hintStyle: TextStyle(color: Colors.grey[400]),
                                   disabledBorder: InputBorder.none,
                                   // counter: Offstage()
                                 ),
                                 style:
                                 TextStyle(fontSize: 16, color: Colors.black),
                               ),
                             ),
                             // ),
                           ),
                         ],
                       ),


                     ],
                   ),
                 ))));
  }
}
