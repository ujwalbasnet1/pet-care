import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  bool _isFollowing;

  set isFollowing(bool bool) {
    _isFollowing = bool;
    notifyListeners();
  }

  bool get isFollowing => _isFollowing;
}
