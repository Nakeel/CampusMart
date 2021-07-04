// import 'dart:js';

import 'package:campus_mart/Screens/EditProfile/main_edit_profile_screen.dart';
import 'package:campus_mart/Screens/Home/components/category_list.dart';
import 'package:campus_mart/Screens/ItemDetails/item_details_screen.dart';
import 'package:campus_mart/Screens/Login/login_screen.dart';
import 'package:campus_mart/Screens/MyAds/user_ads_main_screen.dart';
import 'package:campus_mart/Screens/MyRequests/user_requests_main_screen.dart';
import 'package:campus_mart/Screens/Onboarding/onboarding_screen.dart';
import 'package:campus_mart/Screens/Search/main_search_screen.dart';
import 'package:campus_mart/Screens/Settings/main_settings_screen.dart';
import 'package:campus_mart/Screens/Signup/signup_screen.dart';
import 'package:campus_mart/Screens/SplashScreen/splash_screen.dart';
import 'package:campus_mart/Screens/Welcome/welcome_screen.dart';
import 'package:campus_mart/Screens/Home/home_screen.dart';
import 'package:campus_mart/Screens/itemInfo/item_info_screen.dart';
import 'package:campus_mart/Screens/wants/ad_info/ad_user_info.dart';
import 'package:campus_mart/Screens/wants/ad_info/ad_user_info_screen.dart';
import 'package:campus_mart/Screens/wants/user_wants_main.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/notifier/auth_notifier.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:campus_mart/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';

import 'Screens/ForgetPass/forget_password_screen.dart';
import 'Screens/Register/register_screen.dart';
import 'Screens/categorizeList/categorize_list_main.dart';
import 'Screens/wants/add_wants.dart';
import 'models/goods_ad_data.dart';
import 'models/wants_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<WantsNotifier>(
       create: (context) => WantsNotifier(),
      ),
      ChangeNotifierProvider<GoodAdNotifier>(
       create: (context) => GoodAdNotifier(),
      ),
      ChangeNotifierProvider<AuthNotifier>(
        create: (context) => AuthNotifier(),
      )
    ],
    child: MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  PageTransitionType pageTransitionType = PageTransitionType.rippleLeftDown;
  var duration = 1000;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      value: AuthService().user,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Campus Mart',
          theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white),
          initialRoute: SplashScreen.tag,
          onGenerateRoute: (RouteSettings routeSettings) {
            return new PageRouteBuilder<dynamic>(
                settings: routeSettings,
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  switch (routeSettings.name) {
                    case SplashScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return SplashScreen();

                    case OnBoardingScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return OnBoardingScreen();

                    case WelcomeScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return WelcomeScreen();

                    case LoginScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return LoginScreen();


                    case ForgotPasswordScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.slideInRight;
                      return ForgotPasswordScreen();

                    case MainSettingScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.slideInLeft;
                      return MainSettingScreen();

                    case RegisterScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return RegisterScreen();

                    case SignUpScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return SignUpScreen();

                    case MainSearchScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.fadeIn;
                      return MainSearchScreen();

                    case HomeScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return HomeScreen();

                    case MainEditProfileScreen.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.slideInLeft;
                      return MainEditProfileScreen();

                    case ItemDetailsScreen.tag:
                    final GoodsAd goodArgs = routeSettings.arguments;
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return ItemDetailsScreen(
                        goodItem:  goodArgs
                      );

                    case ItemInfoScreen.tag:
                    final GoodsAd goodArgs = routeSettings.arguments;
                      
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return ItemInfoScreen(
                        goodItem:  goodArgs
                      );

                    case UserWantsMain.tag:
                      duration = 700;
                      pageTransitionType = PageTransitionType.rippleLeftDown;
                      return UserWantsMain();

                    case AddWantsMain.tag:
                      duration = 500;
                      final CustomUserInfo args = routeSettings.arguments;
                      pageTransitionType = PageTransitionType.rippleRightUp;
                      return AddWantsMain(
                        user: args,
                      );
                    case CategorizeList.tag:
                      duration = 500;
                      final String args = routeSettings.arguments;
                      pageTransitionType = PageTransitionType.slideInRight;
                      return CategorizeList(
                        category: args,
                      );

                    case AdUserInfo.tag:
                    final Wants wantArgs = routeSettings.arguments;

                      duration = 400;
                      pageTransitionType = PageTransitionType.slideInUp;
                      return AdUserInfo(
                        want: wantArgs
                      );

                    case UserProfileScreen.tag:
                      duration = 400;
                      pageTransitionType = PageTransitionType.slideInUp;
                      return UserProfileScreen();

                    case UserAdsMainScreen.tag:
                      duration = 400;
                      pageTransitionType = PageTransitionType.slideInLeft;
                      return UserAdsMainScreen();

                    case UserRequestMainScreen.tag:
                      duration = 400;
                      pageTransitionType = PageTransitionType.slideInLeft;
                      return UserRequestMainScreen();

                    default:
                  duration = 1000;
                  pageTransitionType = PageTransitionType.rippleLeftDown;
                  return LoginScreen();
                  }
                },
                transitionDuration: Duration(milliseconds: duration),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return effectMap[pageTransitionType](
                      Curves.linear, animation, secondaryAnimation, child);
                });
          }),
    );
  }
}
