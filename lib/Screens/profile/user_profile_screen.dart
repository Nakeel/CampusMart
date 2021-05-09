
import 'package:campus_mart/Screens/profile/components/user_profile_body.dart';
import 'package:flutter/material.dart';

class AdUserDetailsScreen extends StatelessWidget {
  static const String tag = "ad-user-details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfileBody(),
    );
  }
}