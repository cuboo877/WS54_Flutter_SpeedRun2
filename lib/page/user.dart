import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun2/page/home.dart';
import 'package:ws54_flutter_speedrun2/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/data_ model.dart';
import '../service/sharedPref.dart';
import 'login.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;

  bool isEdited = false;

  late TextEditingController birthday_controller;
  late TextEditingController username_controller;
  bool isNameValid = false;
  bool isBirthdayValid = false;

  UserData userData = UserData("", "", "", "", "");
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCurrentUserData();
      print("post new user data");
    });
    super.initState();
    account_controller = TextEditingController(text: userData.account);
    password_controller = TextEditingController(text: userData.password);
    username_controller = TextEditingController(text: userData.username);
    birthday_controller = TextEditingController(text: userData.birthday);
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        username_controller.text,
        account_controller.text,
        password_controller.text,
        birthday_controller.text);
  }

  void getCurrentUserData() async {
    UserData _userData = await UserDAO.getUserDataByID(widget.userID);
    setState(() {
      account_controller.text = _userData.account;
      password_controller.text = _userData.password;
      username_controller.text = _userData.username;
      birthday_controller.text = _userData.birthday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: topbar(),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(children: [
            const SizedBox(height: 20),
            const Text("帳號",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averta")),
            const SizedBox(height: 20),
            accountTextForm(),
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
            const Text("密碼",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averta")),
            const SizedBox(height: 20),
            passwordTextForm(),
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
            finishEditingButton(),
            const SizedBox(height: 20),
            logoutButton(context)
          ]),
        ));
  }

  Widget logoutButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: AppColor.white,
          side: const BorderSide(color: AppColor.red, width: 1.5)),
      onPressed: () async {
        await SharedPref.removeLoggedUserID();
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
      child: const Text(
        "登出",
        style: TextStyle(color: AppColor.red, fontSize: 23),
      ),
    );
  }

  Widget finishEditingButton() {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: const Size(160, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: AppColor.black,
          alignment: Alignment.center),
      child: const Text(
        "完成編輯",
        style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Averta",
            fontSize: 25),
      ),
      onPressed: () async {
        UserData _userData = packUserData();
        await UserDAO.updateUserData(_userData);
        print("updated userdata");
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      },
    );
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: account_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              isEdited = true;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isAccountValid = false;
              return "請輸入您的信箱";
            } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                .hasMatch(value)) {
              isAccountValid = false;
              return "輸入正確的信箱格式";
            }
            isAccountValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  bool obscure = true;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          obscureText: obscure,
          controller: password_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              isEdited = true;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isAccountValid = false;
              return "請輸入您的密碼";
            }
            isAccountValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                icon: obscure
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  Widget userNameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: username_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) => setState(() {
                isEdited = true;
              }),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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
                isEdited = true;
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
            if (value == null || value.trim().isEmpty) {
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
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColor.white,
      title: const Text(
        "編輯個人帳號資料",
        style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
          onPressed: () {
            if (isEdited) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("確認編輯嗎"),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              backgroundColor: AppColor.green,
                              alignment: Alignment.center),
                          child: const Text(
                            "確認編輯",
                            style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averta",
                                fontSize: 19),
                          ),
                          onPressed: () async {
                            await UserDAO.updateUserData(packUserData());
                            if (mounted) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(userID: widget.userID)));
                            }
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              backgroundColor: AppColor.darkBlue,
                              alignment: Alignment.center),
                          child: const Text(
                            "繼續編輯",
                            style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averta",
                                fontSize: 19),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              backgroundColor: AppColor.red,
                              alignment: Alignment.center),
                          child: const Text(
                            "放棄",
                            style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averta",
                                fontSize: 19),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(userID: widget.userID)));
                          },
                        )
                      ],
                    );
                  });
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.black,
          )),
    );
  }
}
