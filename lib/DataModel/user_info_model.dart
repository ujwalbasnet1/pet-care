class UserInfoModel {
  String phone;
  String fName;
  String lName;

  UserInfoModel({this.phone, this.fName, this.lName});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    fName = json['fName'];
    lName = json['lName'];
  }
}
