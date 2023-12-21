import 'package:flutter/material.dart';
import 'package:travelplan/homepage.dart';
import 'package:travelplan/notespage.dart';
import 'package:travelplan/planspage.dart';
import 'package:travelplan/profilepage.dart';
import 'package:travelplan/searchpage.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    PlanPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 30,
            right: 30,
            child: Container(
              margin: EdgeInsets.all(20),
              height: 70,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNavBarItem(Icons.home_rounded, 0),
                  buildNavBarItem(Icons.notes_rounded, 1),
                  buildNavBarItem(Icons.search_rounded, 2),
                  buildNavBarItem(Icons.person_4_rounded, 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 5),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          icon: Icon(
            icon,
            color: _selectedIndex == index
                ? Color.fromARGB(184, 99, 99, 229)
                : Color(0xffB9D4DC),
            size: 30,
          ),
        ),
        Container(
          height: 3,
          width: 25,
          decoration: BoxDecoration(
            color: _selectedIndex == index
                ? Color.fromARGB(184, 99, 99, 229)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],
    );
  }
}

class FloatNavBar extends StatelessWidget {
  const FloatNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 5,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home_rounded,
                  color: Color.fromARGB(184, 99, 99, 229),
                  size: 30,
                ),
              ),
              Container(
                height: 3,
                width: 25,
                decoration: BoxDecoration(
                  color: Color.fromARGB(184, 99, 99, 229),
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notes_rounded,
              color: Color(0xffB9D4DC),
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              color: Color(0xffB9D4DC),
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_4_rounded,
              color: Color(0xffB9D4DC),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
