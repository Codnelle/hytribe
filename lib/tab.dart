import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hytribe/profile.dart';
import 'package:hytribe/Bot.dart';

class bottomBar extends StatefulWidget {
  const bottomBar({super.key});

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [ChatBotScreen(), Profile()],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(67, 158, 158, 158),
        items: [
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.home,
          //     color: _page == 0 ? Colors.blue : Colors.grey,
          //   ),
          //   label: "",
          //   backgroundColor: const Color.fromARGB(67, 158, 158, 158),
          // ),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.chat,
          //       color: _page == 1 ? Colors.blue : Colors.grey,
          //     ),
          //     label: "",
          //     backgroundColor: Colors.white),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.people,
          //       color: _page == 2 ? Colors.blue : Colors.grey,
          //     ),
          //     label: "",
          //     backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assistant_outlined,
                color: _page == 0 ? Colors.blue : Colors.grey,
              ),
              label: "",
              backgroundColor: const Color.fromARGB(67, 158, 158, 158)),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.face,
                color: _page == 1 ? Colors.blue : Colors.grey,
              ),
              label: "",
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
