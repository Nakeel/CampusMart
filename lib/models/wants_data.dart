import 'package:cloud_firestore/cloud_firestore.dart';

class Wants {
   String uid;
   String email;
   String phone;
 String university;
   String fullname, username, colorId,datePosted,category,post;

  Wants.fromMap(Map<String, dynamic> data){
    uid = data['uuid'];
    email = data['email'];
    phone = data['phone'];
    university = data['university'];
    colorId = data['colorId'];
    fullname = data['fullname'];
    username = data['username'];
    datePosted = data['datePosted'];
    post = data['post'];
    category = data['category'];
  }
  
}
