import 'package:campus_mart/Screens/categorizeList/components/grid_item.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/goods_ad_data.dart';
import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:campus_mart/notifier/goods_ad_notifier.dart';
import 'package:campus_mart/notifier/wants_notifier.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/info_dialog.dart';
import 'package:campus_mart/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  WantsNotifier wantsNotifier;
  UserData user;

  List<Wants> wantList ;
    bool liked = false;


  _showInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => InfoDialogWidget(
            title: 'Manage Request',
            description:
            'View how your good request are been interacted with and also delete older goods request',
            primaryButtonText: 'Close',
            infoType: RouteConstant.MY_REQUEST,
            infoIcon: 'assets/icons/onlineadvertising.png',
            primaryButtonFunc: () {
              Navigator.of(context).pop();
            }));
  }

  _showDeleteCautionDialog(int index, String uid){
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
          title: 'Delete Request',
          description:
          'Are you sure? \n NB. Operation is not reversible',
          primaryButtonText: 'Yes',
          secButtonTxt: 'No',
          secButtonFunc: (){
            Navigator.of(context).pop();
          },
          primaryButtonFunc: () {

            print('Index $index goodSize ${wantList.length}');
              wantList.removeAt(index);
              setState(() {
              });

            print('Ind $index goodSize ${wantList.length}');
            DatabaseService().deleteWants(uid);
            Navigator.of(context).pop();
          }),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
     getWantsAds();
      Future.delayed(Duration(seconds: 1), () => isShowDialogAgain());
      // getUserData();
    });
    super.initState();
  }

  getWantsAds() async {
    WantsNotifier wantsNotifier = Provider.of<WantsNotifier>(context, listen: false);
    await DatabaseService().getWantsById(wantsNotifier, user.uid);
    wantList = wantsNotifier.wantListById.toList();
    setState(() {
    });
  }

  isShowDialogAgain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(RouteConstant.MY_REQUEST) ?? true
        ? _showInfoDialog(context)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    user = Provider.of<UserData>(context);
    wantsNotifier = Provider.of<WantsNotifier>(context);

    return Scaffold(
        key: drawerKey,
        body: SafeArea(
            child: Container(
                height: size.height,
                width: size.width,
                color: Colors.white,
                child: Stack(children: [
                  SingleChildScrollView(
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
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  'My Requests',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 38),
                                ),
                                // Text(
                                //   (selectedSortByString == sortByTypeList[0])
                                //       ? goodsList.length.toString()
                                //       : wantList.length.toString(),
                                //   style: TextStyle(fontSize: 16),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        wantList == null ? Container(
                          width: size.width,
                          height: size.height * .7,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ) : wantList.isNotEmpty ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: allItems(wantList),
                                ),
                              ): Container(
                          width: size.width,
                          height: size.height * .7,
                          child: Center(child: Text('No new wants requests'),),
                        )
                      ],
                    ),
                  ),
                ]))));
  }

  List<Widget> allItems(List<Wants> wantsList) {
    List<Widget> all = [];
    var dateFormat = DateFormat('kk:mm:ss dd-MMM-yyyy');
    wantList = List.from(wantsList);

    // _wantsList = wantsList;

    wantList.sort((a, b) => dateFormat
        .parse(b.datePosted)
        .compareTo(dateFormat.parse(a.datePosted)));
    wantList.forEach((wantItem) {
      // print("ColorId "+ wantItem.colorId);

      Widget want =  new Slidable(
        actionExtentRatio: 0.25,
        actionPane: SlidableDrawerActionPane(),
        child: WantItems(
            press: () {
              // Navigator.pushNamed(context, 'adUserInfo', arguments: wantItem);
            },
            postBgColor: Color(int.parse(wantItem.colorId)),

            // postBgColor: kPrimaryColor,

            postDate: wantItem.datePosted,
            postText: wantItem.post,
            userImgUrl: wantItem.userImgUrl,
            userLocation: wantItem.university,
            userName: wantItem.fullname),
        actions: [],
        secondaryActions: <Widget>[
          // new IconSlideAction(
          //   caption: 'More',
          //   color: Colors.black45,
          //   icon: Icons.more_horiz,
          //   onTap: () {
          //
          //   },
          // ),
          new IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              _showDeleteCautionDialog(wantList.indexOf(wantItem), wantItem.uid);
            },
          ),
        ],
      );
      all.add(want);
    });

    return all;
  }
}
