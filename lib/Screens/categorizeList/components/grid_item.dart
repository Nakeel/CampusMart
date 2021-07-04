import 'package:flutter/material.dart';

import '../../../constants.dart';

// ignore: must_be_immutable
class GridItem extends StatelessWidget {
  GridItem(
      {Key key,
      this.image,
      this.title,
      this.school,
      this.price,
      this.press,
      this.tag,
      this.likePressed,
      this.isLikedPressed,
      this.myAds = false,
      this.moreOptionPressed,
      this.views})
      : super(key: key);

  final String image, title, school;
  final String price, tag, views;
  final Function press, likePressed;
  final ValueChanged<String> moreOptionPressed;
  final bool isLikedPressed;
  final bool myAds;

  List<String> popupMenuList = ['Delete Item'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('like ' + isLikedPressed.toString());
    return Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding,
        ),
        width: size.width * 0.4,
        child: Column(
          children: <Widget>[
            Hero(
                tag: tag,
                transitionOnUserGestures: true,
                child: GestureDetector(
                  onTap: press,
                  child: Image(
                    image: NetworkImage(image),
                    width: (size.width * 0.4),
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                )),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 20,
                        color: kPrimaryColor.withOpacity(0.23),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: Theme.of(context).textTheme.button,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    school,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: kPrimaryColor.withOpacity(0.5)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "\#$price",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ]),
                          ),
                          Expanded(
                            flex: 1,
                            child: myAds
                                ? PopupMenuButton(
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: kPrimaryColor,
                                    ),
                                    elevation: 20,
                                    enabled: true,
                                    onSelected: moreOptionPressed,
                                    itemBuilder: (context) {
                                      return popupMenuList.map((String choice) {
                                        return PopupMenuItem(
                                          value: choice,
                                          child: Text("$choice"),
                                        );
                                      }).toList();
                                    })
                                : InkWell(
                                    onTap: likePressed,
                                    splashColor: kPrimaryColor,
                                    child: isLikedPressed
                                        ? Icon(
                                            Icons.favorite,
                                            color: kPrimaryColor,
                                          )
                                        : Icon(Icons.favorite_outline,
                                            color: kPrimaryColor)),
                          ),
                        ]),
                    SizedBox(height: 4,),
                    myAds
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.remove_red_eye_sharp,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Center(
                                child: Text(
                                  '$views Views',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
