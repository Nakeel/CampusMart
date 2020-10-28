import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash/blurhash.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/loader_util.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String itemTitle, itemDesc, itemPrice;
  String selectedCategory;
  bool isNegotiable = false;

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  int _selectedIconIndex = 0;
  int _selectedImgIndex = 0;

  bool isSwitched = false;

  bool _isLoading = false;
  int priceOfItem = 1000;

  final TextEditingController _itemFeatureController =
      new TextEditingController();
  TextEditingController _itemTitleController = TextEditingController();
  TextEditingController _itemDescController = TextEditingController();

  String selectedUniversity;

  List<IconData> _iconList = [
    Icons.access_time,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.accessible,
    Icons.add_alarm,
    Icons.airplay,
  ];

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

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        images.add(_image);
        getImageHash(_image).then((value) => imgHashList.add(value));
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 35);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        images.add(_image);
        getImageHash(_image).then((value) => imgHashList.add(value));
      } else {
        print('No image selected.');
      }
    });
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
      String uuid, File itemImageFile, String name) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child('goods').child(uuid).child(name);
    StorageUploadTask uploadTask = ref.putFile(itemImageFile);

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
    setState(() {
      _isLoading = true;
    });
    List<String> uploadUrlList = [];
    int imgIndex = 0;
    DateTime now = DateTime.now();
    String currentDate = DateFormat('kk:mm dd-MMM-yyyy').format(now);

    imgListFile.forEach((imgFile) {
      uploadImage(user.uuid, imgFile, itemTitle + imgIndex.toString())
          .then((downloadUrl) {
        uploadUrlList.add(downloadUrl);
        if (images.length == uploadUrlList.length) {
          DatabaseService()
              .postGoodsData(
                  user.fullname,
                  user.uuid,
                  user.university,
                  itemTitle,
                  currentDate,
                  itemDesc,
                  selectedCategory,
                  priceOfItem.toString(),
                  user.phone,
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
                  builder: (context) => CustomDialog(
                      title: 'Post Successfully added',
                      description:
                          'You successfully added a new sales ad will run for a period of 15days if sold before then please notify',
                      primaryButtonText: 'Close',
                      primaryButtonFunc: () {
                        print('ClearText ' + _selectedIconIndex.toString());
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
  }

  clearText() {
    print('ClearText ' + _selectedIconIndex.toString());
    setState(() {
      _selectedIconIndex = 0;
      images = [];
      _featureList = [];
      priceOfItem = 1000;
      isNegotiable = false;
    });
    print('ClearText ' + _selectedIconIndex.toString());
    _itemDescController.clear();
    _itemTitleController.clear();
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
                    _iconList[index],
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
      child: Form(
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
                                  children: _iconList
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
                                    'Item Title',
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
                                      itemTitle = value;
                                    });
                                  },
                                  controller: _itemTitleController,
                                  textAlign: TextAlign.justify,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    hintText: 'Enter title of the item',
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
                                  Icons.text_format,
                                  color: Colors.grey[350],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15, left: 10),
                                  child: Text(
                                    'Item Price',
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
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 0),
                                    child: PriceCounter(
                                      decreasePrice: () {
                                        if (priceOfItem > 100) {
                                          setState(() {
                                            priceOfItem -= 100;
                                          });
                                        }
                                      },
                                      increasePrice: () {
                                        setState(() {
                                          priceOfItem += 100;
                                        });
                                      },
                                      itemPrice: priceOfItem,
                                    ),
                                  ),
                                  Container(
                                    child: Positioned(
                                      right: 5,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Negotiable',
                                            style: TextStyle(
                                                fontSize: 14,
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
                                    ),
                                  ),
                                ],
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
                                  Icons.text_format,
                                  color: Colors.grey[350],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15, left: 10),
                                  child: Text(
                                    'Item Description',
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
                                      itemDesc = value;
                                    });
                                  },
                                  maxLines: 4,
                                  maxLength: 100,
                                  controller: _itemDescController,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      hintText: 'Enter description of the item',
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
                                  Icons.photo_album,
                                  color: Colors.grey[350],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15, left: 10),
                                  child: Text(
                                    'Select University',
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
                                    "Choose nearest University",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  value: selectedUniversity,
                                  iconEnabledColor: kPrimaryColor,
                                  onChanged: (String Value) {
                                    setState(() {
                                      selectedUniversity = Value;
                                    });
                                  },
                                  items: universityList.map((String user) {
                                    return DropdownMenuItem<String>(
                                        value: user,
                                        child: Text(
                                          user,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18,
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
                                    'Add Item Photos',
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
                                  Icons.text_format,
                                  color: Colors.grey[350],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15, left: 10),
                                  child: Text(
                                    'Item Features',
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
                                            controller: _itemFeatureController,
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
                                                  'Add feature (e.g Fairly Used)',
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
                                                      _itemFeatureController
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
    );
  }
}

class PriceCounter extends StatelessWidget {
  PriceCounter(
      {Key key, this.itemPrice, this.decreasePrice, this.increasePrice})
      : super(key: key);
  final int itemPrice;
  Function decreasePrice, increasePrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildOutlineButton(
          icon: Icons.remove,
          press: decreasePrice,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Text(
            '\u{20A6}$itemPrice',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
          icon: Icons.add,
          press: increasePrice,
        )
      ],
    );
  }

  // if (itemPrice > 100) {
  //               setState(() {
  //                 itemPrice -= 100;
  //               });
  //             }

  // setState(() {
  //   itemPrice += 100;
  // });

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
