import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class ItemCategory extends StatelessWidget {
  const ItemCategory({
    Key key, this.catName, this.imgdir, this.leadingColor, this.endColor, this.press,
  }) : super(key: key);
  final String catName, imgdir;
  final Color leadingColor, endColor;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
          child: Container(
        margin: EdgeInsets.only(bottom: kDefaultPadding / 0.7),
        // This will return 20% of our total height
        height: size.height * 0.2,
        width: size.width * 0.4,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                gradient: new LinearGradient(
                  // 'assets/images/gadgets.png'Colors.grey[500], Colors.grey[200]
                    colors: [endColor,leadingColor],
                    begin: Alignment.centerRight,
                    end: new Alignment(-1.0, -1.0)),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(top: 10, right: 40, bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    catName,
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(imgdir),
            )
          ],
        ),
      ),
    );
  }

}
