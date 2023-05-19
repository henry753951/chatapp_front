import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:m_toast/m_toast.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';

import 'main_page.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  bool resentButtonDisabled = true;
  String code = "";
  final ShowMToast toast = ShowMToast();
  void submitCode() async {
    var auth_box = await Hive.openBox('auth');
    var token = auth_box.get("token");
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer ${token}";
    Response response =
        await dio.post("http://192.168.0.70:8080/auth/verify", data: code);
    print(response.data);
    if (response.data["msg"] == "驗證成功") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      toast.errorToast(context,
          alignment: Alignment.topLeft, message: response.data["msg"]);
      auth_box.put("token", response.data["data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    @override
    void initState() {}

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.07,
              ),
              Text(
                '請輸入驗證碼',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 32.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '請輸入發送到以下郵件的驗證碼\n',
                      style: GoogleFonts.urbanist(
                        fontSize: 15.0,
                        color: const Color(0xff808d9e),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'a1105534@mail.nuk.edu.tw',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.orange,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),

              /// pinput package we will use here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: width,
                  child: Pinput(
                    onChanged: (value) => {
                      code = value,
                    },
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      height: 60.0,
                      width: 60.0,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(
                          color: Color.fromARGB(255, 141, 141, 141),
                          width: 1.0,
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      height: 60.0,
                      width: 60.0,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 24.0,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: !resentButtonDisabled
                    ? TextButton(
                        child: Text(
                          '重新發送認證',
                          style: GoogleFonts.urbanist(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            resentButtonDisabled = true;
                          });
                        },
                      )
                    : CountdownWidget(
                        endTime:
                            DateTime.now().add(const Duration(seconds: 120)),
                        callback: () {
                          setState(() {
                            resentButtonDisabled = false;
                          });
                        },
                      ),
              ),

              ///

              /// Continue Button
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  submitCode();
                },
                borderRadius: BorderRadius.circular(30.0),
                child: Ink(
                  height: 55.0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      '下一步',
                      style: GoogleFonts.urbanist(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownWidget extends StatefulWidget {
  final DateTime endTime;
  final void Function() callback;
  const CountdownWidget(
      {super.key, required this.endTime, required this.callback});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  Timer? _timer;
  void TimerFunc(Timer timer) {
    if (widget.endTime.difference(DateTime.now()).inSeconds <= 0) {
      _timer?.cancel();
      widget.callback();
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), TimerFunc);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text("${widget.endTime.difference(DateTime.now()).inSeconds} " + "秒",
        style: const TextStyle(
            fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500));
  }
}
