import 'package:chatapp/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'auth/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class User {
  String name = "";
  String username = "";
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User();
  void getUser() async {
    var authBox = await Hive.openBox('auth');
    try {
      user.name = authBox.get("user")["Name"];
      user.username = authBox.get("user")["username"];
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text("個人檔案",
                      style: TextStyle(
                        fontSize: 30,
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
              SizedBox(
                height: 25,
              ),
              Stack(children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Color.fromARGB(255, 226, 235, 113),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 67, 190, 72),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.0)),
                  ),
                )
              ]),
              const SizedBox(
                height: 10,
              ),
              Text(user.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 75, 75),
                  )),
              const SizedBox(
                height: 35,
              ),
              info(
                icon: Icon(CupertinoIcons.creditcard, color: Colors.orange),
                title: "學號",
                value: user.username,
              ),
              info(
                icon: Icon(Icons.cake_outlined, color: Colors.orange),
                title: "生日",
                value: "07/14",
              ),
              info(
                icon: Icon(CupertinoIcons.phone, color: Colors.orange),
                title: "手機號碼",
                value: "0965494854",
              ),
            ],
          ),
        ),
        const Spacer(),
        LogoutBtn(),
        const SizedBox(
          height: 35,
        ),
      ],
    ));
  }
}

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Center(
        child: TextButton(
          onPressed: () {
            Hive.box('auth').delete("token");
            Hive.box('auth').delete("user");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            "登出",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class info extends StatelessWidget {
  Icon icon;
  String title;
  String value;
  info({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1,
            ),
            Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: const Color.fromARGB(255, 215, 215, 215),
                  width: 1,
                ))),
                child: Row(children: [
                  Row(
                    children: [
                      icon,
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox(), flex: 1),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 16, height: 1.4, color: Colors.grey),
                      )),
                ]))
          ],
        ));
  }
}
