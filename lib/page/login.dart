import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun2/page/home.dart';
import 'package:ws54_flutter_speedrun2/page/register.dart';
import 'package:ws54_flutter_speedrun2/service/auth.dart';
import 'package:ws54_flutter_speedrun2/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/data_ model.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool doAuthWarning = false;

  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bigIcon(),
                const SizedBox(height: 20),
                const Text(
                  "登入介面",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Averta"),
                ),
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
                const Text("密碼",
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Averta")),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                loginButton(),
                const SizedBox(height: 20),
                loginToRegisterText()
              ],
            )),
      ),
    );
  }

  Widget bigIcon() {
    return Image.asset("assets/icon.png", width: 150, height: 150);
  }

  Widget loginButton() {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: Size(120, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: AppColor.black,
          alignment: Alignment.center),
      child: const Text(
        "登入",
        style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Averta",
            fontSize: 25),
      ),
      onPressed: () async {
        String account = account_controller.text;
        String password = password_controller.text;
        Object result = await Auth.logginAuth(account, password);
        if (result != false) {
          UserData userData =
              await UserDAO.getUserDataByAccountAndPassword(account, password);
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: userData.id)));
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
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
              doAuthWarning = false;
            });
          },
          validator: (value) {
            if (doAuthWarning) {
              isAccountValid = false;
              return "";
            } else if (value == null || value.trim().isEmpty) {
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
              doAuthWarning = false;
            });
          },
          validator: (value) {
            if (doAuthWarning) {
              isAccountValid = false;
              return "錯誤的密碼或帳號";
            } else if (value == null || value.trim().isEmpty) {
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

  Widget loginToRegisterText() {
    return Column(
      children: [
        const Text(
          "尚未擁有帳號?",
          style: TextStyle(color: AppColor.black, fontSize: 20),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
          child: const Text("註冊",
              style: TextStyle(
                  color: AppColor.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Averta",
                  fontSize: 30)),
        )
      ],
    );
  }
}
