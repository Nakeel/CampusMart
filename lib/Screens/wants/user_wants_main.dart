import 'package:campus_mart/Screens/wants/add_wants.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:campus_mart/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserWantsMain extends StatefulWidget {
  static const String tag = "userWantMain";
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

 UserWantsMain({Key key}) : super(key: key);

  @override
  _UserWantsMainState createState() => _UserWantsMainState();
}


 

class _UserWantsMainState extends State<UserWantsMain> {
  String _username;
  int _count = 3;

  @override
  void initState() {
    WantsNotifier wantsNotifier =
        Provider.of<WantsNotifier>(context, listen: false);
    DatabaseService().getWants(wantsNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUserInfo>(context);
    WantsNotifier wantsNotifier = Provider.of<WantsNotifier>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    print('WantsM' + wantsNotifier.wantList.length.toString());

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: allItems(wantsNotifier.wantList),
                //   // children: wantsNotifier.wantList.asMap().entries.map((e) {
                //   //   // Container(
                //   //   //   width: size.width,
                //   //   //   child: Text("New"),
                //   //   // );
                //   //   // print('WantsP ' + e.value.category);
                //   //   WantItems(
                //   //       press: () {
                //   //         print('Working');
                //   //         // Navigator.pushNamed(context, 'adUserInfo',
                //   //         //     arguments: e.value);
                //   //       },
                //   //       postBgColor: kPrimaryColor,
                //   //       postDate: e.value.datePosted,
                //   //       postText: e.value.post,
                //   //       userImgUrl:'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                //   //       userLocation: e.value.university,
                //   //       userName: e.value.fullname);
                //   // }).toList(),
              ),
            )),
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'addNewPostScreen',
                      arguments: user);
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),

      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //     ],
      //   ),
      // ),
    );
  }

  List<Widget> allItems(List<Wants> wantsList) {
    List<WantItems> all = [];
  var dateFormat = DateFormat('kk:mm:ss dd-MMM-yyyy');
  List<Wants> _wantsList = List.from(wantsList);

  // _wantsList = wantsList;

  _wantsList.sort((a, b) =>
      dateFormat.parse(b.datePosted).compareTo(dateFormat.parse(a.datePosted)));
    _wantsList.forEach((wantItem) {
      // print("ColorId "+ wantItem.colorId);
      Widget want = WantItems(
          press: () {
            Navigator.pushNamed(context, 'adUserInfo', arguments: wantItem);
          },
          postBgColor: Color(int.parse(wantItem.colorId)),

          // postBgColor: kPrimaryColor,

          postDate: wantItem.datePosted,
          postText: wantItem.post,
          userImgUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          userLocation: wantItem.university,
          userName: wantItem.fullname);
      all.add(want);
    });

    return all;
  }
}
