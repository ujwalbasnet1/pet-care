class PhoneAuthInfoModel {
  String phone;
  String otp;
  String createdAt;
  String updatedAt;
  String refer;
  String message;
  PhoneAuthInfoModel(
      {this.phone,
      this.otp,
      this.createdAt,
      this.updatedAt,
      this.refer,
      this.message});

  PhoneAuthInfoModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    otp = json['otp'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    message = json['message'];
    refer = json['refer'];
  }
}
