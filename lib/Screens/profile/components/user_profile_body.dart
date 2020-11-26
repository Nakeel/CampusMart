import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash/blurhash.dart';
import 'package:campus_mart/constants.dart';
import 'package:campus_mart/models/user_info.dart';
import 'package:campus_mart/reusablewidget/custom_dialog.dart';
import 'package:campus_mart/services/database.dart';
import 'package:campus_mart/utils/loader_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import 'profile_info_item.dart';

class UserProfileBody extends StatefulWidget {
  static const String tag = "profileUserInfo";
  static const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  @override
  _UserProfileBodyState createState() => _UserProfileBodyState();
}

File _image;
final picker = ImagePicker();
List<File> images = <File>[];
var _isLoading = false;

class _UserProfileBodyState extends State<UserProfileBody> {
  @override
  void initState() {
    super.initState();
  }

  void _showPicker(context, uuid, userImgUrl) {
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
                        _imgFromGallery(context, uuid, userImgUrl);

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
                      _imgFromCamera(context, uuid, userImgUrl);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _imgFromCamera(context, uuid, userImgUrl) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 10);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        _isLoading = true;
      });
      // getImageHash(_image)
      //     .then((value) => uploadProfileImgToDb(value, _image, uuid, context));
      uploadProfileImgToDb(_image, uuid, context, userImgUrl);
    } else {
      print('No image selected.');
    }
  }

  _imgFromGallery(context, uuid, userImgUrl) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 10);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        _isLoading = true;
      });
      uploadProfileImgToDb(_image, uuid, context, userImgUrl);
      // getImageHash(_image)
      //     .then((value) => uploadProfileImgToDb(value, _image, uuid, context));
    } else {
      print('No image selected.');
    }
    // loadAssets();
  }

  Future<String> uploadImage(String uuid, File itemImageFile) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child('profileImages').child(uuid);
    StorageUploadTask uploadTask = ref.putFile(itemImageFile);

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  Future deleteOldImg(String oldImgUrl) async {
    var fileUrl = Uri.decodeFull(p.basename(oldImgUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference photoRef = await FirebaseStorage.instance
        .ref()
        .getStorage()
        .getReferenceFromUrl(oldImgUrl);
    try {
      await photoRef.delete();
    } catch (e) {}
  }

  uploadProfileImgToDb(File imgFile, String uuid, context, userImgUrl) async {
    uploadImage(uuid, imgFile).then((downloadUrl) {
      DatabaseService().updateProfileImg(downloadUrl, uuid).then((result) {
        if (result == 'Failed') {
          setState(() {
            _isLoading = false;
          });
        } else {
          // if (userImgUrl != null || userImgUrl != "") {
            // deleteOldImg(userImgUrl).whenComplete(() {
              setState(() {
                _isLoading = false;
              });
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                    title: 'Profile Image Update',
                    description:
                        'Profile picture successfully updated',
                    primaryButtonText: 'Close',
                    primaryButtonFunc: () {
                      Navigator.of(context).pop();
                    }),
              );
            // });
          // }
        }
      });
    });
  }

  Future<String> getImageHash(File image) async {
    Uint8List byte = await image.readAsBytes();

    var blurHash = await BlurHash.encode(byte, 4, 3);
    print('ImageHash' + blurHash);
    return blurHash;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<CustomUserInfo>(context);

    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        body: LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: LoaderUtil(),
      child: SingleChildScrollView(
        child: Container(
          color: kPrimaryColor,
          child: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300].withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                // child: null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        child: Text(
                          'Sales and Request',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Product Sans",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Total Sales",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  user.totalSalesAd.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.white,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Total Request",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  user.totalWantsAd.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: size.height * 0.72,
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(30, 25, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3.0),
                        blurRadius: 10.0,
                        spreadRadius: 7.0,
                        color: kPrimaryColor.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ProfileInfoItem(
                        size: size,
                        containerColor: kPrimaryColor,
                        icon: Icons.person,
                        changeImg: true,
                        iconColor: kPrimaryColor,
                        showEdit: false,
                        press: () =>
                            _showPicker(context, user.uuid, user.profileImgUrl),
                        userImgUrl: user.profileImgUrl,
                        infoText: 'Change Profile Image',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(
                        size: size,
                        containerColor: kPrimaryColor,
                        icon: Icons.person,
                        iconColor: kPrimaryColor,
                        changeImg: false,
                        showEdit: false,
                        infoText: user.fullname,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(
                        size: size,
                        containerColor: Colors.deepPurpleAccent,
                        icon: Icons.email,
                        iconColor: Colors.deepPurpleAccent,
                        showEdit: false,
                        changeImg: false,
                        infoText: user.email,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(
                        size: size,
                        changeImg: false,
                        containerColor: Colors.cyan,
                        icon: Icons.phone,
                        iconColor: Colors.cyan,
                        showEdit: true,
                        infoText: user.phone,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ProfileInfoItem(
                        size: size,
                        containerColor: Colors.green,
                        icon: Icons.location_city,
                        iconColor: Colors.green,
                        changeImg: false,
                        showEdit: false,
                        infoText: user.university,
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
            ],
          ),
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //     ],
          //   ),
          // ),
        ),
      ),
    ));
  }
}
