import 'package:chatapp/components/chat.dart';
import 'package:chatapp/models/chat_users.dart';
import 'package:chatapp/modules/dragbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:m_toast/m_toast.dart';
import 'package:intl/intl.dart';

import 'package:chatapp/models/InviteModal.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int InviteLength = 0;
  @override
  void initState() {
    super.initState();
    getInvite().then((value) {
      setState(() {
        InviteLength = value.length;
      });
    });
  }

  Future<List<invite>> getInvite() async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.get("${dotenv.get("baseUrl")}invite/invite");
    var data = response.data;
    List<invite> Invite = [
      for (var i in data["data"])
        invite(
            text: i["sender"]['user']["Name"], //?
            image: "https://i.imgur.com/3x5q2Yk.jpg",
            time: DateTime.fromMillisecondsSinceEpoch(i["time"]), //?
            id: i["sender"]["id"])
    ];
    return Invite;
  }

  Future<List<ChatUsers>> getRoom() async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.get("${dotenv.get("baseUrl")}room");
    var data = response.data;
    List<ChatUsers> Invite = [
      for (var i in data)
        ChatUsers(
            text: i["id"], //?
            secondaryText: "https://i.imgur.com/3x5q2Yk.jpg",
            image: "https://i.imgur.com/3x5q2Yk.jpg", //?
            time: "now")
    ];
    return Invite;
  }

  Future<void> showModal() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        builder: (context) {
          return InviteModal();
        }).then((value) => {
          // 當modal關閉後，重新取得邀請數量
          getInvite().then((value) {
            setState(() {
              InviteLength = value.length;
            });
          })
        });
  }

  List<ChatUsers> chatUsers = [
    ChatUsers(
        text: "Jsssussel",
        secondaryText: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        text: "duuuudl",
        secondaryText: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        text: "cccc",
        secondaryText: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Tinder",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 80.0, 70.0)),
                      )),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.orange[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.mail_outline_rounded,
                              color: Color.fromARGB(255, 255, 176, 57),
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showModal();
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  "好友邀請",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 224, 171, 91)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: InviteLength == 0 ? false : true,
                        child: Positioned(
                          left: -3,
                          top: -5,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25)),
                            child: Center(
                              child: Text(
                                InviteLength.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              child: CupertinoSearchTextField(
                  placeholder: "搜尋",
                  placeholderStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Brutal',
                  ),
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(50), right: Radius.circular(50)))),
          Expanded(
            child: ListView.builder(
              itemCount: chatUsers.length,
              padding: const EdgeInsets.only(top: 16),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUsersList(
                  text: chatUsers[index].text,
                  secondaryText: chatUsers[index].secondaryText,
                  image: chatUsers[index].image,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
