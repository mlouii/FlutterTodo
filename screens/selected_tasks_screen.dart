import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';
import 'package:todo_app/screens/new_item_screen.dart';
import 'package:todo_app/widgets/task_item.dart';

class SelectedTasksScreen extends StatefulWidget {
  static const routeName = '/SelectedOverview';

  @override
  _SelectedTasksScreenState createState() => _SelectedTasksScreenState();
}

var _isLoading = false;

class _SelectedTasksScreenState extends State<SelectedTasksScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
    });
    super.initState();
  }

  String formatDuration(Duration duration) {
    String toReturn = '';
    int hours = int.parse(duration.toString().split(':')[0]);
    int minutes = int.parse(duration.toString().split(':')[1]);
    if (hours > 0) {
      toReturn = "${hours}h";
    }
    if (minutes > 0) {
      toReturn = toReturn + " ${minutes}m";
    }
    return toReturn;
  }

  String _getSelectedDurations(List<TaskItem> items) {
    Duration myDur = Duration.zero;
    items.forEach((item) {
      myDur = myDur + item.duration;
    });
    return formatDuration(myDur);
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selected Tasks',
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
        child: _isLoading
            ? Center(
                child: Text(
                  'Loading Tasks!',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              )
            : (tasksData.selectedTasks.length < 1)
                ? Center(
                    child: (tasksData.tasks.length > 0)
                        ? Text(
                            'No tasks are selected!',
                            style: Theme.of(context).textTheme.subtitle,
                          )
                        : Text(
                            'You have no tasks, how about you add some?',
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                  )
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  offset: Offset(-0.5, 2))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'You have ${tasksData.selectedTasks.length} tasks selected',
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Total Time: ${_getSelectedDurations(tasksData.selectedTasks)}',
                                  style: Theme.of(context).textTheme.subtitle,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => TaskItemWidget(
                            description: tasksData.selectedTasks[i].description,
                            title: tasksData.selectedTasks[i].title,
                            duration: tasksData.selectedTasks[i].duration,
                            id: tasksData.selectedTasks[i].id,
                            isSelected: tasksData.selectedTasks[i].isSelected,
                          ),
                          itemCount: tasksData.selectedTasks.length,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
