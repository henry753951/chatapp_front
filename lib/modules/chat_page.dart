import 'package:chatapp/components/chat.dart';
import 'package:chatapp/models/chat_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
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
                  Container(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 2, bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.orange[50],
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 255, 176, 57),
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            "新訊息",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 209, 152, 66)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              child: CupertinoSearchTextField(
                  placeholder: "搜尋",
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
