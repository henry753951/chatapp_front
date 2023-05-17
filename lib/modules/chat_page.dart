import 'package:chatapp/components/chat.dart';
import 'package:chatapp/models/chat_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void showModal() {
    List<invite> Invite = [
      invite(
          text: "Jane Russel",
          secondaryText: "Awesome Setup",
          image: "images/userImage1.jpeg",
          time: "Now",
          id: "1"),
      invite(
          text: "Jane Russel",
          secondaryText: "Awesome Setup",
          image: "images/userImage1.jpeg",
          time: "Now",
          id: "2"),
      invite(
          text: "Jane Russel",
          secondaryText: "Awesome Setup",
          image: "images/userImage1.jpeg",
          time: "Now",
          id: "3"),
      invite(
          text: "Glady's Murphy",
          secondaryText: "That's Great",
          image: "images/userImage2.jpeg",
          time: "Yesterday",
          id: "4"),
      invite(
          text: "Jorge Henry",
          secondaryText: "Hey where are you?",
          image: "images/userImage3.jpeg",
          time: "31 Mar",
          id: "5"),
    ];
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              color: Color(0xff737373),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        height: 4,
                        width: 50,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "好友邀請",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      child: ListView.builder(
                        itemCount: Invite.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Dismissible(
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  Invite.removeAt(index);
                                });
                              },
                              background: Container(
                                color: Colors.red,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
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
                                  subtitle: Text(Invite[index].secondaryText),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(Invite[index].time),
                                      Icon(Icons.check_circle),
                                    ],
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
