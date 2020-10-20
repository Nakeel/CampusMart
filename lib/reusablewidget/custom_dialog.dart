import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/reusablewidget/clip_container.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, primaryButtonText, secButtonTxt;

  final Function primaryButtonFunc, secButtonFunc;

  const CustomDialog(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.primaryButtonText,
      this.secButtonTxt,
      @required this.primaryButtonFunc,
      this.secButtonFunc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(kDefaultPadding),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15,
                ),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryColor, fontSize: 25.0),
                ),
                SizedBox(
                  height: 25,
                ),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 18.0),
                ),
                SizedBox(
                  height: 25,
                ),
                RaisedButton(
                  onPressed: primaryButtonFunc,
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AutoSizeText(
                    primaryButtonText,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showSecondaryButton()
                
              ],
            ),
          )
          
    );
  }

  showSecondaryButton() {
    if (secButtonFunc != null && secButtonTxt != null) {
      return FlatButton(
          onPressed: () {},
          child: AutoSizeText(
            secButtonTxt,
            maxLines: 1,
            style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
                fontWeight: FontWeight.w400),
          ));
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }
}
