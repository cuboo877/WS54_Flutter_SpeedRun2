import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun2/service/data_%20model.dart';
import 'package:ws54_flutter_speedrun2/service/utilities.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/sql_service.dart';
import 'home.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key, required this.userID});

  final String userID;
  @override
  State<StatefulWidget> createState() => _AddPasswordPage();
}

class _AddPasswordPage extends State<AddPasswordPage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  int isFav = 0;

  bool isEdited = false;
  bool istagValid = false;
  bool istUrlValid = false;
  bool isLoginValid = false;
  bool isPasswordValid = false;
  late TextEditingController customChars_controller;

  bool hasLowerCase = true;
  bool hasUpperCase = true;
  bool hasNumber = true;
  bool hasSymbol = true;
  int length = 16;

  PasswordData packPasswordData() {
    return PasswordData(
        Utilities.randomID(),
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        isFav);
  }

  @override
  void initState() {
    super.initState();
    customChars_controller = TextEditingController();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    customChars_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topbar(context),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            const Text("標籤",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averta")),
            const SizedBox(height: 20),
            tagTextForm(),
            const SizedBox(height: 20),
            const Text("網址",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averta")),
            const SizedBox(height: 20),
            urlTextForm(),
            const SizedBox(height: 20),
            const Text("登入帳號",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averta")),
            const SizedBox(height: 20),
            loginTextForm(),
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
            favButton(context),
            const SizedBox(height: 20),
            randomPasswordSettingButton(context),
            const SizedBox(height: 20),
            addPasswordButton(context),
          ]),
        ),
      ),
    );
  }

  Widget randomPasswordSettingButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: ((context, setState) {
                return AlertDialog(
                  title: const Text("隨機密碼設定"),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text("指定字元"),
                    TextFormField(
                      controller: customChars_controller,
                      decoration: const InputDecoration(hintText: "ex: cuboo"),
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                        title: const Text("包含小寫字母"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: (hasLowerCase),
                        onChanged: (value) {
                          setState(() => hasLowerCase = !hasLowerCase);
                        }),
                    CheckboxListTile(
                        title: const Text("包含大寫字母"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: (hasUpperCase),
                        onChanged: (value) {
                          setState(() => hasUpperCase = !hasUpperCase);
                        }),
                    CheckboxListTile(
                        title: const Text("包含數字"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: (hasNumber),
                        onChanged: (value) {
                          setState(() => hasNumber = !hasNumber);
                        }),
                    CheckboxListTile(
                        title: const Text("包含符號"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: (hasSymbol),
                        onChanged: (value) {
                          setState(() => hasSymbol = !hasSymbol);
                        }),
                    Row(
                      children: [
                        Slider(
                            min: 1,
                            max: 20,
                            divisions: 19,
                            value: (length.toDouble()),
                            onChanged: (value) {
                              setState(
                                () {
                                  length = value.toInt();
                                },
                              );
                            }),
                        Text(length.toString())
                      ],
                    )
                  ]),
                );
              }));
            });
      },
      style: TextButton.styleFrom(backgroundColor: AppColor.black),
      child: const Text("隨機密碼設定",
          style: TextStyle(color: AppColor.white, fontSize: 20)),
    );
  }

  Widget favButton(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            shape: const CircleBorder(
                side: BorderSide(color: AppColor.red, width: 1.5)),
            backgroundColor: isFav == 1 ? AppColor.red : AppColor.white),
        onPressed: () async {
          setState(() {
            isEdited = true;
            isFav = isFav == 1 ? 0 : 1;
            print(isFav);
          });
        },
        child: Icon(
            isFav == 1 ? Icons.favorite : Icons.favorite_outline_outlined,
            color: isFav == 1 ? AppColor.white : AppColor.red));
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: tag_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              isEdited = true;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              istagValid = false;
              return "請輸入密碼的標籤";
            }
            istagValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "ex: google account",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: url_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              isEdited = true;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              istUrlValid = false;
              return "請輸入密碼的網址";
            }
            istUrlValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "ex: https://google.com",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          controller: login_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              isEdited = true;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isLoginValid = false;
              return "請輸入使用此密碼的帳號";
            }
            isLoginValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "ex: cuboo@gmail.com",
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
              isPasswordValid = false;
              return "請輸入您的密碼";
            }
            isPasswordValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: const Icon(Icons.casino),
                  onPressed: () {
                    setState(() {
                      isEdited = true;
                      password_controller.text =
                          Utilities.randomPasswordCondition(
                              widget.userID,
                              hasLowerCase,
                              hasUpperCase,
                              hasNumber,
                              hasSymbol,
                              customChars_controller.text,
                              length);
                    });
                  },
                ),
                IconButton(
                  icon: obscure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                )
              ]),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(
                      color: AppColor.lightgrey, width: 1.5)))),
    );
  }

  Widget addPasswordButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: const Size(120, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: AppColor.black,
          alignment: Alignment.center),
      child: const Text(
        "新增",
        style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Averta",
            fontSize: 25),
      ),
      onPressed: () async {
        if (isEdited) {
          if (isLoginValid && isPasswordValid && istUrlValid && istagValid) {
            await PasswordDAO.addPasswordData(packPasswordData());
            if (mounted) {
              print("update new password data.");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(userID: widget.userID)));
              Utilities.showNormalSnackBar(context, "已新增密碼", 2);
            }
          } else {
            Utilities.showNormalSnackBar(context, "請確認輸入資料是否正確", 2);
          }
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
          Utilities.showNormalSnackBar(context, "未新增密碼", 2);
        }
      },
    );
  }

  Widget topbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColor.white,
      title: const Text(
        "新增您的密碼",
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
                            await PasswordDAO.updatePasswordData(
                                packPasswordData());
                            print("update new password data.");
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
