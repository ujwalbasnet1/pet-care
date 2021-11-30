import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pets/DataModel/phone_auth_info_model.dart';
import 'package:pets/DataModel/user_info_model.dart';
import 'package:pets/service/app_pushs.dart';
import 'package:pets/service/userid_store.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:flutter/material.dart';
import 'package:pets/main.dart';

class ApiService {
  List userid = [];
  String restApi = "http://54.205.113.252:8080";
//
  Future<PhoneAuthInfoModel> postPhoneNumber(String phoneNumber) async {
    var url = restApi + "/api/otp/send";
    var response = await http.post(getUri(url), body: {"phone": phoneNumber});

    var jsonData = json.decode(response.body);
    var phoneAuthData = PhoneAuthInfoModel.fromJson(jsonData);
    return phoneAuthData;
  }

  Future<dynamic> updateUserData(data) async {
    var url = restApi + "/api/otp/update";

    var response = await http.post(getUri(url), body: data);
    // var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<dynamic> sendInvite(data) async {
    var url = restApi + "/api/otp/sendInvite";

    var response = await http.post(getUri(url),
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    // var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<Map> verifyOtp(String phoneNumber, String otpNumber) async {
    // ignore: unused_local_variable
    bool isValid = false;

    var url = restApi + "/api/otp/verify";
    var response = await http.post(getUri(url), body: {
      "phone": phoneNumber,
      "otp": otpNumber,
      "token": obtainedFirebaseToken,
      "refer": referalCode,
    });

    var jsonData = json.decode(response.body);
    var otpInfoData = UserInfoModel.fromJson(jsonData);

    userid.add(jsonData);
    if (otpInfoData.phone != null) {
      // userid.add(jsonData);
      //
      return {"isValid": true, "userData": jsonData};
      // return isValid = true;
    }
    return {"isValid": false};
    // return isValid = false;
  }

  // storeUserId(var jsondat) {
  //   // List
  // }

// Future<UserInfoModel> verifyOtp(String phoneNumber, String otpNumber) async {
//   bool isValid = false;
//   var url = "http://pet.ngrok.io/api/otp/verify";
//   var response =
//   await http.post(url, body: {"phone": phoneNumber, "otp": otpNumber});
//   var jsonData = json.decode(response.body);
//   var otpInfoData = UserInfoModel.fromJson(jsonData);
//
//
//
//
//   return otpInfoData;
// }

  Future<Map> createTask(String taskType, List timeArray) async {
    var url = restApi + "/api/otp/createTasks";
    //
    var body = json.encode({
      "userID": await getUserId(),
      "taskType": taskType,
      "timeArray": timeArray,
      "repeat": true,
      "status": false
    });

    var response = await http.post(getUri(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: body);
    var jsonData = json.decode(response.body);
    return jsonData;
  }

  Future getTasks(String userId) async {
    var url = restApi + "/api/otp/getTasks";
    var body = json.encode({
      "userID": userId.toString(),
    });
    var response = await http.post(getUri(url), body: body, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    //
    var jsonData = json.decode(response.body);
    return jsonData;
  }

  Future sendTast(String task) async {
    var url = restApi + "/api/otp/updateTask";
    var userData = await SharedPref().read("userData");
    var body = json.encode({"taskID": task, "id": userData['_id']});

    var response = await http.post(getUri(url), body: body, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    var jsonData = json.decode(response.body);
    return jsonData;
  }

  Future getPoints(context) async {
    var url = restApi + "/api/otp/getPoints";
    var userData = await SharedPref().read("userData");
    var body = json.encode({"id": userData['_id']});

    var response = await http.post(getUri(url), body: body, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (response.body.toString().length < 10) {
      SharedPref().remove("userData");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Wrapper(),
          ),
          (route) => false);
    }

    var jsonData = json.decode(response.body);

    return jsonData;
  }

  getUserId() async {
    var userData = await SharedPref().read("userData");
    return userData['_id'].toString();
  }
}
