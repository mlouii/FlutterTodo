import 'package:flutter/material.dart';
import 'package:todo_app/screens/selected_tasks_screen.dart';
import 'package:todo_app/screens/tasks_overview_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Object> _pages = [SelectedTasksScreen(), TasksOverviewScreen()];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
//    Future.delayed(Duration.zero).then((_) async {
//      await Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
//    });
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
      ),
    );
  }
}
