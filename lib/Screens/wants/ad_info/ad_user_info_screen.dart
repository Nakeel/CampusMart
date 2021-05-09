
import 'package:campus_mart/Screens/profile/components/user_profile_body.dart';

import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  static const String tag = "user-profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfileBody(),
    );
  }
}