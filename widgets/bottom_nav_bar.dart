import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Selected')),
        BottomNavigationBarItem(
            icon: Icon(Icons.list), title: Text('All Tasks')),
        BottomNavigationBarItem(
          icon: Icon(Icons.tab),
          title: Text('Categories'),
        )
      ],
      selectedItemColor: Theme.of(context).cardColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
