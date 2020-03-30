import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';
import 'package:todo_app/screens/new_item_screen.dart';
import 'package:todo_app/widgets/bottom_nav_bar.dart';
import 'package:todo_app/widgets/task_item.dart';

class TasksOverviewScreen extends StatelessWidget {
  static const routeName = '/TasksOverview';

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Tasks',
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Theme.of(context).cardColor,
            onPressed: () {
              Navigator.of(context).pushNamed(NewItemScreen.routeName);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(93, 115, 160, 0.56),
              const Color.fromRGBO(239, 117, 145, 0.49)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Center(
            child: ListView.builder(
          itemBuilder: (ctx, i) => TaskItemWidget(
            description: tasksData.tasks[i].description,
            title: tasksData.tasks[i].title,
            duration: tasksData.tasks[i].duration,
            id: tasksData.tasks[i].id,
          ),
          itemCount: tasksData.tasks.length,
        )),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
