import 'package:flutter/material.dart';
import 'package:selfintro/screens/chat/chat.dart';
import 'package:selfintro/screens/items/Item_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget? _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return const ItemsPage();
      case 1:
        return const Chat();
    }
    return null;
  }

  Widget _bottomWidget() {
    return BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        selectedFontSize: 13,
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                )),
            label: 'item',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.home_rounded, color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.chat,
                  color: Colors.white,
                )),
            label: 'chat',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.chat, color: Colors.white)),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bodyWidget(),
        bottomNavigationBar: _bottomWidget(),
      ),
    );
  }
}
