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
import 'package:intl/intl.dart'; // for date format

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<void> accept(String sender_id) async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.post("${dotenv.get("baseUrl")}invite/invite",
        data: sender_id);
  }

  Future<void> delete(String sender_id) async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio
        .delete("${dotenv.get("baseUrl")}invite/invite", data: sender_id);
  }

  Future<void> showModal() async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.get("${dotenv.get("baseUrl")}invite/invite");
    var data = response.data;
    print(data);
    List<invite> Invite = [
      for (var i in data["data"])
        invite(
            text: i["sender"]["username"], //?
            image: "https://i.imgur.com/3x5q2Yk.jpg",
            time: DateTime.fromMillisecondsSinceEpoch(i["time"]), //?
            id: i["sender"]["id"])
    ];
    ShowMToast toast = ShowMToast();
    DismissDirection _dismissDirection = DismissDirection.horizontal;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: <Widget>[
                    DragBar(),
                    Text(
                      "好友邀請",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: Invite.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Dismissible(
                              direction: _dismissDirection,
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  delete(Invite[index].id);
                                  Invite.removeAt(index);
                                  setState(() {});
                                  toast.successToast(context,
                                      alignment: Alignment.topCenter,
                                      message: "已刪除好友邀請");
                                } else {
                                  accept(Invite[index].id);
                                  Invite.removeAt(index);
                                  setState(() {});
                                  toast.successToast(context,
                                      alignment: Alignment.topCenter,
                                      message: "已接受好友邀請");
                                }
                              },
                              dragStartBehavior: DragStartBehavior.down,
                              background: const ColoredBox(
                                color: Color.fromARGB(255, 93, 196, 136),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child:
                                        Icon(Icons.check, color: Colors.white),
                                  ),
                                ),
                              ),
                              secondaryBackground: const ColoredBox(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                              ),
                              key: UniqueKey(),
                              child: ListTile(
                                  leading: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            AssetImage(Invite[index].image),
                                      )),
                                  title: Text(Invite[index].text),
                                  subtitle: Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text('-傳送時間:'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(DateFormat('yyyy-MM-dd hh:mm:ss')
                                          .format(
                                              Invite[index].time.toLocal())),
                                    ],
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: GestureDetector(
                                        onTap: () {
                                          accept(Invite[index].id);
                                          toast.successToast(context,
                                              alignment: Alignment.topCenter,
                                              message: "已接受好友邀請");
                                          setState(() {
                                            Invite.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.check)),
                                  )),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  List<ChatUsers> chatUsers = [
    ChatUsers(
        text: "Jane Russel",
        secondaryText: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        text: "Jane Russel",
        secondaryText: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        text: "Jane Russel",
        secondaryText: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        text: "Glady's Murphy",
        secondaryText: "That's Great",
        image: "images/userImage2.jpeg",
        time: "Yesterday"),
    ChatUsers(
        text: "Jorge Henry",
        secondaryText: "Hey where are you?",
        image: "images/userImage3.jpeg",
        time: "31 Mar"),
    ChatUsers(
        text: "Philip Fox",
        secondaryText: "Busy! Call me in 20 mins",
        image: "images/userImage4.jpeg",
        time: "28 Mar"),
    ChatUsers(
        text: "Debra Hawkins",
        secondaryText: "Thankyou, It's awesome",
        image: "images/userImage5.jpeg",
        time: "23 Mar"),
    ChatUsers(
        text: "Jacob Pena",
        secondaryText: "will update you in evening",
        image: "images/userImage6.jpeg",
        time: "17 Mar"),
    ChatUsers(
        text: "Andrey Jones",
        secondaryText: "Can you please share the file?",
        image: "images/userImage7.jpeg",
        time: "24 Feb"),
    ChatUsers(
        text: "John Wick",
        secondaryText: "How are you?",
        image: "images/userImage8.jpeg",
        time: "18 Feb"),
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
                          ).createShader(Rect.fromLTWH(0, 0, 80, 70)),
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
                      Positioned(
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
                              "2",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
