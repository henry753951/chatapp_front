import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/chat_detail_page_appbar.dart';
import 'package:chatapp/models/chat_message.dart';
import 'package:chatapp/models/send_menu_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Expanded(
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
                info(
                  icon: Icon(CupertinoIcons.brightness, color: Colors.orange),
                  title: "性命",
                  value: "姓名",
                ),
                info(
                  icon: Icon(Icons.check_circle),
                  title: "沒有",
                  value: "mail",
                ),
                info(
                  icon: Icon(Icons.check_circle),
                  title: "birthday",
                  value: "birthday",
                ),
                info(
                  icon: Icon(Icons.check_circle),
                  title: "phone",
                  value: "phone",
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        LogoutBtn(),
        SizedBox(
          height: 10,
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
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(
            "登出",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
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
