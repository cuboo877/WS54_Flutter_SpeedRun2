import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun2/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun2/page/home.dart';
import 'package:ws54_flutter_speedrun2/service/auth.dart';
import 'package:ws54_flutter_speedrun2/service/utilities.dart';

import '../service/data_ model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController birthday_controller;
  late TextEditingController username_controller;
  bool isNameValid = false;
  bool isBirthdayValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: topbar(),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "註冊使用者資料",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Averta"),
                  ),
                  const SizedBox(height: 20),
                  const Text("使用者名稱",
                      style: TextStyle(
                          color: AppColor.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Averta")),
                  const SizedBox(height: 20),
                  userNameTextForm(),
                  const SizedBox(height: 20),
                  const Text("生日",
                      style: TextStyle(
                          color: AppColor.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Averta")),
                  const SizedBox(height: 20),
                  birthdayTextForm(),
                  const SizedBox(height: 20),
                  startButton()
                ],
              )),
        ));
  }

  Widget startButton() {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: const Size(150, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: AppColor.black,
          alignment: Alignment.center),
      child: const Text(
        "開始使用",
        style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Averta",
            fontSize: 25),
      ),
      onPressed: () async {
        if (isBirthdayValid && isNameValid) {
          String id = Utilities.randomID();
          String username = username_controller.text;
          String birthday = birthday_controller.text;
          UserData userData =
              UserData(id, username, widget.account, widget.password, birthday);
          bool result = await Auth.registerAuth(userData);
          if (result) {
            if (mounted) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(userID: id)));
              print("registered acccount success!!!");
              print(userData);
            }
          } else {
            print("something wrong with register user"); //通常不會怎樣吧
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
        }
      },
    );
  }

  Widget userNameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: username_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) => setState(() {
                doAuthWarning = false;
              }),
          validator: (value) {
            if (doAuthWarning) {
              isNameValid = false;
              return "請重新輸入";
            } else if (value == null || value.trim().isEmpty) {
              isNameValid = false;
              return "請輸入稱呼您的名稱";
            }
            isNameValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "User Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  Widget birthdayTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: birthday_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) => setState(() {
                doAuthWarning = false;
              }),
          onTap: () async {
            // ignore: no_leading_underscores_for_local_identifiers
            DateTime? _picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2026));
            setState(() {
              if (_picked != null) {
                birthday_controller.text = _picked.toString().split(" ")[0];
                isBirthdayValid = true;
              } else {
                isBirthdayValid = false;
              }
            });
          },
          validator: (value) {
            if (doAuthWarning) {
              isNameValid = false;
              return "請重新輸入";
            } else if (value == null || value.trim().isEmpty) {
              isBirthdayValid = false;
              return "請輸入稱呼您的生日";
            }
            isBirthdayValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "YYYY-MM-DD",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  Widget topbar() {
    return AppBar(
      backgroundColor: AppColor.black,
      title: const Text(
        "即將完成註冊",
        style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.white,
          )),
    );
  }
}
