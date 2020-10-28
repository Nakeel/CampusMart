import 'dart:async';

import 'package:campus_mart/Screens/AddAdPost/add_ad_post.dart';
import 'package:campus_mart/Screens/favourites/favorite_main.dart';
import 'package:campus_mart/Screens/profile/components/user_profile_body.dart';
import 'package:campus_mart/Screens/wants/ad_info/ad_user_info_screen.dart';
import 'package:campus_mart/Screens/wants/user_wants_main.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/services/database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_mart/Screens/Home/components/body.dart';
import 'package:campus_mart/utils/curved_nav_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String tag = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var navBtnSize;
  var navActiveBtnSize;
  DateTime currentBackPressTime;
  int _temp;
  bool _shouldNavigate;
  CurvedNavigationBar _curvedNavigationBar;

  List<Widget> navBarIconList = [
    Icon(
      Icons.add_to_photos,
      size: 20,
      color: Colors.white,
    ),
    Icon(
      Icons.favorite,
      size: 20,
      color: Colors.white,
    ),
    Icon(
      Icons.home,
      size: 20,
      color: Colors.white,
    ),
    Icon(
      Icons.add,
      size: 20,
      color: Colors.white,
    ),
    Icon(
      Icons.person,
      size: 20,
      color: Colors.white,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _temp = 2;
    navBtnSize = 20.0;
    navActiveBtnSize = 0.0;
    _shouldNavigate = false;
  }

  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  
          
  // StreamProvider<QuerySnapshot>.value(
  //     value: DatabaseService().users,
  String _currentScreen = "Home";

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    // final user = Provider.of<CustomUserInfo>(context);

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: kPrimaryColor
    // ));

    return WillPopScope(
        onWillPop: () {
          _closeApp(context);
        },
        child: Scaffold(
          key: drawerKey,
          appBar: buildAppBar(),
          drawerEdgeDragWidth: 20,
          drawerDragStartBehavior: DragStartBehavior.start,
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(26)),
                  ),
                  accountName: Text('user fullname'),
                  accountEmail: Text('user email'),
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image(
                      image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      // image: NetworkImage(
                      //     "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMesut_%25C3%2596zil&psig=AOvVaw0ognYiJKhoWWpXeMRPKM5S&ust=1599566854250000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOjU_IKB1-sCFQAAAAAdAAAAABAD"),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                  // onTap: navigateTo(2),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text('Buy'),
                  leading: Icon(Icons.home),
                  // onTap: navigateTo(0),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text('Sell'),
                  leading: Icon(Icons.home),
                  // onTap: navigateTo(2),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text('My Carts'),
                  leading: Icon(Icons.home),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 5,
                      child: Image.asset(
                        "assets/images/h_ad.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: StreamProvider<CustomUserInfo>.value(
              value: DatabaseService().userData(userData.uid),
              child: _buildBody(_temp)),
          bottomNavigationBar: CurvedNavigationBar(
            color: kPrimaryColor.withOpacity(0.7),
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            buttonBackgroundColor: kPrimaryColor.withOpacity(0.7),
            initialIndex: 2,
            items: navBarIconList,
            shouldNavigate: _shouldNavigate,
            animationDuration: Duration(milliseconds: 400),
            animationCurve: Curves.bounceInOut,
            onTap: (index) {
              if (index != _temp) {
                setState(() {
                  _shouldNavigate = false;
                  _temp = index;
                  _currentScreen = setAppTitle(index);
                });
                var currentIcon = navBarIconList[index] as Icon;
              }
            },
          ),
        ));
  }

  navigateTo(index) {
    setState(() {
      _temp = index;
      _currentScreen = setAppTitle(index);
    });
  }

  bool backPressOnce = false;
  Future<bool> _closeApp(BuildContext context) async {
    if (_temp == 2) {
      if (backPressOnce) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      }
      backPressOnce = true;
      Fluttertoast.showToast(
          msg: "Press back again to exit",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Timer(Duration(seconds: 3), () {
        backPressOnce = false;
      });
    } else {
      setState(() {
        _temp = 2;
        _shouldNavigate = true;
      _currentScreen = setAppTitle(2);
      });
    }
    return false;
  }

  Widget _buildBody(int index) {
    print('NavInt' + index.toString());
    if (index == 2) {
      return Body();
    } else if (index == 1) {
      return FavoriteMain();
    } else if (index == 3) {
      return UserWantsMain();
    } else if (index == 0) {
      return AddAdPostMain();
    } else if (index == 4) {
      return UserProfileScreen();
    } else {
      return Body();
    }
  }

  String setAppTitle(int index) {
    var appTitle;
    if (index == 2) {
      appTitle = "Home";
    } else if (index == 1) {
      appTitle = "Favourites";
    } else if (index == 3) {
      appTitle = "Wants";
    } else if (index == 0) {
      appTitle = "Post Item";
    } else if (index == 4) {
      appTitle = "Account";
    }
    return appTitle;
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          // ignore: missing_required_param
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        )
      ],
      title: Center(child: Text(_currentScreen)),
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {
          drawerKey.currentState.openDrawer();
        },
      ),
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
