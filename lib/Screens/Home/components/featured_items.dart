import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_mart/Screens/wants/wants_item.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/wants_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeaturedItems extends StatelessWidget {
  const FeaturedItems({
    Key key,
    this.listWants,
  }) : super(key: key);
  final List<Wants> listWants;

  @override
  Widget build(BuildContext context) {
    print('WantList ' + listWants.length.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allItems(listWants, context),
      ),
    );
  }
}

List<Widget> allItems(List<Wants> wantsList, BuildContext context) {
  List<Widget> all = [];

  var dateFormat = DateFormat('kk:mm:ss dd-MMM-yyyy');
  List<Wants> _wantsList = List.from(wantsList);

  // _wantsList = wantsList;

  _wantsList.sort((a, b) =>
      dateFormat.parse(b.datePosted).compareTo(dateFormat.parse(a.datePosted)));
  
  // _wantsList.take(3);

  _wantsList.take(4).forEach((wantItem) {
    print("ColorId " + wantItem.datePosted);
    Widget want = FeatureItems(
        press: () {
          Navigator.pushNamed(context, 'adUserInfo', arguments: wantItem);
        },
        postBgColor: Color(int.parse(wantItem.colorId)),

        // postBgColor: kPrimaryColor,

        postDate: wantItem.datePosted,
        postText: wantItem.post,
        userImgUrl: wantItem.userImgUrl == null ?
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg' : wantItem.userImgUrl ,
        userLocation: wantItem.university,
        userName: wantItem.fullname);
    // Widget want = FeatureItemCard(
    //   image: "",
    //   post: wantItem.post,
    // );
    all.add(want);
  });

  return all;
}

class FeatureItems extends StatelessWidget {
  const FeatureItems({
    Key key,
    this.userImgUrl,
    this.userName,
    this.postText,
    this.postDate,
    this.userLocation,
    this.postBgColor,
    this.press,
  }) : super(key: key);

  final String userImgUrl, userName, postText, postDate, userLocation;
  final Color postBgColor;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      width: MediaQuery.of(context).size.width * 0.7,
      height: 205,
      // decoration: BoxDecoration(
      //     color: Colors.grey[200], borderRadius: BorderRadius.circular(20.0)),
      // child: Padding(
      //   padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),

      child: Card(
        elevation: 3,
        shadowColor: kPrimaryLightColor,
        child: InkWell(
          onTap: press,
          hoverColor: kPrimaryColor,
          focusColor: kPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Hero(
                              transitionOnUserGestures: true,
                              tag: postDate,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: 
                                // userImgUrl != ''
                                //     ? Image(
                                //         image: NetworkImage(userImgUrl),
                                //         width: 25,
                                //         height: 25,
                                //         fit: BoxFit.cover,
                                //       )
                                //     : CircleAvatar(
                                //         backgroundColor: Colors.grey[300],
                                //         child: Icon(
                                //           Icons.person,
                                //           color: kPrimaryColor,
                                //           size: 23,
                                //         ),
                                //       ),
                                
                                Image(
                                  image: NetworkImage(userImgUrl),
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                        Text(
                          userName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 40,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: postBgColor,
                    child: Center(
                      child: AutoSizeText(
                        postText,
                        // maxLines: 10,
                        minFontSize: 12,
                        maxFontSize: 22,
                        // overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.map,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 3),
                                          child: AutoSizeText(
                                            userLocation,
                                            minFontSize: 12,
                                            maxFontSize: 13,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              postDate,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),

                          //   child: Row(

                          // )
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
