import 'package:chatapp/pages/friends/new_friend.dart';
import 'package:chatapp/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:hive/hive.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:transition/transition.dart';

import '../modules/dragbar.dart';

class User {
  String name;
  String username;
  String email;
  String avatar;
  bool online = false;
  int lastSeen;
  String department = "";
  List<User> friends;
  User(
      {required this.name,
      required this.username,
      required this.email,
      required this.avatar,
      required this.online,
      required this.lastSeen,
      required this.friends
      });
}

class FriendPage extends StatefulWidget {
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: FlexThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("好友", style: TextStyle(color: Colors.black)),
            elevation: 0.3,
            actions: [
              IconButton(
                color: Colors.black,
                icon: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.messenger_outline_rounded),
                      Positioned(
                          top: -3,
                          right: -3,
                          child: Stack(
                            children: [
                              Icon(Icons.circle, size: 15, color: Colors.white),
                              Positioned(
                                  right: -1,
                                  child: Icon(Icons.add,
                                      size: 15, color: Colors.black)),
                            ],
                          ))
                    ],
                  ),
                ),
                onPressed: () {
                  ShowNewMessage(context);
                },
              ),
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.person_add_alt_rounded, size: 28),
                onPressed: () {
                  Navigator.push(
                      context,
                      Transition(
                          child: AddFriendPage(),
                          transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
                },
              ),
            ],
          ),
        ));
  }

  Future<dynamic> ShowNewMessage(BuildContext context) {
    List<User> users = [];
    for (int i = 0; i < 10; i++) {
      users.add(
        User(
            name: "陳小明",
            username: "A1105502",
            email: "",
            avatar: "https://i.imgur.com/3x5q2Yk.jpg",
            online: true,
            lastSeen: 0,
            friends: 
            ),
      );
    }
    // Add list
    List<User> UserGroup = [];
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.90,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      DragBar(),
                      Text("邀請好友傳送訊息",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Flexible(
                              child: CupertinoTextField(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                placeholder: "輸入好友的學號或姓名",
                                placeholderStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("開始",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("已選擇 ${UserGroup.length} 位好友",
                            style: TextStyle(fontSize: 14)),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: UserGroup.contains(users[index])
                                    ? Colors.grey[100]
                                    : Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(users[index].avatar),
                                  ),
                                  title: Text(users[index].name),
                                  subtitle: Text(users[index].username),
                                  trailing: IconButton(
                                    icon: !UserGroup.contains(users[index])
                                        ? Icon(Icons.add)
                                        : Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (!UserGroup.contains(users[index])) {
                                          UserGroup.add(users[index]);
                                        } else {
                                          UserGroup.remove(users[index]);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ));
          });
        });
  }
}
