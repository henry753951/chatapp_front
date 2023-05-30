import 'package:chatview/chatview.dart';

import '../models/chat_users.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final List<Message> messageList = [];
  static List<ChatUsers> chatUsers = [];
  static Map<String, dynamic> currentUser = {
    "id":""
  };
}
