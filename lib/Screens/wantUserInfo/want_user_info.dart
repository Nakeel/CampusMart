import 'dart:async';

import 'package:flutter/material.dart';

class WantUserInfo extends StatefulWidget {
	@override
	WantUserInfoState createState() => new WantUserInfoState();
}

class WantUserInfoState extends State<WantUserInfo>  {
	String transactionPin;

	TextEditingController textEditingController = TextEditingController();


	// final transaction = await Navigator.of(context).push(
	// PageRouteBuilder(
	// opaque: false, // s
	// pageBuilder: (context, animation, secondaryAnimation) => TransactionPin.TransactionPin(),
	// transitionsBuilder: (context, animation, secondaryAnimation, child) {
	// var begin = Offset(0.0, 1.0);
	// var end = Offset.zero;
	// var curve = Curves.ease;
	//
	// var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
	//
	// return SlideTransition(
	// position: animation.drive(tween),
	// child: child,
	// );
	// },
	// )
	// );

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		Size size = MediaQuery.of(context).size;
		return Scaffold(
			backgroundColor: Colors.black.withOpacity(.4),
			body:  Stack(
				children: [
					// Positioned(
					// 	bottom: 0,
					// 		child: Container(
					// 	width: size.width,
					// 			height: size.height * .5,
					// 			decoration: BoxDecoration(
					// 				color: Colors.white,
					// 				borderRadius: BorderRadius.only(
					// 				topRight: Radius.circular(20),
					// 					topLeft: Radius.circular(20),
					// 			),
					// 			),
					// 			child: SingleChildScrollView(
					// 				child: Column(
					// 					children: [
					// 						SizedBox(height: 20,),
					// 						Container(
					// 							width: size.width,
					// 							child:
					// 							Stack(
					// 								children: [
					// 									Center(
					// 										child:
					// 										Text('Transaction Pin',
					// 											style: GoogleFonts.inter(
					// 													fontSize: 18,
					// 													fontWeight: FontWeight.w600
					// 											),
					// 										),
					// 									),
					// 									Positioned(
					// 										right: 15,
					// 										child: GestureDetector(
					// 											onTap: (){
					// 												Navigator.pop(context);
					// 											},
					// 											child: Icon(
					// 												Icons.close,
					// 												color: Colors.black,
					// 											),
					// 										),
					// 									)
					// 								],
					// 							),
					// 						),
					// 						SizedBox(height: 15,),
					// 						Divider(height: 1,thickness: 1.5,),
					// 						SizedBox(height: 30,),
					// 						Padding(padding: EdgeInsets.symmetric(horizontal: 15),
					// 						child: Text('Kindly enter your 5-digits transaction pin to authorized the transaction',
					// 							textAlign: TextAlign.center,
					// 							style: GoogleFonts.inter(
					// 									fontSize: 16,
					// 									fontWeight: FontWeight.w500
					// 							),
					// 						),
					// 						),
					// 						SizedBox(height: 30,),
					//
					//
					// 						PinEntryTextField(
					// 						  fields: 5,
					// 						  showFieldAsBox: true,
					// 						  onSubmit: (String pin) {
					// 						    transactionPin = pin;
					// 								Navigator.of(context).pop(transactionPin);
					// 						  }, // end onSubmit
					// 						),
					// 						SizedBox(height: 20,),
					//
					// 						Wrap(
					// 							children: [
					// 								Text('(Don\'t have pin?'),
					// 								GestureDetector(
					// 									onTap: (){
					// 										Navigator.pushNamed(context, RouteConstant.CREATE_PIN);
					// 									},
					// 									child: Text(' Create New)',
					// 										style: GoogleFonts.inter(
					// 											color: Colors.green,
					// 											fontWeight: FontWeight.w500
					// 										),
					// 									),
					// 								)
					//
					//
					// 							],
					// 						),
					//
					//
					// 						SizedBox(height: 60),
					// 						Center(
					// 							child: GestureDetector(
					// 								onTap: () {
					// 									if(transactionPin.length==5) {
					// 										Navigator.of(context).pop(transactionPin);
					// 									}
					// 								},
					// 								child: Container(
					// 									width: MediaQuery.of(context).size.width * .5,
					// 									height: 50,
					// 									padding: EdgeInsets.only(top: 15),
					// 									decoration: new BoxDecoration(
					// 										color: new Color(0xFF03A438),
					// 										borderRadius: new BorderRadius.all(Radius.circular(25)),
					// 									),
					// 									child: Text(
					// 										"Submit",
					// 										textAlign: TextAlign.center,
					// 										style: TextStyle(
					// 												color: Colors.white,
					// 												fontSize: 15,
					// 												fontWeight: FontWeight.w600),
					// 									),
					// 								),
					// 							),
					// 						),
					//
					// 					],
					// 				),
					// 			),
					// ))
				],
			),
		);
	}
}
