import 'dart:math';

import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:chatapp/components/dialog.dart';
import 'package:chatapp/pages/main_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'auth/login.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class User {
  String name = "";
  String username = "";
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User();
  void getUser() async {
    var authBox = await Hive.openBox('auth');
    setState(() {
      user.name = authBox.get("user")["Name"];
      user.username = authBox.get("user")["username"];
    });
  }

  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });

    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image!.path,
          filename: image!.path.split('/').last),
    });
    var response =
        await dio.post("${dotenv.get("baseUrl")}user/avatar", data: formData);
    print(response);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("個人檔案",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Colors.red, Colors.orange],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 80.0, 70.0)),
                        )),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Stack(clipBehavior: Clip.none, children: [
                    CircleAvatar(
                      // if image is null then show placeholder else show the image
                      backgroundImage: image == null
                          ? AssetImage('lib/images/karbi.jpg')
                          : AssetImage(image!.path),
                      radius: 50.0,
                      // backgroundColor: Color.fromARGB(255, 226, 235, 113),
                    ),
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: Container(
                          child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => {
                          YYDialog().build()
                            ..width = 240
                            ..height = 180
                            ..borderRadius = 10.0
                            ..widget(
                              Padding(
                                padding: EdgeInsets.all(35),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 20),
                                          padding: const EdgeInsets.all(10.0),
                                        ),
                                        onPressed: () {
                                          getImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                        child: Text("拍照"),
                                      ),
                                      ClipRRect(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle:
                                                const TextStyle(fontSize: 20),
                                            padding: const EdgeInsets.all(10.0),
                                          ),
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                          child: Text("從相簿選擇"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            ..show()
                        },
                      )),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(user.name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 75, 75, 75),
                    )),
                const SizedBox(
                  height: 35,
                ),
                info(
                  icon: Icon(CupertinoIcons.creditcard, color: Colors.orange),
                  title: "學號",
                  value: user.username,
                ),
                Row(
                  children: [
                    info(
                      icon: Icon(Icons.cake_outlined, color: Colors.orange),
                      title: "生日",
                      value: "07/14",
                    )
                  ],
                ),
                info(
                  icon: Icon(CupertinoIcons.phone, color: Colors.orange),
                  title: "手機號碼",
                  value: "0965494854",
                ),
              ],
            ),
          ),
          const Spacer(),
          LogoutBtn(),
          const SizedBox(
            height: 35,
          ),
        ],
      )),
    );
  }
}

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Center(
        child: SingleChildScrollView(
          child: TextButton(
            onPressed: () {
              Hive.box('auth').delete("token");
              Hive.box('auth').delete("user");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: Text(
              "登出",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class info extends StatelessWidget {
  ChangValue() {}
  Icon icon;
  String title;
  String value;
  info({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1,
            ),
            Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: const Color.fromARGB(255, 215, 215, 215),
                  width: 1,
                ))),
                child: Row(children: [
                  Row(
                    children: [
                      icon,
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox(), flex: 1),
                  TextButton(
                      onPressed: () {
                        YYDialog().build()
                          ..width = 240
                          ..height = 130
                          ..borderRadius = 10.0
                          ..widget(
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextField(
                                        onChanged: (text) {
                                          value = text;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '請輸入新的手機號碼',
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          onPressed: () {
                                            ChangValue();
                                            Navigator.pop(context);
                                          },
                                          child: Text("修改"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          ..show();
                      },
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 16, height: 1.4, color: Colors.grey),
                      )),
                ]))
          ],
        ));
  }
}
// YYDialog().build()
                        //   ..width = 240
                        //   ..height = 130
                        //   ..borderRadius = 10.0
                        //   ..widget(
                        //     Padding(
                        //       padding: EdgeInsets.all(10),
                        //       child: Align(
                        //         alignment: Alignment.bottomCenter,
                        //         child: Column(
                        //           children: [
                        //             TextField(
                        //               onChanged: (text) {
                        //                 value = text;
                        //               },
                        //               decoration: InputDecoration(
                        //                 border: OutlineInputBorder(),
                        //                 labelText: '請輸入新的手機號碼',
                        //               ),
                        //             ),
                        //             Container(
                        //               alignment: Alignment.centerRight,
                        //               child: TextButton(
                        //                 style: TextButton.styleFrom(
                        //                   textStyle:
                        //                       const TextStyle(fontSize: 20),
                        //                 ),
                        //                 onPressed: () {
                        //                   ChangValue();
                        //                   Navigator.pop(context);
                        //                 },
                        //                 child: Text("修改"),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   )
                        //   ..show();