import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'store_screen.dart';
import 'inventory_screen.dart';
import 'diary_screen.dart';
import 'cat.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    StoreScreen(),
    InventoryScreen(),
    Cat(),
    DiaryScreen(),
    DiaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.yellow, // 바텀 네비게이션 바의 배경색
        type: BottomNavigationBarType.fixed, // 아이템이 고정되도록 설정
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.shopping_cart,
              size: 30,
              color: Colors.white, // 아이콘의 색상
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.cube_box_fill,
              size: 30,
              color: Colors.white, // 아이콘의 색상
            ),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              size: 30,
              color: Colors.white, // 아이콘의 색상
            ),
            label: 'Cat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.cube_box_fill,
              size: 30,
              color: Colors.white, // 아이콘의 색상
            ),
            label: 'CheckList',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.book_fill,
              size: 30,
              color: Colors.white, // 아이콘의 색상
            ),
            label: 'Diary',
          ),
        ],
      ),
    );
  }
}
