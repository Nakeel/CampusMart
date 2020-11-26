import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class ProfileInfoItem extends StatelessWidget {
  const ProfileInfoItem({
    Key key,
    @required this.size,
    this.icon,
    this.iconColor,
    this.containerColor,
    this.infoText,
    this.showEdit,
    this.press,
    this.userImgUrl,
    this.changeImg,
  }) : super(key: key);

  final Size size;
  final IconData icon;
  final Color iconColor, containerColor;
  final String infoText;
  final String userImgUrl;
  final bool showEdit;
  final bool changeImg;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      child: InkWell(
        onTap: changeImg ? press : () {},
        splashColor: kPrimaryColor.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: changeImg
                      ? EdgeInsets.all(5)
                      : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: containerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    // shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                        color: containerColor.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: changeImg
                      ? userImgUrl !='' ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image(
                            image: NetworkImage(userImgUrl),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )) :  Icon(
                          Icons.person_outline_sharp,
                          size: 40,
                          color: iconColor,
                        )
                      : Icon(
                          icon,
                          size: 30,
                          color: iconColor,
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  infoText,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Visibility(
              visible: showEdit,
              child: FlatButton(
                onPressed: press,
                splashColor: kPrimaryColor.withOpacity(0.3),
                child: Text(
                  'Edit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
