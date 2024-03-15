import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun2/page/home.dart';
import 'package:ws54_flutter_speedrun2/service/auth.dart';
import 'package:ws54_flutter_speedrun2/service/sharedPref.dart';

import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void delayNav() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (await Auth.isLogged()) {
      String loggedUserID = await SharedPref.getLoggedUserID();
      print("logged userID : ${loggedUserID}");
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(userID: loggedUserID)));
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    delayNav();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/icon.png", width: 200, height: 200),
    );
  }
}
