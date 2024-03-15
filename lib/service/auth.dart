import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun2/page/details.dart';
import 'package:ws54_flutter_speedrun2/page/login.dart';
import 'package:ws54_flutter_speedrun2/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun2/service/sql_service.dart';

import 'data_ model.dart';

class Auth {
  static Future<bool> isLogged() async {
    String loggedUserID = await SharedPref.getLoggedUserID();
    return loggedUserID.isNotEmpty;
  }

  static Future<Object> logginAuth(String account, String password) async {
    try {
      UserData userData =
          await UserDAO.getUserDataByAccountAndPassword(account, password);
      await SharedPref.setLoggedUserID(userData.id);
      return userData;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> registerAuth(UserData userData) async {
    try {
      await UserDAO.addUserData(userData);
      await SharedPref.setLoggedUserID(userData.id);
      print("add new user.");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
