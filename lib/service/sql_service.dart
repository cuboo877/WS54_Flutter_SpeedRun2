import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data_ model.dart';

class UserDAO {
  static Database? database;
  static Future<Database> _initDataBase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws2.db"),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE users (id TEXT PRIMARY KEY, username TEXT, account TEXT, password TEXT, birthday TEXT)");
      await db.execute(
          "CREATE TABLE passwords (id TEXT PRIMARY KEY, userID TEXT, tag TEXT, url TEXT, login TEXT, password TEXT, isFav INTEGER, FOREIGN KEY (userID) REFERENCES users (id))");
    }, version: 1);
    return database!;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDataBase();
    }
  }

  static Future<UserData> getUserDataByID(String id) async {
    final Database database = await getDBConnect();
    final List<Map<String, dynamic>> result =
        await database.query("users", where: "id = ?", whereArgs: [id]);
    Map<String, dynamic> userData = result.first;
    return UserData(userData["id"], userData["username"], userData["account"],
        userData["password"], userData["birthday"]);
  }

  static Future<UserData> getUserDataByAccountAndPassword(
      String account, String password) async {
    final Database database = await getDBConnect();
    final List<Map<String, dynamic>> result = await database.query("users",
        where: "account = ? AND password = ?", whereArgs: [account, password]);
    Map<String, dynamic> userData = result.first;
    return UserData(userData["id"], userData["username"], userData["account"],
        userData["password"], userData["birthday"]);
  }

  static Future<bool> checkAccountHasBeenRegistered(String account) async {
    try {
      final Database database = await getDBConnect();
      final List<Map<String, dynamic>> result = await database
          .query("users", where: "account = ?", whereArgs: [account]);
      Map<String, dynamic> userData = result.first;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> updateUserData(UserData userData) async {
    final Database database = await getDBConnect();
    await database.update("users", userData.toJson(),
        where: "id = ?",
        whereArgs: [userData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteUserDataByID(String userID) async {
    final Database database = await getDBConnect();
    await database.delete("users", where: "id = ?", whereArgs: [userID]);
  }

  static Future<void> addUserData(UserData userData) async {
    final Database database = await getDBConnect();
    await database.insert("users", userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class PasswordDAO {
  static Future<Object> getPasswordListByCondition(
      String userID,
      String? tag,
      String? url,
      String? login,
      String? password,
      String? passwordID,
      bool hasFav,
      int? isFav) async {
    String whereCondition = "userID = ?";
    List<dynamic> whereArgs = [userID];
    print("$userID, $tag, $url, $login, $password, $passwordID, $isFav");
    if (tag != null && tag.trim().isNotEmpty) {
      print("add tag");
      whereCondition +=
          "AND tag LIKE ?"; // (X) : "AND tag LIKE = ?" // (v) : "AND tag LIKE ?"
      whereArgs.add("%$tag%");
    }
    if (url != null && url.trim().isNotEmpty) {
      print("add url");
      whereCondition += "AND url LIKE ?";
      whereArgs.add("%$url%");
    }
    if (login != null && login.trim().isNotEmpty) {
      print("add login");
      whereCondition += "AND login LIKE ?";
      whereArgs.add("%$login%");
    }
    if (password != null && password.trim().isNotEmpty) {
      print("add password");
      whereCondition += "AND password LIKE ?";
      whereArgs.add("%$password%");
    }
    if (passwordID != null && passwordID.trim().isNotEmpty) {
      print("add passwordID");
      whereCondition += "AND id LIKE ?";
      whereArgs.add("%$passwordID%");
    }
    if (hasFav == true) {
      print("add isFav");
      whereCondition += "AND isFav = ?";
      whereArgs.add(isFav);
    }
    try {
      final database = await UserDAO.getDBConnect();
      List<Map<String, dynamic>> result = await database.query("passwords",
          where: whereCondition, whereArgs: whereArgs);
      if (result.isNotEmpty) {
        print("search result: got something");
        return List.generate(result.length, (index) {
          return PasswordData(
              result[index]["id"],
              result[index]["userID"],
              result[index]["tag"],
              result[index]["url"],
              result[index]["login"],
              result[index]["password"],
              result[index]["isFav"]);
        });
      } else {
        print("search result: nothing");
        return false;
      }
    } catch (e) {
      print("maybe cant find. so return false");
      return false;
    }
  }

  static Future<Object> getAllPasswordDataByUserID(String userID) async {
    try {
      final Database database = await UserDAO.getDBConnect();
      final List<Map<String, dynamic>> result = await database
          .query("passwords", where: "userId = ?", whereArgs: [userID]);
      if (result.isEmpty) {
        return false;
      }
      return List.generate(result.length, (index) {
        return PasswordData(
            result[index]["id"],
            result[index]["userID"],
            result[index]["tag"],
            result[index]["url"],
            result[index]["login"],
            result[index]["password"],
            result[index]["isFav"]);
      });
    } catch (e) {
      return false;
    }
  }

  static Future<PasswordData> getPasswordDataByPasswordID(String id) async {
    final Database database = await UserDAO.getDBConnect();
    final List<Map<String, dynamic>> result =
        await database.query("passwords", where: "id = ?", whereArgs: [id]);
    Map<String, dynamic> passwordData = result.first;
    return PasswordData(
        passwordData["id"],
        passwordData["userID"],
        passwordData["tag"],
        passwordData["url"],
        passwordData["login"],
        passwordData["password"],
        passwordData["isFav"]);
  }

  static Future<void> updatePasswordData(PasswordData passwordData) async {
    final Database database = await UserDAO.getDBConnect();
    await database.update("passwords", passwordData.toJson(),
        where: "id = ?",
        whereArgs: [passwordData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deletePasswordDataByID(String passwordID) async {
    final Database database = await UserDAO.getDBConnect();
    await database
        .delete("passwords", where: "id = ?", whereArgs: [passwordID]);
  }

  static Future<void> addPasswordData(PasswordData passwordData) async {
    final Database database = await UserDAO.getDBConnect();
    await database.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
