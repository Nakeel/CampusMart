import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  const CustomAlertDialogWidget({
    Key key, this.alertTitle, this.alertDesc, this.positiveBtnText, this.negativeBtnText, this.positiveBtnFunc, this.negativeBtnFunc, this.enteredText, this.onTextChange, this.textController,
  }) : super(key: key);

  final String alertTitle, alertDesc, positiveBtnText,negativeBtnText,enteredText;
  final Function positiveBtnFunc, negativeBtnFunc;
  final ValueChanged onTextChange;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    textController.text = enteredText;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 15),
          Text(
            alertTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 25),
          Center(
            child:
            Text(
              alertDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 25),
          Container(
            // height: size.height * 0.2,
            // width: size.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(3.0, 3.0),
                  blurRadius: 3.0,
                  spreadRadius: 1.0,
                  color: kPrimaryColor.withOpacity(0.3),
                )
              ],
            ),
            child:
          //   // Center(
          //   //     child:
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: 0),
              child: TextFormField(
                onChanged: onTextChange,
                controller: textController,
                textAlign: TextAlign.justify,
                maxLength: 8,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintText: '0.0',
                  counterText: '',
                  hintStyle:
                  TextStyle(color: Colors.grey[400]),
                  disabledBorder: InputBorder.none,
                  // counter: Offstage()
                ),
                style: TextStyle(
                    fontSize: 18, color: Colors.black),
              ),
            ),
            // ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 40,
                width: 130,
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  borderSide:
                  BorderSide(color: kPrimaryColor),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.white,
                ),
              ),
              Container(
                height: 40,
                width: 130,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    positiveBtnText,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: positiveBtnFunc ,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
