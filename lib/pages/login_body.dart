import 'package:chatapp/modules/utils.dart';
import 'package:chatapp/pages/pininput.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:m_toast/m_toast.dart';

import 'main_page.dart';

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final UserNameController = TextEditingController();
  final passwordController = TextEditingController();
  final ShowMToast toast = ShowMToast();
  bool loading = false;
  String username = "";
  String password = "";

  BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 10), // 60 seconds
      receiveTimeout: Duration(seconds: 60) // 60 seconds
      );
  void signUserIn() async {
    try {
      var authBox = await Hive.openBox('auth');

      Dio dio = new Dio(options);
      setState(() {
        loading = true;
      });
      Response response = await dio.post("${dotenv.get("baseUrl")}auth/login",
          data: {"username": username, "password": password});
      var data = response.data;
      if (data["msg"] == "成功登入") {
        authBox.put("token", data["data"]["token"]);
        authBox.put("user", data["data"]["user"]);
        if (parseJwt(data["data"]["token"])["active"]) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
            (Route<dynamic> route) => false,
          );
          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(resend: false),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          loading = false;
        });
        toast.errorToast(context,
            alignment: Alignment.topLeft, message: "帳號或密碼錯誤");
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      toast.errorToast(context,
          alignment: Alignment.topLeft, message: e.toString());
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor("#fed8c3"),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("ININDER",
                          style: TextStyle(
                            fontSize: 66,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Colors.red, Colors.orange],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(Rect.fromLTWH(0, 0, 80, 70)),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor("#ffffff"),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "登入",
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#4f4f4f"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "學號",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: HexColor("#8d8d8d"),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                onchanged: (text) => {username = text},
                                controller: UserNameController,
                                hintText: "ex : a1105506",
                                obscureText: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(
                                  _errorMessage,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "密碼",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: HexColor("#8d8d8d"),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                onchanged: (text) => {password = text},
                                controller: passwordController,
                                hintText: "**************",
                                obscureText: true,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyButton(
                                enabled: !loading,
                                onPressed: signUserIn,
                                buttonText: '登入  /  註冊',
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
