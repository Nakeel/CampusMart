class UserData {

  final String uid;

  UserData(this.uid);

  UserData.fromJson(Map<String, dynamic> json)
      : uid = json['uuid'];

  Map<String, dynamic> toJson() =>
    {
      'uuid': uid,
    };
}