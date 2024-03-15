import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun2/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun2/page/edit.dart';
import 'package:ws54_flutter_speedrun2/page/login.dart';
import 'package:ws54_flutter_speedrun2/page/user.dart';
import 'package:ws54_flutter_speedrun2/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun2/service/sql_service.dart';
import 'package:ws54_flutter_speedrun2/service/utilities.dart';

import '../service/data_ model.dart';
import 'add_password.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});

  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController passwordID_controller;
  List<PasswordData> passwordList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentUserAllPasswordList();
    });
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    passwordID_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    passwordID_controller.dispose();
    super.dispose();
  }

  void setCurrentUserAllPasswordList() async {
    Object result = await PasswordDAO.getAllPasswordDataByUserID(widget.userID);
    if (result != false) {
      setState(() {
        passwordList = result as List<PasswordData>;
        print("get password list!!!");
        print(passwordList.length);
      });
    } else {
      setState(() {
        passwordList = [];
        print("didnt get any passwords...");
      });
    }
  }

  void setPasswordDataByCondition() async {
    String tag = tag_controller.text;
    String url = url_controller.text;
    String login = login_controller.text;
    String password = password_controller.text;
    String passwordID = passwordID_controller.text;
    Object result = await PasswordDAO.getPasswordListByCondition(
        widget.userID, tag, url, login, password, passwordID, hasFav, isFav);
    if (result != false) {
      setState(() {
        passwordList = result as List<PasswordData>;
      });
    } else {
      setState(() {
        passwordList = [];
      });
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPasswordPage(userID: widget.userID)))),
      drawer: navDrawer(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: homeAppBar(),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        width: double.infinity,
        child: Column(children: [
          const SizedBox(
            height: 60,
          ),
          searchArea(),
          const SizedBox(
            height: 20,
          ),
          passwordMenuColumn()
        ]),
      )),
    );
  }

  Widget passwordMenuColumn() {
    return SizedBox(
        width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: passwordList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: buildPasswordDataContainer(context, passwordList[index]),
              );
            }));
  }

  bool hasFav = false;
  int isFav = 1;
  Widget searchArea() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: AppColor.black, width: 1.5)),
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text("搜尋設定"),
          TextFormField(
            controller: tag_controller,
            decoration: const InputDecoration(hintText: "tag"),
          ),
          TextFormField(
            controller: url_controller,
            decoration: const InputDecoration(hintText: "url"),
          ),
          TextFormField(
            controller: login_controller,
            decoration: const InputDecoration(hintText: "login"),
          ),
          TextFormField(
            controller: password_controller,
            decoration: const InputDecoration(hintText: "password"),
          ),
          TextFormField(
            controller: passwordID_controller,
            decoration: const InputDecoration(hintText: "password id"),
          ),
          Row(
            children: [
              Expanded(
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text("啟用我的最愛"),
                      value: (hasFav),
                      onChanged: (value) {
                        setState(() {
                          hasFav = !hasFav;
                        });
                      })),
              Expanded(
                  child: CheckboxListTile(
                      enabled: hasFav,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text("我的最愛"),
                      value: (isFav == 0 ? false : true),
                      onChanged: (value) {
                        setState(() {
                          isFav = isFav == 0 ? 1 : 0;
                        });
                      }))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.black, width: 2.0)),
                  onPressed: () async {
                    setPasswordDataByCondition();
                  }, //FIXME
                  child: const Text("搜尋")),
              TextButton(
                  style: TextButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.black, width: 2.0)),
                  onPressed: () async {
                    setState(() {
                      tag_controller.text = "";
                      url_controller.text = "";
                      login_controller.text = "";
                      password_controller.text = "";
                    });
                  },
                  child: const Text("還原設定")),
              TextButton(
                  style: TextButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.black, width: 2.0)),
                  onPressed: () async {
                    setCurrentUserAllPasswordList();
                  },
                  child: const Text("取消搜尋"))
            ],
          )
        ]),
      ),
    );
  }

  Widget buildPasswordDataContainer(BuildContext context, PasswordData data) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: AppColor.black, width: 1.5)),
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(data.tag),
        const Divider(
          thickness: 1.0,
        ),
        Row(
          children: [
            const SizedBox(
              width: 80,
              child: Text("網址"),
            ),
            SizedBox(
              child: Text(data.url),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 80,
              child: Text("登入帳號"),
            ),
            SizedBox(
              child: Text(data.login),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 80,
              child: Text("密碼"),
            ),
            SizedBox(
              child: Text(data.password),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 80,
              child: Text("ID"),
            ),
            SizedBox(
              child: Text(data.id),
            )
          ],
        ),
        Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(
                        side: BorderSide(color: AppColor.red, width: 1.5)),
                    backgroundColor:
                        data.isFav == 1 ? AppColor.red : AppColor.white),
                onPressed: () async {
                  setState(() {
                    data.isFav = data.isFav == 1 ? 0 : 1;
                  });
                  await PasswordDAO.updatePasswordData(data);
                  if (mounted) {
                    Utilities.showNormalSnackBar(context, "已變更", 1);
                  }
                },
                child: Icon(
                    data.isFav == 1
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: data.isFav == 1 ? AppColor.white : AppColor.red)),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: AppColor.green),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPage(data: data)));
                },
                child: const Icon(
                  Icons.edit,
                  color: AppColor.white,
                )),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(), backgroundColor: AppColor.red),
                onPressed: () async {
                  await PasswordDAO.deletePasswordDataByID(data.id);
                  setState(() {
                    setCurrentUserAllPasswordList();
                  });
                  if (mounted) {
                    Utilities.showNormalSnackBar(context, "已刪除", 1);
                  }
                },
                child: const Icon(
                  Icons.delete,
                  color: AppColor.white,
                )),
          ],
        )
      ]),
    );
  }

  Widget homeAppBar() {
    return AppBar(
      backgroundColor: AppColor.black,
      centerTitle: true,
      title: const Text("主畫面"),
    );
  }

  Widget navDrawer(BuildContext context) {
    return Drawer(
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                    icon: const Icon(Icons.close)),
                Image.asset(
                  "assets/icon.png",
                  fit: BoxFit.cover,
                  width: 23,
                  height: 23,
                )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("主畫面"),
              onTap: () => _scaffoldKey.currentState?.closeDrawer(),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("帳號設置"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPage(userID: widget.userID))),
            ),
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
}
