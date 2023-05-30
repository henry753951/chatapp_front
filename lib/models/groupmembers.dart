import 'package:chatapp/components/chat.dart';
import 'package:chatapp/models/chat_users.dart';
import 'package:chatapp/modules/dragbar.dart';
import 'package:chatview/chatview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:m_toast/m_toast.dart';
import 'package:intl/intl.dart'; // for date format

class MembersModal extends StatefulWidget {
  final List<ChatUser> members;
  const MembersModal({Key? key, required this.members}) : super(key: key);

  @override
  _MembersModalState createState() => _MembersModalState();
}

class _MembersModalState extends State<MembersModal> {
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
              "群組成員",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.members.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ListTile(
                        leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(""),
                            )),
                        title: Text(widget.members[index].name))
                       
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
