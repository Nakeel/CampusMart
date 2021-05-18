import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoDialogWidget extends StatefulWidget {
  final String title,
      description,
      primaryButtonText,
      secButtonTxt,
      infoIcon,
      infoType;

  final Function primaryButtonFunc, secButtonFunc;
  InfoDialogWidget({
    Key key,
    this.title,
    this.description,
    this.primaryButtonText,
    this.secButtonTxt,
    this.infoIcon,
    this.primaryButtonFunc,
    this.secButtonFunc,
    this.infoType,
  }) : super(key: key);

  @override
  _InfoDialogWidgetState createState() => _InfoDialogWidgetState();
}

class _InfoDialogWidgetState extends State<InfoDialogWidget> {
  bool showDialog = false;

  showAgain(bool showDialog) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.infoType, showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
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
                    height: 10,
                  ),
                  AutoSizeText(
                    widget.title,
                    maxLines: 1,
                    minFontSize: 18,
                    maxFontSize: 24,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  widget.infoIcon == null
                      ? Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.error_outline_outlined,
                            size: 120,
                            color: kPrimaryColor,
                          ),
                        )
                      : Image.asset(
                          widget.infoIcon,
                          height: 130,
                          width: 130,
                        ),
                  SizedBox(
                    height: 20,
                  ),

                  AutoSizeText(
                    widget.description,
                    maxLines: 3,
                    minFontSize: 14,
                    maxFontSize: 18,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: showDialog,
                        onChanged: (show) {
                          showAgain(showDialog);
                          setState(() {
                            showDialog = show;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      Expanded(
                          child: Text(
                        'Don\'t show again',
                        softWrap: true,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child:

                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child:  RaisedButton(
                        //     onPressed: primaryButtonFunc,
                        //     color: Constants.primaryColor,
                        //
                        //     splashColor: Constants.primaryColor.withOpacity(.2),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 20),
                        //       child: AutoSizeText(
                        //         primaryButtonText,
                        //         maxLines: 1,
                        //         style: GoogleFonts.inter(
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.w200,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //
                        // SizedBox(
                        //   height: 15,
                        // ),
                        Center(
                      child: RaisedButton(
                        // onPressed: widget.primaryButtonFunc,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: kPrimaryColor,
                        splashColor: kPrimaryColor.withOpacity(.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: AutoSizeText(
                            widget.primaryButtonText,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // showSecondaryButton()
                ],
              ),
            ),
            // Positioned(
            //   right: -2,
            //     top: 0,
            //     child: GestureDetector(
            //   onTap: (){
            //     Navigator.pop(context);
            //   },
            //   child: Icon(
            //     Icons.cancel_outlined,
            //     color: Constants.primaryColor,
            //     size: 40,
            //   ),
            // ))
          ],
        ));
  }

  showSecondaryButton() {
    if (widget.secButtonFunc != null && widget.secButtonTxt != null) {
      return FlatButton(
          onPressed: widget.secButtonFunc,
          child: AutoSizeText(
            widget.secButtonTxt,
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
