class CustomUserInfo {
  // final String uid;
   String email;
  String  phone;
   String university;
   String fullname, username;
 String uuid;
 int totalSalesAd;
 int totalWantsAd;

  // CustomUserInfo(this.email, this.phone, this.university, this.fullname,
  //     this.username, this.uuid);
  
  CustomUserInfo.fromMap(Map<String, dynamic> data) {
    uuid = data['uuid'];
    email = data['email'];
    university = data['university'];
    phone = data['phone'];
    fullname = data['fullname'];
    username = data['username'];
    totalSalesAd = data['totalSalesAd'];
    totalWantsAd = data['totalWantsAd'];
  }

}
