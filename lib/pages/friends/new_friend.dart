import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:m_toast/m_toast.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  String username = "";
  final ShowMToast toast = ShowMToast();
  void submit() async {
    Dio dio = new Dio();
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response =
        await dio.put("${dotenv.get("baseUrl")}invite/invite", data: username);
    if (response.data["msg"] == "成功!") {
      toast.successToast(context,
          alignment: Alignment.topLeft, message: "已送出邀請!");
      Navigator.pop(context);
    } else {
      toast.errorToast(context,
          alignment: Alignment.topLeft, message: response.data["msg"]);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: TextButton(
              child: Text("關閉", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("新增好友", style: TextStyle(color: Colors.black)),
            elevation: 0.21,
          ),
          body: Container(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "在 ININDER 上面尋找你的朋友",
                    style: GoogleFonts.notoSans(
                        fontSize: 23, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("通過使用者學號來新增",
                            style: GoogleFonts.notoSans(
                                fontSize: 15,
                                color: const Color.fromARGB(255, 75, 75, 75))),
                        SizedBox(height: 5),
                        Container(
                          width: 300,
                          child: CupertinoTextField(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              placeholder: "輸入好友的學號",
                              placeholderStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              }),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 255, 0, 0),
                                Color.fromARGB(255, 255, 94, 0),
                                const Color.fromARGB(255, 255, 165, 0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CupertinoButton(
                            child: Text("新增好友",
                                style: GoogleFonts.notoSans(
                                    fontSize: 15, color: Colors.white)),
                            onPressed: () {
                              submit();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              "你的學號是 ${Hive.box("auth").get("user")['username']}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 102, 102, 102))),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ));
  }
}
