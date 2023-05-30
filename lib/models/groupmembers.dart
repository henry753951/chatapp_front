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

class MembersModal extends StatefulWidget {
  @override
  _MembersModalState createState() => _MembersModalState();
}

class _MembersModalState extends State<MembersModal> {
  ShowMToast toast = ShowMToast();
  DismissDirection _dismissDirection = DismissDirection.horizontal;
  List<invite> Invite = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Column(
          children: <Widget>[
            DragBar(),
            Text(
              "好友邀請",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Invite.isEmpty
                  ? (loading
                      ? Center(
                          child: Text('載入中...'),
                        )
                      : Center(
                          child: Text('列表為空'),
                        ))
                  : ListView.builder(
                      itemCount: Invite.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Dismissible(
                            direction: _dismissDirection,
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                Invite.removeAt(index);
                                setState(() {});
                              } else {
                                setState(() {
                                  Invite.removeAt(index);
                                });
                              }
                            },
                            dragStartBehavior: DragStartBehavior.down,
                            background: const ColoredBox(
                              color: Color.fromARGB(255, 93, 196, 136),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.check, color: Colors.white),
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
                                    Text(DateFormat('yyyy-MM-dd hh:mm:ss')
                                        .format(Invite[index].time.toLocal())),
                                  ],
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                      onTap: () {
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
  }
}
