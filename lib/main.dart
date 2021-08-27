import 'package:animated_bottom_navbar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;

  List<Widget> pages = [
    Center(
      child: Container(
        child: ListView.builder(
          itemBuilder: (context, index) => Container(
              color: Colors.white,
              child: Center(
                  child: Text(
                "Home",
                style: TextStyle(fontSize: 48),
              ))),
          itemCount: 20,
        ),
      ),
    ),
    Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Text(
          "Bookmark",
          style: TextStyle(fontSize: 48),
        ))),
    Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Text(
          "Focus",
          style: TextStyle(fontSize: 48),
        ))),
    Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Text(
          "Favorites",
          style: TextStyle(fontSize: 48),
        ))),
    Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Text(
          "Profile",
          style: TextStyle(fontSize: 48),
        ))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages[_selectedIndex]),
      extendBody: true,
      bottomNavigationBar: AnimatedBotomNavigationBar(
        initialPage: 0,
        onTap: _onItemTapped,
        backgroundHeight: 98,
        backgroundColor: Colors.white,
        horizontalMargin: 32,
        animatedMaxHorizontalMargin: 32,
        backgroundAnimatingColor: Colors.lightBlueAccent,
        duration: Duration(milliseconds: 1200),
        items: [
          NavBarItem(
            selectedIcon: Icon(CupertinoIcons.house_fill),
            unselectedIcon: Icon(CupertinoIcons.house),
          ),
          NavBarItem(
            selectedIcon: Icon(CupertinoIcons.bookmark_fill),
            unselectedIcon: Icon(CupertinoIcons.bookmark),
          ),
          NavBarItem(
            selectedIcon: Icon(CupertinoIcons.smallcircle_fill_circle_fill),
            unselectedIcon: Icon(CupertinoIcons.smallcircle_circle),
          ),
          NavBarItem(
            selectedIcon: Icon(CupertinoIcons.heart_fill),
            unselectedIcon: Icon(CupertinoIcons.heart),
          ),
        ],
      ),
    );
  }
}
