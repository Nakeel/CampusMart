import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../../../constants.dart';

class RecommendedItemCard extends StatelessWidget {
  const RecommendedItemCard(
      {Key key,
      this.image,
      this.title,
      this.school,
      this.price,
      this.press,
      this.tag,
      this.imgHash})
      : super(key: key);

  final String image, title, school;
  final String price, tag, imgHash;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: press,
        child: Container(
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
                child: Container(
                  
                  height: 170,
                  width: (size.width * 0.4),
                child: BlurHash(
                  color: Colors.blueGrey[100],
                  hash: imgHash,
                  image: image,
                  imageFit: BoxFit.cover,
                  duration: Duration(seconds: 5),
                  curve: Curves.easeOut,
                ),
                ),
                // child: Image(
                //   image: NetworkImage(image),
                //   width: (size.width * 0.4),
                //   height: 170,
                //   fit: BoxFit.cover,
                // ),
              ),
              Container(
                padding: EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: kPrimaryColor.withOpacity(0.23),
                      )
                    ]),
                child: Flexible(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 30,
                        child: Column(
                          children: [
                            Text(
                              title.toUpperCase(),
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
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Flexible(
                        flex: 15,
                        child: Text(
                          "\u{20A6}$price",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: kPrimaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
