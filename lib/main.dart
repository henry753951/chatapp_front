import 'dart:io';
import 'package:chatapp/services/socket.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';
import 'dart:convert';
import 'components/GradientText.dart';
import 'components/data.dart';
import 'modules/utils.dart';
import 'package:chatapp/pages/auth/login.dart';
import 'package:chatapp/pages/auth/pininput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/main_page.dart';
import "package:hive_flutter/hive_flutter.dart";

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

void main() async {
  SocketService.init();
  await Hive.initFlutter();
  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.production");
  } else {
    await dotenv.load(fileName: ".env");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  bool logined = false;
  bool active = false;
  String email = "";
  void checkLogin() async {
    var authBox = await Hive.openBox('auth');
    var token = authBox.get("token");
    if (token != null) {
      var payload = parseJwt(token);
      active = payload["active"];
      Data.currentUser['id'] = payload["id"];
      var exp = payload["exp"];
      var now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (exp < now) {
        authBox.delete("token");
      } else {
        setState(() {
          logined = true;
          email = authBox.get("user")['email'];
          if (active) active = true;
        });
      }
    }
    setState(() {
      loading = false;
    });
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
        statusBarColor: Color.fromARGB(40, 0, 0, 0), //top status bar
        systemNavigationBarColor: Color.fromARGB(
            255, 255, 255, 255), // navigation bar color, the one Im looking for
        statusBarIconBrightness: Brightness.light, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
      child: MaterialApp(
        title: 'MDFKU',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch(
                backgroundColor: Colors.white, primarySwatch: Colors.orange),
            dialogBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: loading
            ? Scaffold(
                body: Center(
                  child: GradientText(
                    'ININDER',
                    style: const TextStyle(fontSize: 40),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(226, 252, 78, 72),
                      Color.fromARGB(255, 221, 164, 42),
                    ]),
                  ),
                ),
              )
            : (logined
                ? (active
                    ? MainPage()
                    : VerificationCodeScreen(resend: true, email: email))
                : const LoginScreen()),
      ),
    );
  }
}
