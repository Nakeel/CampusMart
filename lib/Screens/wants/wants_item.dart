import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_mart/Screens/wants/ad_info/ad_user_info.dart';
import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class WantItems extends StatelessWidget {
  const WantItems({
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
      height: 300.0,
      width: double.infinity,
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
                  flex: 1,
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
                                child: userImgUrl != ''
                                    ? Image(
                                        image: NetworkImage(userImgUrl),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          color: kPrimaryColor,
                                          size: 40,
                                        ),
                                      ),
                              ),
                            )),
                        Text(
                          userName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: postBgColor,
                    child: Center(
                      child: AutoSizeText(
                        postText,
                        // maxLines: 10,
                        minFontSize: 22,
                        maxFontSize: 28,
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
                  flex: 1,
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600]),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 3),
                                      child: AutoSizeText(
                                        userLocation,
                                        minFontSize: 13,
                                        maxFontSize: 15,
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    )
                                  ],
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
                                  TextStyle(fontSize: 13, color: Colors.grey),
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
