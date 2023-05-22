import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pinput/pinput.dart';

import 'modules/utils.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/pininput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/main_page.dart';
import "package:hive_flutter/hive_flutter.dart";

void main() async {
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool logined = false;
  bool active = false;
  void checkLogin() async {
    var authBox = await Hive.openBox('auth');
    var token = authBox.get("token");
    if (token != null) {
      var payload = parseJwt(token);
      active = payload["active"];
      var exp = payload["exp"];
      var now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (exp < now) {
        authBox.delete("token");
      } else {
        setState(() {
          logined = true;
          if (active) active = true;
        });
      }
    }
  }

  @override
  void initState() {
    print(dotenv.env.toString());
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //top status bar
        systemNavigationBarColor: Color.fromARGB(
            255, 255, 255, 255), // navigation bar color, the one Im looking for
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: logined
            ? (active ? MainPage() : const VerificationCodeScreen(resend: true))
            : const LoginScreen(),
      ),
    );
  }
}
