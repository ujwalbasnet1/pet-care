import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pets/service/network.dart';
import 'package:pets/service/userid_store.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/screens/five-steps/about_pet.dart';

class UserProvider extends ChangeNotifier {
  var _userData;
  var _userInfo = UserInfo();
  var _totalPoints;
  var _petList = [];
  var _groupData;
  var _taskList;
  var _allPetTasks;
  var _storedUserInfo;
  var _currentGenericTab;
  var _petsListData;
  bool _isFromAddPets = false;
  var _recentlyAddedPet;

  set isFromAddPets(bool isFromAddPets) {
    _isFromAddPets = isFromAddPets;
    notifyListeners();
  }

  setUserDataNull() {
    Future.delayed(Duration.zero, () async {
      _userData = null;
      notifyListeners();
    });
  }

  Future<void> fetchUserInfo(context, {force: false}) async {
    if (_userData != null && !force) {
      return;
    }

    var data = await RestRouteApi(context, ApiPaths.getUserInfo).get();

    if (data != null) {
      if (data != null) {
        var d = data['data'];
        _totalPoints = data['data']['totalpoints'] ?? 0;
        _petList = data['data']['pet'] + data['data']['caretaker'];
        _userData = data;

        _userInfo.isMinor = d['isMinor'];
        _userInfo.role = d['role'];
        _userInfo.userId = d['_id'];
        _userInfo.showCareTaker = d['isMinor'];
      }
    } else {
      _userData = false;
    }
    notifyListeners();
    return;
  }

  setTaskDataNull() {
    Future.delayed(Duration.zero, () async {
      _taskList = null;
      notifyListeners();
    });
  }

  Future<void> fetchTask(context, id, {force: false}) async {
    if (_taskList != null && !force) {
      return;
    }
    String path = id == "all" ? ApiPaths.getTask : ApiPaths.getTaskByPetId + id;
    var data = await RestRouteApi(context, path).get();
    if (data != null) {
      _taskList = data['data'];
      fetchUserInfo(context, force: force);
    } else {
      _taskList = false;
    }
    notifyListeners();
    return true;
  }

  Future<void> fetchAllPetTasks(context, {force: false}) async {
    if (_allPetTasks != null && !force) {
      return;
    }
    String path = ApiPaths.getAllPetTasks;
    var data = await RestRouteApi(context, path).get();
    if (data != null) {
      _allPetTasks = data['data'];
      fetchUserInfo(context, force: force);
    } else {
      _allPetTasks = false;
    }
    notifyListeners();
    return true;
  }

  setCareTakeGroup() {
    Future.delayed(Duration.zero, () async {
      _taskList = null;
      notifyListeners();
    });
  }

  Future<void> fetchListData(BuildContext context, {force: false}) async {
    if (_petsListData != null && !force) {
      return;
    }
    var data = await RestRouteApi(context, ApiPaths.getPets).get();
    if (data != null) {
      _petsListData = data['data'];
    } else {
      _petsListData = false;
    }
    notifyListeners();
    return true;
  }

  Future<void> getCareTakeGroup(context, {force: false}) async {
    if (_groupData != null && !force) {
      return;
    }
    fetchAllPetTasks(context, force: force);
    var data = await RestRouteApi(context, ApiPaths.getPetGroup).get();
    if (data != null) {
      _groupData = data['data'];
    } else {
      _groupData = false;
    }
    notifyListeners();
    return true;
  }

  fetchStoredData() async {
    _storedUserInfo = await SharedPref().read("userData");
    notifyListeners();
  }

  currentSelectedTab(TabController tabController) {
    _currentGenericTab = tabController;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  void recentlyAddedPet(data) {
    _recentlyAddedPet = data;
    notifyListeners();
  }

  TabController get getCurrentGenericTab => _currentGenericTab;
  get getStoredUserInfo => _storedUserInfo;
  get getUserData => _userData;
  get getTotalPoints => _totalPoints;
  List get getPetList => _petList ?? [];
  get getTaskList => _taskList;
  get getGroupData => _groupData;
  get getPetListData => _petsListData;
  get isFromAddPets => _isFromAddPets;
  get getRecentlyAddedPet => _recentlyAddedPet;
  UserInfo get getUserInfo => _userInfo;
  get getAllPetTasks => _allPetTasks;

  //Create Task User
  List _membersListByPet;
  void selectedPet(int pos) {
    if (pos != 0) {
      _membersListByPet = (getPetList[pos - 1]['group']['members'] as List)
          .map((e) => {
                "id": e['person']['_id'],
                "name": e['person']['userInfo']['fname'],
                "image": e['person']['userInfo']['avatar']
              })
          .toList();
    } else {
      _membersListByPet = [];
      for (var item in getPetList) {
        List uList = [];
        for (var e in item['group']['members']) {
          var d = jsonEncode({
            "id": e['person']['_id'],
            "name": e['person']['userInfo']['fname'],
            "image": e['person']['userInfo']['avatar']
          });
          uList.add(d);
        }
        _membersListByPet.addAll(uList);
      }
      _membersListByPet =
          _membersListByPet.toSet().toList().map((e) => jsonDecode(e)).toList();
    }
    notifyListeners();
  }

  get getMembersListByPet => _membersListByPet;

  Future<void> onPetChange(context) async {
    await Future.wait([
      fetchUserInfo(context, force: true),
      fetchListData(context, force: true), //get pet List
      getCareTakeGroup(context, force: true),
    ]);
  }

  Future<void> onScheduleChange(context) async {
    await Future.wait([
      fetchUserInfo(context, force: true),
      fetchListData(context, force: true), //get pet List
      getCareTakeGroup(context, force: true),
    ]);
  }

  Future<void> onCaretakerChange(context) async {
    await Future.wait([
      fetchUserInfo(context, force: true),
      fetchListData(context, force: true), //get pet List
      getCareTakeGroup(context, force: true),
    ]);
  }

  Future<void> onHomeRefresh(context) async {
    await Future.wait([
      fetchUserInfo(context, force: true),
      fetchListData(context, force: true), //get pet List
      getCareTakeGroup(context, force: true),
    ]);
    return true;
  }

  logout() async {
    _userData = null;
    _userInfo = null;
    _totalPoints = null;
    _petList = null;
    _groupData = null;
    _taskList = null;
    _allPetTasks = null;
    _storedUserInfo = null;
    _currentGenericTab = null;
    _petsListData = null;
    _isFromAddPets = false;
    _recentlyAddedPet = null;
    return true;
  }
}

class UserInfo {
  String role = "";
  bool isMinor = false;
  bool showCareTaker = true;
  String userId = "";
  UserInfo({this.role, this.isMinor, this.userId});
}
