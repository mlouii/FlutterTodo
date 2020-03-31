import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';
import 'package:todo_app/screens/new_item_screen.dart';
import 'package:todo_app/widgets/bottom_nav_bar.dart';
import 'package:todo_app/widgets/task_item.dart';

class TasksOverviewScreen extends StatefulWidget {
  static const routeName = '/TasksOverview';

  @override
  _TasksOverviewScreenState createState() => _TasksOverviewScreenState();
}

class _TasksOverviewScreenState extends State<TasksOverviewScreen> {
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
        child: (tasksData.nonSelectedTasks.length < 1)
            ? Center(
                child: (tasksData.selectedTasks.length > 0)
                    ? Text(
                        'All tasks are selected!',
                        style: Theme.of(context).textTheme.subtitle,
                      )
                    : Text(
                        'You have no tasks, how about you add some?',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
              )
            : Center(
                child: ListView.builder(
                itemBuilder: (ctx, i) => TaskItemWidget(
                  description: tasksData.nonSelectedTasks[i].description,
                  title: tasksData.nonSelectedTasks[i].title,
                  duration: tasksData.nonSelectedTasks[i].duration,
                  id: tasksData.nonSelectedTasks[i].id,
                ),
                itemCount: tasksData.nonSelectedTasks.length,
              )),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
