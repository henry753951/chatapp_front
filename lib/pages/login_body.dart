import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void signUserIn() async {}

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
                  width: MediaQuery.of(context).size.width,
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
                  height: 535,
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
                                controller: emailController,
                                hintText: "hello@gmail.com",
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
                                controller: passwordController,
                                hintText: "**************",
                                obscureText: true,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyButton(
                                onPressed: signUserIn,
                                buttonText: 'Submit',
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
