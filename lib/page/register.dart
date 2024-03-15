import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws54_flutter_speedrun2/page/details.dart';
import 'package:ws54_flutter_speedrun2/page/login.dart';
import 'package:ws54_flutter_speedrun2/service/auth.dart';
import 'package:ws54_flutter_speedrun2/service/sql_service.dart';

import '../constant/style_guide.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;
  bool doAuthWarning = false;

  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
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
                  "註冊介面",
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
                confirmTextForm(),
                const SizedBox(height: 20),
                registerButton(),
                const SizedBox(height: 20),
                registerToLoginText()
              ],
            )),
      ),
    );
  }

  Widget bigIcon() {
    return Image.asset("assets/icon.png", width: 150, height: 150);
  }

  Widget registerButton() {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: const Size(120, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: AppColor.black,
          alignment: Alignment.center),
      child: const Text(
        "註冊",
        style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Averta",
            fontSize: 25),
      ),
      onPressed: () async {
        if (isAccountValid && isPasswordValid && isConfirmValid) {
          String account = account_controller.text;
          String passowrd = password_controller.text;
          bool hasRegistered =
              await UserDAO.checkAccountHasBeenRegistered(account);
          if (hasRegistered) {
            if (mounted) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            }
          } else {
            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsPage(
                        account: account,
                        password: passowrd,
                      )));
            }
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
              isPasswordValid = false;
              return "";
            } else if (value == null || value.trim().isEmpty) {
              isPasswordValid = false;
              return "請輸入您的密碼";
            }
            isPasswordValid = true;
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

  bool obscure2 = true;
  Widget confirmTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
          obscureText: obscure2,
          controller: confirm_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              doAuthWarning = false;
            });
          },
          validator: (value) {
            if (doAuthWarning) {
              isConfirmValid = false;
              return "錯誤的密碼或帳號";
            } else if (value != password_controller.text) {
              isConfirmValid = false;
              return "請重新確認密碼";
            } else if (value == null || value.trim().isEmpty) {
              isConfirmValid = false;
              return "請輸入您的密碼";
            }
            isConfirmValid = true;
            return null;
          },
          decoration: InputDecoration(
              hintText: "Confirm Password",
              suffixIcon: IconButton(
                icon: obscure2
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

  Widget registerToLoginText() {
    return Column(
      children: [
        const Text(
          "已經擁有帳號?",
          style: TextStyle(color: AppColor.black, fontSize: 20),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage())),
          child: const Text("登入",
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
