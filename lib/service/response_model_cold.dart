class ResponseModel {
  String message;
  dynamic status;
  dynamic result;
  dynamic data;

  ResponseModel({this.message, this.status, this.result});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    result = json['result'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
