import 'dart:async';

import 'package:campus_mart/Screens/AddAdPost/add_ad_post.dart';
import 'package:campus_mart/Screens/favourites/favorite_main.dart';
import 'package:campus_mart/Screens/profile/components/user_profile_body.dart';
import 'package:campus_mart/Screens/wants/ad_info/ad_user_info_screen.dart';
import 'package:campus_mart/Screens/wants/user_wants_main.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/notifier/auth_notifier.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:campus_mart/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_mart/Screens/Home/components/body.dart';
import 'package:campus_mart/utils/curved_nav_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/menu_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String tag = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var navBtnSize;
  var navActiveBtnSize;
  DateTime currentBackPressTime;
  // int _temp;
  int _currentIndex = 2;
  int _selectedIndex = 0;
  bool _shouldNavigate;
  bool _isLoading = false;
  bool _isActive = false;

  String username = '',
      firstname = '',
      email = '',
      fullname = '',
      profImgUrl = '';
  final AuthService _authService = AuthService();
  CurvedNavigationBar _curvedNavigationBar;
  Timer timer;

  List<Widget> navBarIconList = [
    Icon(
      Icons.add_to_photos,
      size: 20,
      color: Colors.white,
    ),
    // Icon(
    //   Icons.favorite,
    //   size: 20,
    //   color: Colors.white,
    // ),
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _temp = 2;
    _selectedIndex = 1;
    navBtnSize = 20.0;
    navActiveBtnSize = 0.0;
    _shouldNavigate = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = Timer(Duration(seconds: 7), () {
        setState(() {
          setDrawerInfo();
        });
      });
    });
  }

  setDrawerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    username = prefs.getString(USERNAME);
    email = prefs.getString(EMAIL);
    fullname = prefs.getString(FULLNAME);
    profImgUrl = prefs.getString(PROFILE_IMG);
  }

  // saveUserID(String uiid) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(UIID, uiid);
  // }

  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  // StreamProvider<QuerySnapshot>.value(
  //     value: DatabaseService().users,
  String _currentScreen = "Home";
  CustomUserInfo user;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    final authNotifier = Provider.of<AuthNotifier>(context);

    Size size = MediaQuery.of(context).size;
    print('Selected ' + _selectedIndex.toString());
    final uid = userData?.uid ?? 'uid';
    // saveUserID(userData.uid);
    // final user = Provider.of<CustomUserInfo>(context);

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: kPrimaryColor
    // ));
    // return	Consumer<AccountProvider>(
    //     builder: (context, accountProvider, child)
    // {

    // user = Provider.of<CustomUserInfo>(context);
    return WillPopScope(
        onWillPop: () {
          return _closeApp(context);
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
                  accountName: Text(fullname),
                  accountEmail: Text(email),
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image(
                      image: NetworkImage(profImgUrl.isEmpty
                          ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
                          : profImgUrl),
                      // image: NetworkImage(
                      //     "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMesut_%25C3%2596zil&psig=AOvVaw0ognYiJKhoWWpXeMRPKM5S&ust=1599566854250000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOjU_IKB1-sCFQAAAAAdAAAAABAD"),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: dashBoardCatList
                      .asMap()
                      .entries
                      .map(
                        (e) => MenuTileWidget(
                          press: () {
                            // Navigator.of(context).pop();
                            drawerKey.currentState.openEndDrawer();
                            Timer(Duration(milliseconds: 250),
                                () => navigateTo(e.key));
                          },
                          icon: dashBoardCatIconList[e.key],
                          title: dashBoardCatList[e.key],
                          index: e.key,
                          selectedIndex: _selectedIndex,
                        ),
                      )
                      .toList(),
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
              value: DatabaseService().userData(uid, authNotifier),
              child: LoadingOverlay(
                  isLoading: _isLoading, child: _buildBody(_selectedIndex))),
          bottomNavigationBar: CurvedNavigationBar(
            color: kPrimaryColor.withOpacity(0.7),
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            buttonBackgroundColor: kPrimaryColor.withOpacity(0.7),
            initialIndex: 1,
            selectedIndex: _selectedIndex,
            items: navBarIconList,
            isActive: _isActive,
            shouldNavigate: _shouldNavigate,
            animationDuration: Duration(milliseconds: 400),
            animationCurve: Curves.bounceInOut,
            onTap: (index) {
              if (index != _selectedIndex && !_isLoading) {
                setState(() {
                  _shouldNavigate = false;
                  // _temp = index;
                  _selectedIndex = index;
                  _currentScreen = setAppTitle(index);
                });
                var currentIcon = navBarIconList[index] as Icon;
              }
            },
          ),
        ));
    // })
  }

  navigateTo(index) {
    if (index == dashBoardCatList.length - 1) {
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: 'Log Out',
          description: 'Do you want to sign out ',
          primaryButtonText: 'Sign Out',
          primaryButtonFunc: () {
            // setState(() {
            //   _isLoading = true;
            //   _isActive = true;
            // });
            // _authService.signOut().whenComplete((){

            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, 'log-in');
            // });
          },
          secButtonTxt: 'Close',
          secButtonFunc: () {
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      setState(() {
        // _temp = index;
        _shouldNavigate = true;
        _selectedIndex = index;
        _currentScreen = setAppTitle(index);
      });
    }
  }

  bool backPressOnce = false;
  Future<bool> _closeApp(BuildContext context) async {
    // if (_temp == 2) {
    if (_selectedIndex == 1) {
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
        // _temp = 2;
        _shouldNavigate = true;
        _selectedIndex = 1;
        _currentScreen = setAppTitle(1);
      });
    }
    return false;
  }

  Widget _buildBody(int index) {
    print('NavInt' + index.toString());
    if (index == 1) {
      return Body();
    }
    // else if (index == 1) {
    //   return FavoriteMain();
    // }
    else if (index == 2) {
      return UserWantsMain();
    } else if (index == 0) {
      return AddAdPostMain();
    } else if (index == 3) {
      return UserProfileScreen();
    } else {
      return Body();
    }
  }

  String setAppTitle(int index) {
    var appTitle;
    if (index == 1) {
      appTitle = "Home";
    }
    // else if (index == 1) {
    //   appTitle = "Favourites";
    // }
    else if (index == 2) {
      appTitle = "Request";
    } else if (index == 0) {
      appTitle = "Post Item";
    } else if (index == 3) {
      appTitle = "Profile";
    }
    return appTitle;
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 2,
      actions: [
        // Padding(
        //     padding: const EdgeInsets.only(right: 8.0),
        //     // ignore: missing_required_param
        //     child:
        //     _selectedIndex == 3 ? IconButton(
        //           onPressed: () {
        //             Navigator.of(context).pushNamed('settings');
        //           },
        //           icon: Icon(
        //             Icons.settings,
        //             color: Colors.white,
        //           ),
        //         ) :
        //         Container(
        //       width: 40,
        //     ))
      ],
      title: Center(child: Text(_currentScreen)),
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {
          if (!_isLoading) {
            drawerKey.currentState.openDrawer();
          }
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
