import 'package:flutter/cupertino.dart';
import 'package:chatapp/pages/friends_page.dart';

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;
  String roomid;
  List<dynamic> room_members;
  ChatUsers(
      {required this.roomid,
      required this.room_members,
      required this.text,
      required this.secondaryText,
      required this.image,
      required this.time});
}

class invite {
  String text;
  String image;
  DateTime time;
  String id;
  invite(
      {required this.text,
      required this.image,
      required this.time,
      required this.id});
}
