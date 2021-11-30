import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pets/utils/app_utils.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pets/service/userid_store.dart';
import 'response_model.dart';
import 'package:pets/utils/static_variables.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:pets/service/app_pushs.dart';
import 'package:pets/common/errorMessageDialog.dart';
import '../main.dart';

class RestRouteApi {
  ///```
  /// RestRouteApi(context,remotePath,api(optional)).get/post/patch/delete
  /// ```
  /// ```
  /// BuildContext context
  /// String path
  /// api
  /// ````

  // String remoteApi = "http://mypetslife.ngrok.io";
  // String remoteApi = "http://15.206.206.130:8002";
  String remoteApi = "http://13.235.59.191:8003";
  String api = "";
  final BuildContext context;
  final String path;
  String url;

  RestRouteApi(this.context, this.path, {this.api = ""}) {
    if (api != "") {
      remoteApi = api;
    }
    url = remoteApi + path;
    log(url);
  }

  sendEvent(eventName, isEvent) async {
    String deviceId = await PlatformDeviceId.getDeviceId;
    var userData = await SharedPref().read("userData");
    var userId = userData['user']['_id'];
    var body = {
      "id": userId,
      "eventName": eventName,
      "deviceId": deviceId,
      'isEvent': isEvent
    };
    await http.post(getUri(url), body: jsonEncode(body), headers: getHeader());
  }

  getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  ///For Get request from remote server
  Future<dynamic> get() async {
    try {
      final res = await http.get(getUri(url), headers: getHeader());
      return await serverResponse(res);
    } catch (error) {
      print(error);
      catchMessage(error);
    }
    return null;
  }

  ///For Get request from remote server
  ///dynamic params
  ///
  Future<ResponseModel> post(body) async {
    try {
      final res =
          await http.post(getUri(url), body: body, headers: getHeader());
      return returnResponse(res);
    } catch (error) {
      print(error);
      catchMessage(error);
    }
    return null;
  }

  Future<dynamic> sendOtp(body) async {
    try {
      final res =
          await http.post(getUri(url), body: body, headers: getHeader());
      return await serverResponse(res);
    } catch (error) {
      print(error);
      catchMessage(error);
    }
    return null;
  }

  ///For updating/patching remote content
  ///id should be provided in path
  Future<ResponseModel> patch(body) async {
    try {
      final res =
          await http.patch(getUri(url), body: body, headers: getHeader());
      return returnResponse(res);
    } catch (error) {
      print(error);
      catchMessage(error);
    }
    return returnError();
  }

  ///For deleting remote content
  ///id should be provided in path
  Future<ResponseModel> delete() async {
    try {
      final res = await http.delete(getUri(url), headers: getHeader());
      return returnResponse(res);
    } catch (error) {
      print(error);
      catchMessage(error);
    }
    return null;
  }

  isEmpty(value) {
    if (value == null) return true;
    if (value.toString() == "") return true;
    return false;
  }

  Future<ResponseModel> aboutYou(body) async {
    print(getUri(url));
    var request = http.MultipartRequest('POST', Uri.parse(url));
    try {
      //Header....
      // token =
      //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwNjc1ZjZlNGI4NGUwMTZmMmE0Mzg4ZiIsInBob25lIjoiKzkxOTE3NTM2NTI0NyIsImlhdCI6MTYxNzQzNjIyNywiZXhwIjoxNjI2MDc2MjI3fQ.zjPw6zedNH38fFbOKjmW4h6GR-690IPAi4BgWgTnoms";
      request.headers['token'] = token;
      body['lname'] = "";
      if (!isEmpty(body['lname'])) {
        request.fields['lname'] = body['lname'] ?? "";
      }
      if (!isEmpty(body['fullname'])) {
        request.fields['fname'] = body['fullname'] ?? "";
      }
      if (!isEmpty(body['gender'])) {
        request.fields['gender'] = body['gender'] ?? "";
      }
      if (!isEmpty(body['email'])) {
        request.fields['email'] = body['email'] ?? "";
      }
      if (body['avatar'].toString().length > 10) {
        File file = body['avatar'];
        request.files.add(http.MultipartFile.fromBytes(
          'avatar',
          file.readAsBytesSync(),
          filename: file.path.split("/").last,
          contentType: MediaType("image", file.path.split(".").last),
        ));
      }
      print(request.fields);
      var response = await request.send();
      final res = await http.Response.fromStream(response);
      return returnResponse(res);
    } catch (error) {
      catchMessage(error);
      print(error);
    }
    return returnError();
  }

  Future<ResponseModel> addPet(body, {breed, type}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['token'] = token;
      if (!isEmpty(body['type'])) {
        request.fields['type'] = body['type'] ?? "";
      }
      if (!isEmpty(body['name'])) {
        request.fields['name'] = body['name'] ?? "";
      }
      if (!isEmpty(body['breed'])) {
        request.fields['breed'] = breed ?? body['breed'] ?? "";
      }
      if (!isEmpty((body['weight'] ?? 0).toString())) {
        request.fields['weight'] = (body['weight'] ?? 0).toString();
      }
      if (!isEmpty(body['birthdata'].toString())) {
        request.fields['birthdata'] = body['birthdata'].toString() ?? "";
      }
      if (!isEmpty(body['gender'])) {
        request.fields['gender'] = body['gender'] ?? "";
      }
      if (!isEmpty(body['image'].toString())) {
        if (body['image'].toString().length > 10) {
          File file = body['image'];
          request.files.add(http.MultipartFile.fromBytes(
            'avatar',
            file.readAsBytesSync(),
            filename: file.path.split("/").last,
            contentType: MediaType("image", file.path.split(".").last),
          ));
        }
      }

      var response = await request.send().timeout(Duration(minutes: 1));
      final res = await http.Response.fromStream(response);
      return returnResponse(res);
    } catch (error) {
      catchMessage(error);
    }
    return returnError();
  }

  Future<ResponseModel> returnResponse(res) async {
    var resData = await serverResponse(res);
    if (resData != null) return ResponseModel.fromJson(resData);
    return null;
  }

  ResponseModel returnError() {
    return ResponseModel(message: "error", status: "error", result: null);
  }

  Map<String, String> getHeader() {
    Map<String, String> data = new Map<String, String>();
    // "Content-Type": "application/x-www-form-urlencoded"
    data['Content-Type'] = 'application/json';
    data['Accept'] = 'application/json';
    data['token'] = '$token';
    return data;
  }

  String getImgUrl() {
    var furl = '$url';
    print(furl);
    return furl;
  }

  // youtube() async {
  //   try {
  //     final res = await http.get(url, headers: getHeader());
  //     return res.body;
  //   } catch (error) {
  //     print(error);
  //   }
  //   return null;
  // }
  //
  catchMessage(message) async {
    return await errorMessageDialog(context, message: message.toString());
  }

  dynamic serverResponse(http.Response response) async {
    if (context == null) return;
    var responseJson;
    var hasMessage = false;
    try {
      responseJson = json.decode(response.body.toString());
      hasMessage = responseJson.containsKey("message");
    } catch (e) {
      responseJson = response.body.toString();
    }
    var message = hasMessage ? responseJson['message'] : responseJson;
    if (response.body.toString().contains("Invalid Token") ||
        response.body.toString().contains("E_INVALID_JWT_TOKEN")) {
      await errorMessageDialog(context, message: message);
      SharedPref().remove("token");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Wrapper(),
        ),
      );
    }
    // message = "$message $url";
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        await errorMessageDialog(context, message: message);
        print("BadRequestException " + response.body.toString());
        return null;
      case 401:
      case 403:
        await errorMessageDialog(context, message: message);
        print("UnauthorisedException " + response.body.toString());
        return null;
      case 500:
      default:
        await errorMessageDialog(context, message: message);
        print(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        return null;
    }
  }

  login(String jsonEncode) {}

  ///For updating firebase fcm token on remote server

  updateFirebaseToken() async {
    token = await SharedPref().getStringValue("token");
    if (obtainedFirebaseToken != null) {
      updateFCM();
    }
  }

  ///For verifing and creating account on remote server
  ///using firebase token
  ///
  updateFCM() async {
    var tokenJson = {'token': obtainedFirebaseToken};
    if (token != null) {
      if (token.length >= 10) {
        try {
          final response = await http.put(getUri(url),
              body: json.encode(tokenJson), headers: getHeader());
          print(response.body);
          print("################ FCM Token Updated #######################");
        } catch (error) {
          print(
            error,
          );
        }
      }
    }
  }
}
