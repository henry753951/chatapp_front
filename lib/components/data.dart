import 'package:chatview/chatview.dart';

import '../models/chat_users.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final messageList = [
    Message(
      id: '13',
      message: "https://stackoverflow.com/questions/55536461/flutter-unhandled-exception-bad-state-cannot-add-new-events-after-calling-clo",
      createdAt: DateTime.now(),
      sendBy: '2',
      reaction: Reaction(reactions: ['\u{2764}'], reactedUserIds: ['1']),
    ),
  ];
  static List<ChatUsers> chatUsers = [];
}
