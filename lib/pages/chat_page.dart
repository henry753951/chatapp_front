import 'dart:io';

import 'package:chatapp/components/chat.dart';
import 'package:chatapp/components/data.dart';
import 'package:chatapp/models/chat_users.dart';
import 'package:chatapp/modules/dragbar.dart';
import 'package:chatapp/services/socket.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:m_toast/m_toast.dart';
import 'package:intl/intl.dart';

import 'package:chatapp/models/InviteModal.dart';

import '../components/GradientText.dart';

String getTimeStamp(DateTime time) {
  var now = DateTime.now();
  var diff = now.difference(time);
  if (diff.inSeconds < 60) {
    return "現在";
  } else if (diff.inMinutes < 60) {
    return "${diff.inMinutes}分鐘前";
  } else if (diff.inHours < 24) {
    return "${diff.inHours}小時前";
  } else if (diff.inDays < 7) {
    return "${diff.inDays}天前";
  } else {
    return DateFormat("yyyy-MM-dd").format(time);
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int InviteLength = 0;
  String searchText = "";
  List<ChatUsers> chatUsers = [];
  List<ChatUsers> chatUsers_clone = [];
  @override
  void initState() {
    super.initState();
    SocketService.addListener(onMessage);
    getInvite().then((value) {
      setState(() {
        InviteLength = value.length;
      });
      getChatUsers().then((value) {
        setState(() {
          Data.chatUsers = value;
          for (ChatUsers c in chatUsers) {
            chatUsers_clone.add(c);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    SocketService.removeListener(onMessage);
  }

  void onMessage(value) {
    getChatUsers().then((value) {
      setState(() {
        Data.chatUsers = value;
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
          getChatUsers().then((value) {
            setState(() {
              Data.chatUsers = value;
            });
          }),
          getInvite().then((value) {
            setState(() {
              InviteLength = value.length;
            });
          })
        });
  }

  Future<List<ChatUsers>> getChatUsers() async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.get("${dotenv.get("baseUrl")}room");
    var data = response.data;
    chatUsers = [];
    for (var i in data["data"]) {
      if (i["members"].length == 2) {
        if (i["members"][0]["user"]["Name"] == auth_box.get("user")["Name"]) {
          i["roomname"] = i["members"][1]["user"]["Name"];
        } else {
          i["roomname"] = i["members"][0]["user"]["Name"];
        }
      }
      List<dynamic> messages = i["messages"];
      chatUsers.add(ChatUsers(
          room_members: i["members"],
          roomid: i["id"],
          text: i["roomname"],
          secondaryText:
              messages.isEmpty ? '跟新朋友打聲招呼吧!' : messages.last["message"],
          image: "images/userImage1.jpeg",
          time: messages.isEmpty
              ? DateTime.now()
              : DateTime.fromMillisecondsSinceEpoch(
                  (messages.last["createdAt"] as double).toInt())));
    }
    chatUsers.sort((a, b) => b.time.compareTo(a.time));
    return chatUsers;
  }

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
                  GradientText(
                    'MDFKU', // MY DEAR FRIEND in Kushong University
                    style: const TextStyle(fontSize: 35,fontWeight: FontWeight.bold),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(226, 252, 78, 72),
                      Color.fromARGB(255, 221, 164, 42),
                    ]),
                  ),
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
          Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              child: CupertinoSearchTextField(
                  onChanged: (value) {
                    searchText = value;
                    chatUsers_clone.clear();
                    if (searchText.length == 0) {
                      for (ChatUsers c in chatUsers) {
                        chatUsers_clone.add(c);
                      }
                    } else {
                      for (ChatUsers c in chatUsers) {
                        if (c.text.contains(searchText)) {
                          chatUsers_clone.add(c);
                        }
                      }
                    }
                  },
                  placeholder: "搜尋",
                  placeholderStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Brutal',
                  ),
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(50), right: Radius.circular(50)))),
          Expanded(
            child: ListView.builder(
              itemCount: chatUsers_clone.length,
              padding: const EdgeInsets.only(top: 16),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUsersList(
                  roomid: Data.chatUsers[index].roomid,
                  room_members: Data.chatUsers[index].room_members,
                  text: Data.chatUsers[index].text,
                  secondaryText: Data.chatUsers[index].secondaryText,
                  image: Data.chatUsers[index].image,
                  time: getTimeStamp(Data.chatUsers[index].time),
                  isMessageRead: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
