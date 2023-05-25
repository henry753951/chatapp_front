import 'package:chatapp/pages/chat/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUsersList extends StatefulWidget {
  String text;
  String secondaryText;
  String image;
  String time;
  bool isMessageRead;
  ChatUsersList(
      {required this.text,
      required this.secondaryText,
      required this.image,
      required this.time,
      required this.isMessageRead});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return ChatDetailPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Avata(
                    image: widget.image,
                    isOnline: true,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text, style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.secondaryText,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 13,
                  color: widget.isMessageRead
                      ? Colors.pink
                      : Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class Avata extends StatelessWidget {
  final String image;
  final bool isOnline;
  final Color color;
  final double radius;
  final double dotWidth;
  const Avata({
    super.key,
    required this.image,
    required this.isOnline,
    this.color = const Color.fromARGB(255, 226, 235, 113),
    this.radius = 35.0,
    this.dotWidth = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: radius,
          backgroundColor: color,
        ),
        Visibility(
          visible: isOnline,
          child: Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: dotWidth,
              width: dotWidth,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 67, 190, 72),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.0)),
            ),
          ),
        )
      ],
    );
  }
}
