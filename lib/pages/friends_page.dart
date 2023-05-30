import 'package:chatapp/components/chat.dart';
import 'package:chatapp/pages/friends/new_friend.dart';
import 'package:chatapp/pages/main_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transition/transition.dart';

import '../modules/dragbar.dart';

class User {
  String name;
  String id;
  String username;
  String email;
  String avatar;
  bool online = false;
  int lastSeen;
  String department = "";
  User(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.avatar,
      required this.online,
      required this.lastSeen});
}

class FriendPage extends StatefulWidget {
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  // get friends
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late Future<List<User>> futureFriendsList = Future.value([]);
  Future<void> getFriends() async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.get("${dotenv.get("baseUrl")}friend/friend");
    print(response.data);
    if (response.data["success"]) {
      var data = response.data["data"];
      List<User> friends = [
        for (var i in data)
          User(
            id: i["id"],
            name: i["user"]["Name"],
            username: i["user"]["username"],
            email: i["user"]["email"],
            avatar: i["avatar"],
            online: i["online"],
            lastSeen: i["lastSeen"],
          )
      ];
      setState(() {
        futureFriendsList = Future.value(friends);
        _refreshController.refreshCompleted();
      });
    }
  }

  void deleteFriend(String id) async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response =
        await dio.delete("${dotenv.get("baseUrl")}friend/friend", data: id);

    if (response.data["success"]) {
      getFriends();
    }
  }

  @override
  void MakeGroup(String groupname, List<User> ug) async {
    List<String> uid_list = [];
    for (User user in ug) {
      uid_list.add(user.id);
    }
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response = await dio.post("${dotenv.get("baseUrl")}room",
        data: {"roomname": groupname, "memberIds": uid_list});

    if (response.data["success"]) {
      getFriends();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends();
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
                  ShowNewMessage(context, futureFriendsList);
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
          body: FutureBuilder<List<User>>(
              future: futureFriendsList,
              builder: (context, snapshot) {
                return SmartRefresher(
                    physics: BouncingScrollPhysics(),
                    header: ClassicHeader(
                      idleText: "下拉刷新",
                      refreshingText: "更新中",
                      completeText: "更新完成",
                      releaseText: "放開更新",
                      failedText: "更新失敗",
                      refreshingIcon: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    controller: _refreshController,
                    onRefresh: getFriends,
                    child: FriendList(snapshot));
              }),
        ));
  }

  Widget FriendList(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            return ListTile(
              leading: Avata(
                  image: snapshot.data[index].avatar,
                  isOnline: snapshot.data[index].online,
                  radius: 25,
                  dotWidth: 15),
              title: Text(snapshot.data[index].name),
              subtitle: Text(snapshot.data[index].username),
              trailing: PopupMenuButton<String>(
                child: Icon(Icons.more_vert),
                onSelected: (String item) {
                  switch (item) {
                    case "delete":
                      print("delete");
                      deleteFriend(snapshot.data[index].id);
                      break;
                    default:
                      print(item);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "d",
                    child: Text('Item 1'),
                  ),
                  const PopupMenuItem<String>(
                    value: "delete",
                    child: Text('刪除好友'),
                  ),
                ],
              ),
            );
          },
          itemCount: snapshot.data.length);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future<dynamic> ShowNewMessage(BuildContext context, snapshot) {
    List<User> users = [];
    snapshot.then((value) {
      users = value;
    });
    print(users);

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
                            GestureDetector(
                              onTap: () {
                                if (UserGroup.length == 2) {
                                  MakeGroup("", UserGroup);
                                } else {
                                  MakeGroup("group", UserGroup);
                                }
                              },
                              child: Container(
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
