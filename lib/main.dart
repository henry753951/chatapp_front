import 'dart:io';

import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/pininput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'pages/main_page.dart';
import "package:hive_flutter/hive_flutter.dart";

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool logined = false;
  void checkLogin() async {
    var authBox = await Hive.openBox('auth');
    var token = authBox.get("token");
    if (token != null) {
      setState(() {
        logined = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
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
        home: logined ? MainPage() : const LoginScreen(),
      ),
    );
  }
}
