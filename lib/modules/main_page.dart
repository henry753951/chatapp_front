import 'package:chatapp/modules/Example_page.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class MainPage extends StatefulWidget{  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex=0;
  final PageController _pageController = PageController(keepPage: true);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: PageView(
              controller: _pageController,

              onPageChanged: (page) {
                setState(() {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }
                  _currentIndex = page;
                });
              },
              children: [ChatPage(),ExamplePage()],
            ),
          ),
        ),
        bottomNavigationBar: _buildTitle(context),
      ),
    );
  }

  Widget _buildTitle(context) {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff040307),
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
          title: Text("訊息"),
        ),
        CustomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_crop_circle_fill),
          title: Text("個人檔案"),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 250), curve: Curves.ease);
          _currentIndex = index;
        });
      },
    );
  }

}