import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blurhash/blurhash.dart';
// import 'package:campus_mart/blurhash.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/custom_alert.dart';
import 'package:campus_mart/utils/dialog_widget.dart';
import 'package:campus_mart/utils/info_dialog.dart';
import 'package:campus_mart/utils/institution.dart';
import 'package:campus_mart/utils/loader_util.dart';
import 'package:campus_mart/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

class AddAdPostMain extends StatefulWidget {
  static const TextStyle userNameStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _AddAdPostMainState createState() => _AddAdPostMainState();
}

class _AddAdPostMainState extends State<AddAdPostMain> {
  String _username;
  String _featureTyped;
  int _count = 3;
  List<String> _featureList = List<String>();
  List<String> _imageList = List<String>();
  String ProductTitle, ProductDesc, ProductPrice;
  String selectedCategory , selectedCondition = '';
  int selectedConditionIndex = 0;
  bool isNegotiable = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1), ()=>  isShowDialogAgain());
      // getUserData();
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  int _selectedIconIndex = 0;
  int _selectedImgIndex = 0;

  bool isSwitched = false;

  bool _isLoading = false;
  int priceOfProduct = 1000;

  var scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _productFeatureController =
      new TextEditingController();
  TextEditingController _productTitleController = TextEditingController();
  TextEditingController _productDescController = TextEditingController();
  TextEditingController _productAmountController = TextEditingController();

  String selectedUniversity;




  Padding buildConditionType(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child:
          GestureDetector(
            onTap: () {
              setState(() {
                selectedConditionIndex = index;
                selectedCondition = conditionList[index];
              });
            },
            child: Container(

              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                color: index == selectedConditionIndex ? kPrimaryColor: Colors.white ,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                border: Border.all(
                  color: index == selectedConditionIndex
                      ? Colors.white
                      : kPrimaryColor.withOpacity(0.4),
                  width: 1, ),
              ),
              child:Center(
                child:  Text(conditionList[index],
                    style: TextStyle(
                        color: index == selectedConditionIndex
                            ? Colors.white
                            : kPrimaryColor.withOpacity(0.4),
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
              )

            ) ,
          ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: kPrimaryColor,
                      ),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Delete()));

                        Navigator.of(context).pop();
                      }),
                  new Divider(),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: kPrimaryColor,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  File _image;
  final picker = ImagePicker();
  List<File> images = <File>[];
  List<String> imgHashList = <String>[];

  Future _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 45);


      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
        images.add(_image);
        _isLoading = true;
        });
        getImageHash(_image).then((value) {
          setState(() {
            _isLoading = false;
          });
          imgHashList.add(value);
        });
      } else {
        print('No image selected.');
      }
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 35);

      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          images.add(_image);
          _isLoading = true;
        });
        getImageHash(_image).then((value) {
          setState(() {
            _isLoading = false;
          });
          imgHashList.add(value);
        });
      } else {
        print('No image selected.');
      }
    // loadAssets();
  }

  _deleteImageList(int index) {
    setState(() {
      print('ImageH0' + images.length.toString() + index.toString());
      images = List.from(images)..removeAt(index);
      imgHashList = List.from(imgHashList)..removeAt(index);

      print('Image0' + images.length.toString());
    });
  }

  Future<String> uploadImage(
      String uuid, File ProductImageFile, String name) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child('goods').child(uuid).child(name);
    StorageUploadTask uploadTask = ref.putFile(ProductImageFile);

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref
        .getDownloadURL()
        .then((value) => print("Storage Yes+" + value))
        .catchError((error) {
      print("StorageError" + error);
    });
    print("Storage" + storageTaskSnapshot.ref.getDownloadURL().toString());
    print("Storage Error" + storageTaskSnapshot.error.toString());
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  uploadMutliImg(List<File> imgListFile, CustomUserInfo user) async {
    
    if (imgListFile.length>=4) {
      setState(() {
        _isLoading = true;
      });
      List<String> uploadUrlList = [];
      int imgIndex = 0;
      DateTime now = DateTime.now();
      String currentDate = DateFormat('kk:mm dd-MMM-yyyy').format(now);

      imgListFile.forEach((imgFile) {
        uploadImage(user.uuid, imgFile, ProductTitle + imgIndex.toString())
            .then((downloadUrl) {
          uploadUrlList.add(downloadUrl);
          if (images.length == uploadUrlList.length) {
            DatabaseService()
                .postGoodsData(
                user.fullname,
                user.uuid,
                user.university,
                ProductTitle,
                currentDate,
                ProductDesc,
                selectedCategory,
                priceOfProduct.toString(),
                user.phone,
                selectedCondition,
                isNegotiable,
                uploadUrlList,
                imgHashList,
                _featureList,
                false,
                false)
                .then((result) {
              if (result == 'Failed') {
                setState(() {
                  _isLoading = false;
                });
              } else {
                Timer(Duration(seconds: 3), () {
                  DatabaseService()
                      .updateUserSalesAdData(
                    user.uuid,
                  )
                      .then((result) {
                    if (result == 'Failed') {
                      print('updateData' + result.toString());
                    } else {
                      print('updateData ' + 'success');
                    }
                  });
                  setState(() {
                    _isLoading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CustomDialog(
                            title: 'Post Successfully added',
                            description:
                            'You successfully added a new sales ad will run for a period of 15days if sold before then please notify',
                            primaryButtonText: 'Close',
                            primaryButtonFunc: () {
                              print(
                                  'ClearText ' + _selectedIconIndex.toString());
                              clearText();
                              Navigator.of(context).pop();
                            }),
                  );
                });
              }
            });
          }
        });
        imgIndex++;
      });
    }else{
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Product Image must be up to 4'),
        ),
      );
    }
  }

  clearText() {
    print('ClearText ' + _selectedIconIndex.toString());
    setState(() {
      _selectedIconIndex = 0;
      images = [];
      _featureList = [];
      priceOfProduct = 1000;
      isNegotiable = false;
    });
    print('ClearText ' + _selectedIconIndex.toString());
    _productDescController.clear();
    _productTitleController.clear();
  }

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIconIndex = index;
          selectedCategory = categoryList[index];
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: _selectedIconIndex == index ? 70 : 60,
                  width: _selectedIconIndex == index ? 70 : 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(50),
                    // ),
                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: _selectedIconIndex == index ? 5.0 : 3.0,
                        spreadRadius: _selectedIconIndex == index ? 2.0 : 1.0,
                        color: kPrimaryColor.withOpacity(0.4),
                      )
                    ],
                    //   image: DecorationImage(
                    //       image: AssetImage("assets/images/img.png"),
                    //       fit: BoxFit.cover,
                    //       alignment: Alignment.centerLeft),
                  ),
                  child: Icon(
                    iconList[index],
                    color: _selectedIconIndex == index
                        ? kPrimaryColor
                        : kPrimaryLightColor,
                    size: _selectedIconIndex == index ? 30 : 25,
                  ),
                ),
                Positioned(
                  right: 1,
                  child: Visibility(
                    visible: _selectedIconIndex == index,
                    child: Icon(
                      Icons.check_circle,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              categoryList[index],
              style: TextStyle(
                  fontSize: 18,
                  color: _selectedIconIndex == index
                      ? kPrimaryColor
                      : kPrimaryLightColor,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget dynamicChips() {
    // if (_featureList != null) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      alignment: WrapAlignment.start,
      children: List<Widget>.generate(_featureList.length, (index) {
        return Chip(
          label: Text(_featureList[index]),
          deleteIconColor: kPrimaryColor,
          backgroundColor: kPrimaryColor.withOpacity(0.2),
          elevation: 2,
          onDeleted: () {
            setState(() {
              _featureList.removeAt(index);
            });
          },
        );
      }),
    );
    // } else {
    //   return Container();
    // }
  }


  isShowDialogAgain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(RouteConstant.ADD_PRODUCT) ?? true
        ? _showInfoDialog(context)
        : null;
  }

  _showInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => InfoDialogWidget(
            title: 'Add New Products',
            description:
            'Create new product advert for potential buyers around you to purchase and earn on the go',
            primaryButtonText: 'Learn More',
            infoType: RouteConstant.ADD_PRODUCT,
            infoIcon: 'assets/icons/onlineadvertising.png',
            primaryButtonFunc: () {
              Navigator.of(context).pop();
            }));
  }

  Future<String> getImageHash(File image) async {
    Uint8List byte = await image.readAsBytes();

   var blurHash = await BlurHash.encode(byte, 4, 3);
   print('ImageHash' + blurHash);
    return blurHash;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUserInfo>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: LoaderUtil(),
      child: Scaffold(
        key: scaffoldKey,
        body: Form(
          key: _formKey,
          child: Container(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 10, 70),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 5.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.adjust,
                                    color: Colors.grey[300],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Choose Category',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: size.width,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: iconList
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) => _buildIcon(e.key),
                                    )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.text_format,
                                    color: Colors.grey[350],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Product Title',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                // height: size.height * 0.2,
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(3.0, 3.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                      color: kPrimaryColor.withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child:
                                // Center(
                                //     child:
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        ProductTitle = value;
                                      });
                                    },
                                    controller: _productTitleController,
                                    textAlign: TextAlign.justify,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      hintText: 'Enter title of the Product',
                                      hintStyle:
                                      TextStyle(color: Colors.grey[400]),
                                      disabledBorder: InputBorder.none,
                                      // counter: Offstage()
                                    ),
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  ),
                                ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.monetization_on_outlined,
                                    color: Colors.grey[350],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Product Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                // height: size.height * 0.2,
                                width: size.width * 0.85,
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(-2.5, 3.0),
                                      blurRadius: 1.5,
                                      spreadRadius: 1.5,
                                      color: kPrimaryColor.withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child:
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 0),
                                        child: PriceCounter(
                                          decreasePrice: () {
                                            if (priceOfProduct > 100) {
                                              setState(() {
                                                priceOfProduct -= 100;
                                              });
                                            }
                                          },
                                          changeAmount: (){
                                            showDialog(
                                              context: context,
                                              builder: (context) => CustomAlert(
                                                child: CustomAlertDialogWidget(
                                                  alertTitle: 'Product Price',
                                                  alertDesc: 'Enter desired price for your product',
                                                  positiveBtnFunc: (){
                                                    setState(() {
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  positiveBtnText: 'Confirm Price',
                                                  textController: _productAmountController,
                                                  onTextChange: (amount){
                                                    priceOfProduct = int.parse(amount);
                                                  },
                                                  enteredText: priceOfProduct.toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          increasePrice: () {
                                            setState(() {
                                              priceOfProduct += 100;
                                            });
                                          },
                                          productPrice: priceOfProduct,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Negotiable',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600]),
                                              ),
                                              // SizedBox(
                                              //   height: 5,
                                              // ),
                                              Switch(
                                                value: isNegotiable,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isNegotiable = value;
                                                    print(isNegotiable);
                                                  });
                                                },
                                                activeTrackColor:
                                                kPrimaryColor.withOpacity(0.5),
                                                activeColor: kPrimaryColor,
                                              ),
                                            ],
                                          ),

                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.text_format,
                                    color: Colors.grey[350],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Product Description',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: size.height * 0.2,
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  // shape: BoxShape.circle,

                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(3.0, 3.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                      color: kPrimaryColor.withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child:
                                // Center(
                                //     child:
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: TextFormField(
                                    textAlign: TextAlign.justify,
                                    onChanged: (value) {
                                      setState(() {
                                        ProductDesc = value;
                                      });
                                    },
                                    maxLines: 4,
                                    maxLength: 100,
                                    controller: _productDescController,
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        hintText: 'Enter description of the Product',
                                        hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                        disabledBorder: InputBorder.none,
                                        counter: Offstage()),
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  ),
                                ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    color: Colors.grey[350],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Select Institution',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  // shape: BoxShape.circle,

                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(3.0, 3.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                      color: kPrimaryColor.withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text(
                                      "Choose nearest Institution",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    value: selectedUniversity,
                                    iconEnabledColor: kPrimaryColor,
                                    onChanged: (String Value) {
                                      setState(() {
                                        selectedUniversity = Value;
                                      });
                                    },
                                    items: institutionList.map((String user) {
                                      return DropdownMenuItem<String>(
                                          value: user,
                                          child: Text(
                                            user,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ));
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.photo_album,
                                    color: Colors.grey[350],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Add Product Photos',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            // shape: BoxShape.circle,

                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(3.0, 3.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0,
                                                color: kPrimaryColor
                                                    .withOpacity(0.3),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              _showPicker(context);
                                            },
                                            splashColor:
                                            kPrimaryColor.withOpacity(0.4),
                                            child: Icon(
                                              Icons.photo_camera,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: List.generate(images.length,
                                                  (index) {
                                                return Stack(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(5),
                                                      margin: EdgeInsets.all(8),
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                        // shape: BoxShape.circle,

                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset: const Offset(
                                                                3.0, 3.0),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 2.0,
                                                            color: kPrimaryColor
                                                                .withOpacity(0.3),
                                                          )
                                                        ],
                                                      ),
                                                      child: Image.file(
                                                        images[index],
                                                        width: 90,
                                                        height: 90,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(10),
                                                              ),
                                                              // shape: BoxShape.circle,

                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                  const Offset(
                                                                      3.0, 3.0),
                                                                  blurRadius: 10.0,
                                                                  spreadRadius: 2.0,
                                                                  color: kPrimaryColor
                                                                      .withOpacity(
                                                                      0.3),
                                                                )
                                                              ],
                                                            ),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                print('ImageM0' +
                                                                    images.length
                                                                        .toString());
                                                                _deleteImageList(
                                                                    index);
                                                              },
                                                              // splashColor: kPrimaryColor
                                                              //     .withOpacity(0.4),
                                                              child: Icon(
                                                                Icons.delete,
                                                                color: Colors.red,
                                                              ),
                                                            )))
                                                  ],
                                                );
                                              }),
                                          //   ),
                                          // ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 0.0),
                            child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.grey[350],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 15, left: 10),
                                        child: Text(
                                          'Product Condition',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: conditionList.length,
                                        itemBuilder: (context, index) =>
                                            buildConditionType(index, context)),
                                  ),
                                ]
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.text_format,
                                    color: Colors.grey[350],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15, left: 10),
                                    child: Text(
                                      'Product Features',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Container(
                                  // height: size.height * 0.25,
                                  width: size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    // shape: BoxShape.circle,

                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(3.0, 3.0),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                        color: kPrimaryColor.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _featureTyped = value;
                                                });
                                              },
                                              controller: _productFeatureController,
                                              textAlign: TextAlign.justify,
                                              decoration: new InputDecoration(
                                                focusedBorder:
                                                UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryLightColor,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: InputBorder.none,
                                                // errorBorder: InputBorder.none,
                                                hintText:
                                                'Add feature (e.g Size, Color, etc)',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                                disabledBorder: InputBorder.none,
                                                // counter: Offstage()
                                              ),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            width: size.width,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(right: 10),
                                            child: UnconstrainedBox(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: FlatButton(
                                                    onPressed: () {
                                                      if (_featureTyped != null) {
                                                        // _formKey.currentState
                                                        //     .reset();
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        _productFeatureController
                                                            .clear();
                                                        setState(() {
                                                          _featureList
                                                              .add(_featureTyped);
                                                        });
                                                        print(
                                                            _featureList.length);
                                                      }
                                                    },
                                                    color: kPrimaryColor,
                                                    splashColor:
                                                    kPrimaryLightColor,
                                                    shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(
                                                            30.0)),
                                                    child: Text(
                                                      'Add',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.w800,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      dynamicChips(),
                                    ],
                                  ),
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => FocusScope.of(context).unfocus(),
                      onPanDown: (_) => FocusScope.of(context).unfocus(),
                      child: Container(
                        width: size.width,
                        child: Center(
                          child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.25, vertical: 10),
                              onPressed: () {
                                uploadMutliImg(images, user);
                              },
                              // onPressed: (){},
                              color: kPrimaryColor,
                              splashColor: kPrimaryLightColor,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)),
                              child: Text(
                                'Post Ad',
                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              )),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      )
    );
  }
}

class PriceCounter extends StatelessWidget {
  PriceCounter(
      {Key key, this.productPrice, this.decreasePrice, this.increasePrice, this.changeAmount})
      : super(key: key);
  final int productPrice;
  final Function decreasePrice, increasePrice,changeAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildOutlineButton(
          icon: Icons.remove,
          press: decreasePrice,
        ),
        InkWell(
          onTap: changeAmount,
          child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            child:
      AutoSizeText(
        '\u{20A6}$productPrice',
        minFontSize: 10,
        maxLines: 2,
        maxFontSize: 15,
        style: Theme.of(context).textTheme.headline6,
        overflow: TextOverflow.ellipsis,
      )

          ) ,
        ),
        buildOutlineButton(
          icon: Icons.add,
          press: increasePrice,
        )
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        onPressed: press,
        padding: EdgeInsets.zero,
        color: kPrimaryColor,
        splashColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Icon(
          icon,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
