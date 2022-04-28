import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_mate/models/user.dart';

/// Singleton class to hold the current user
class CurrentUser {
  static Users? user = Users(uid: ' ');

  static final CurrentUser _currentUser = CurrentUser._internal();

  factory CurrentUser() {
    return _currentUser;
  }

  CurrentUser._internal();

  static setUser(Users? curUser) {
    user = curUser;
  }
}
