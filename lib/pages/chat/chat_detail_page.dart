// import 'package:chatapp/components/chat_bubble.dart';
// import 'package:chatapp/components/chat_detail_page_appbar.dart';
// import 'package:chatapp/models/chat_message.dart';
// import 'package:chatapp/models/send_menu_items.dart';
import 'dart:convert';

import 'package:chatapp/services/socket.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/components/theme.dart';
import 'package:chatapp/components/data.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:chatapp/pages/friends_page.dart';
import 'package:uuid/uuid.dart';
import 'package:chatapp/models/groupmembers.dart';

MessageType getMessageType(String text) {
  switch (text) {
    case "MessageType.text":
      return MessageType.text;
    case "MessageType.image":
      return MessageType.image;
    case "MessageType.voice":
      return MessageType.voice;
    default:
      return MessageType.text;
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key,
      required this.name,
      required this.room_id,
      required this.room_members})
      : super(key: key);
  final String name;
  final String room_id;
  final List<dynamic> room_members;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;

  late ChatUser currentUser =
      ChatUser(name: widget.name, id: Data.currentUser["id"], profilePhoto: "");
  late ChatController _chatController = ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    chatUsers: [],
  );

  void onMessage(value_) {
    if (value_['room_id'] != widget.room_id) return;
    var value = value_['message'];
    MessageType messageType = getMessageType(value['messageType']);
    MessageType replyMessageType =
        getMessageType(value['replyMessage']['message_type']);

    Message msg = Message(
      id: value['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          (value['createdAt'] as double).toInt()),
      message: value['message'],
      sendBy: value['sendBy'],
      replyMessage: value['replyMessage']['replyBy'] == ''
          ? const ReplyMessage()
          : ReplyMessage(
              messageId: value['replyMessage']['id'],
              messageType: replyMessageType,
              message: value['replyMessage']['message'],
              replyBy: value['replyMessage']['replyBy'],
              replyTo: value['replyMessage']['replyTo'],
              voiceMessageDuration: null,
            ),
      messageType: messageType,
    );
    _chatController.addMessage(msg);
  }

  Future<List<Message>> getMessage() async {
    var auth_box = Hive.box('auth');
    var token = auth_box.get("token");
    Dio dio = Dio();
    List<Message> messages = [];
    dio.options.headers["authorization"] = "Bearer ${token}";
    var response =
        await dio.get("${dotenv.get("baseUrl")}room/${widget.room_id}");

    for (var i in response.data["data"]["messages"]) {
      messages.add(Message(
        id: i["id"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            ((i["createdAt"]) as double).toInt()),
        message: i["message"],
        sendBy: i["sendBy"],
        replyMessage: i["replyMessage"] == null
            ? const ReplyMessage()
            : ReplyMessage(
                messageId: i["replyMessage"]["id"],
                messageType: getMessageType(i["replyMessage"]["message_type"]),
                message: i["replyMessage"]["message"],
                replyBy: i["replyMessage"]["replyBy"],
                replyTo: i["replyMessage"]["replyTo"],
                voiceMessageDuration: null,
              ),
        messageType: getMessageType(i["messageType"]),
      ));
    }
    return messages;
  }

  void getMsg() async {
    Data.messageList[widget.room_id] = await getMessage();
    _chatController.loadMoreData(Data.messageList[widget.room_id]!);

    _chatController.chatUsers = [
      for (var i in widget.room_members)
        ChatUser(
          name: i["user"]["Name"],
          id: i["id"],
          profilePhoto: "",
        )
    ];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SocketService.addListener(onMessage);

    getMsg();
  }

  @override
  void dispose() {
    super.dispose();
    SocketService.removeListener(onMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        currentUser: currentUser,
        chatController: _chatController,
        onSendTap: _onSendTap,
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatViewAppBar(
          onBackPress: () =>
              {Navigator.of(context, rootNavigator: true).pop(context)},
          elevation: theme.elevation,
          backGroundColor: theme.appBarColor,
          profilePicture: Data.profileImage,
          backArrowColor: theme.backArrowColor,
          chatTitle: widget.name,
          chatTitleTextStyle: TextStyle(
            color: theme.appBarTitleTextStyle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.25,
          ),
          userStatus: "線上",
          userStatusTextStyle: const TextStyle(color: Colors.grey),
          actions: [
            IconButton(
              onPressed: _onThemeIconTap,
              icon: Icon(
                isDarkTheme
                    ? Icons.brightness_4_outlined
                    : Icons.dark_mode_outlined,
                color: theme.themeIconColor,
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    builder: (context) {
                      return MembersModal(members: _chatController.chatUsers);
                    }).then((value) => {
                    });
              },
              icon: Icon(
                Icons.face,
                color: theme.themeIconColor,
              ),
            ),
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            hintText: "輸入訊息",
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          micIconColor: theme.replyMicIconColor,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: theme.waveformBackgroundColor,
            recorderIconColor: theme.recordIconColor,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: theme.waveColor ?? Colors.white,
              extendWaveform: true,
            ),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: theme.replyPopupColor,
          buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.messageReactionBackGroundColor,
            borderColor: theme.messageReactionBackGroundColor,
            reactedUserCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: theme.backgroundColor,
              reactedUserTextStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: theme.inComingChatBubbleColor,
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.fromARGB(5, 0, 0, 0)
                        : Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: theme.shareIconBackgroundColor,
              defaultIconColor: theme.shareIconColor,
            ),
          ),
        ),
        profileCircleConfig:
            ProfileCircleConfiguration(profileImageUrl: Data.profileImage),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.repliedMessageColor,
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.orange,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    var toServer = {
      "id": const Uuid().v4(),
      "message": message,
      "sendBy": currentUser.id,
      "messageType": messageType.toString(),
      "replyMessage": {
        'message': replyMessage.message,
        'replyBy': replyMessage.replyBy,
        'replyTo': replyMessage.replyTo,
        'message_type': replyMessage.messageType.toString(),
        'id': replyMessage.messageId,
        'voiceMessageDuration': replyMessage.voiceMessageDuration,
      },
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    };
    SocketService.stompClient.send(
        destination: "/app/chat",
        body: json.encode({"room_id": widget.room_id, "message": toServer}));
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}
