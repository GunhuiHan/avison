class User {
  final String uid;

  User({
    this.uid,
  });
}

class UserData {
  final String uid;
  final String userName;
  final String userRoom;
  final String userEmail;

  UserData({this.uid, this.userName, this.userRoom, this.userEmail});
}

class UserValidate {
  String key;
  String name;
  String room;
  UserValidate({this.key, this.name, this.room});
}
