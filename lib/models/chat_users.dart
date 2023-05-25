import 'package:flutter/cupertino.dart';

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;
  ChatUsers(
      {required this.text,
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
