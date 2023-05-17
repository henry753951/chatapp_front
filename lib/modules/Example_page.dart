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
          child: Row(
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
        ),
      ],
    ));
  }
}
